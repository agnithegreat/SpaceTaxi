/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view.scenes.game
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.enums.PlanetType;
    import com.agnither.spacetaxi.model.Order;
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.Space;
    import com.agnither.spacetaxi.view.scenes.game.effects.ExplosionEffect;
    import com.agnither.utils.gui.components.AbstractComponent;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.textures.Texture;
    import starling.utils.Color;

    public class SpaceView extends AbstractComponent implements IAnimatable
    {
        private static const GAP: int = 14;

        private static const MAX_DOTS: int = 200;

        private static var colors: Array = [0x85651f, 0x85292d, 0x4c5f12, 0x1b6d5f, 0x1b4b6d, 0x41207e, 0x7e2074, 0x8a223b];
        private static var colorTime: Number = 5;

        private var _space: Space;

        private var _background: Image;
        private var _overlay: Image;
        private var _stars: Image;

        private var _container: Sprite;
        private var _planetsContainer: Sprite;
        private var _objectsContainer: Sprite;
        private var _effectsContainer: Sprite;

        private var _shipView: ShipView;
        private var _planets: Vector.<PlanetView>;
        private var _orders: Vector.<OrderView>;

        private var _trajectory: Sprite;
        private var _trajectoryLength: Number;
        private var _aimMode: Boolean;

        private var _previousDot: Point;
        private var _dotCounter: int;

        private var _viewport: Rectangle;
        private var _basePivotX: Number;
        private var _basePivotY: Number;
        private var _baseScale: Number;

        private var _aiming: Boolean;

        private var _time: Number;

        public function SpaceView(space: Space)
        {
            super();
            
            _space = space;
            _space.addEventListener(Space.SHOW_TRAJECTORY, handleShowTrajectory);
            _space.addEventListener(Space.UPDATE_TRAJECTORY, handleUpdateTrajectory);
            _space.addEventListener(Space.HIDE_TRAJECTORY, handleHideTrajectory);
            _space.addEventListener(Space.STEP, handleStep);
        }

        override protected function initialize():void
        {
            _background = new Image(Application.assetsManager.getTexture("space_pattern"));
            _background.pivotX = _background.width * 0.5;
            _background.pivotY = _background.height * 0.5;
            _background.tileGrid = new Rectangle(0, 0, _background.width, _background.height);
            _background.width = stage.stageWidth * 2;
            _background.height = stage.stageHeight * 2;
            _background.x = stage.stageWidth * 0.5;
            _background.y = stage.stageHeight * 0.5;
            addChild(_background);

            _stars = new Image(Application.assetsManager.getTexture("stars_pattern"));
            _stars.pivotX = _stars.width * 0.5;
            _stars.pivotY = _stars.height * 0.5;
            _stars.tileGrid = new Rectangle(0, 0, _stars.width, _stars.height);
            _stars.width = stage.stageWidth * 2;
            _stars.height = stage.stageHeight * 2;
            _stars.x = stage.stageWidth * 0.5;
            _stars.y = stage.stageHeight * 0.5;
            addChild(_stars);

            _overlay = new Image(Texture.fromColor(100, 100, 0xFFFFFF, 0.2));
            _overlay.width = stage.stageWidth;
            _overlay.height = stage.stageHeight;
            addChild(_overlay);

            _container = new Sprite();
            addChild(_container);

            _planetsContainer = new Sprite();
            _container.addChild(_planetsContainer);

            _planets = new <PlanetView>[];
            for (var i:int = 0; i < _space.planets.length; i++)
            {
                var planet: Planet = _space.planets[i];
                if (planet.type == PlanetType.BLACK_HOLE)
                {
                    var blackHoleView: BlackHoleView = new BlackHoleView(planet);
                    _planetsContainer.addChild(blackHoleView);
                } else {
                    var planetView: PlanetView = new PlanetView(planet);
                    _planetsContainer.addChild(planetView);
                    _planets.push(planetView);
                }
            }

            _orders = new <OrderView>[];
            for (i = 0; i < _space.orders.orders.length; i++)
            {
                var order: Order = _space.orders.orders[i];

                var departure: OrderView = new OrderView(order.departure, false);
                _container.addChild(departure);
                _orders.push(departure);

                var arrival: OrderView = new OrderView(order.arrival, true);
                _container.addChild(arrival);
                _orders.push(arrival);
            }

            _trajectory = new Sprite();
            _container.addChild(_trajectory);

            _objectsContainer = new Sprite();
            _container.addChild(_objectsContainer);

            _effectsContainer = new Sprite();
            _container.addChild(_effectsContainer);

            addShip();

            _viewport = _space.viewport;
            _baseScale = Math.min(stage.stageWidth / _viewport.width, stage.stageHeight / _viewport.height) * 0.85;
            _basePivotX = _viewport.x + _viewport.width / 2;
            _basePivotY = _viewport.y + _viewport.height / 2;

            _container.x = stage.stageWidth / 2;
            _container.y = stage.stageHeight / 2;
            _container.pivotX = _basePivotX;
            _container.pivotY = _basePivotY;
            _container.scaleX = _baseScale;
            _container.scaleY = _baseScale;

            _previousDot = new Point();

            Starling.current.stage.addEventListener(TouchEvent.TOUCH, handleTouch);

            handleStep(null);

            _time = 0;
            Starling.juggler.add(this);
        }

        private function addShip():void
        {
            _shipView = new ShipView(_space.ship);
            _shipView.addEventListener(ShipView.EXPLODE, handleExplode);
            _objectsContainer.addChild(_shipView);
        }

        private function handleExplode(event: Event):void
        {
            _shipView.removeEventListener(ShipView.EXPLODE, handleExplode);

            var explosion: ExplosionEffect = new ExplosionEffect();
            explosion.x = _shipView.x;
            explosion.y = _shipView.y;
            _effectsContainer.addChild(explosion);
        }

        private function handleTouch(event: TouchEvent):void
        {
            var touch: Touch = event.getTouch(stage);
            if (touch != null)
            {
                switch (touch.phase)
                {
                    case TouchPhase.HOVER:
                    {
                        break;
                    }
                    case TouchPhase.BEGAN:
                    case TouchPhase.MOVED:
                    {
                        var position: Point = touch.getLocation(_shipView);
                        if (Point.distance(position, new Point()) <= 50)
                        {
                            _aiming = true;
                        }
                        if (_aiming)
                        {
                            _space.setPullPoint(position.x, position.y);
                        }
                        break;
                    }
                    case TouchPhase.ENDED:
                    {
                        if (_aiming)
                        {
                            _space.launch();
                            _aiming = false;
                        }
                        break;
                    }
                }
            }
        }

        private function handleShowTrajectory(event: Event):void
        {
            resetTrajectory();
            _aimMode = true;
        }

        private function handleUpdateTrajectory(event: Event):void
        {
            if (_aimMode)
            {
                updateTrajectory(_space.trajectoryTime);
            }
        }

        private function handleHideTrajectory(event: Event):void
        {
            resetTrajectory();
            _aimMode = false;
        }

        private function updateTrajectory(time: Number):void
        {
            var end: int = Math.min(_space.trajectory.length, time / Space.DELTA);
            if (_aimMode)
            {
                end = Math.min(end, Space.TRAJECTORY_LENGTH);
            }
            if (_space.trajectory.length < end) return;

            for (var i: int = _trajectoryLength; i < end; i++)
            {
                var point: Point = _space.trajectory[i];
                if (Point.distance(point, _previousDot) >= GAP)
                {
                    var dot: Image = new Image(Application.assetsManager.getTexture("misc/dot"));
                    dot.pivotX = dot.width/2;
                    dot.pivotY = dot.height/2;
                    const min: Number = 0.6;
                    const max: Number = 1 - (1-min) * _dotCounter / MAX_DOTS;
                    dot.scaleX = 0.25 * Math.max(min, max);
                    dot.scaleY = 0.25 * Math.max(min, max);
                    dot.x = point.x;
                    dot.y = point.y;
                    _trajectory.addChild(dot);
                    _dotCounter++;
                    _previousDot = point;
                }
            }
            _trajectoryLength = end;
        }

        private function resetTrajectory():void
        {
            _trajectory.removeChildren(0, -1, true);
            _trajectoryLength = 0;

            _dotCounter = 0;
        }

        private function handleStep(event: Event):void
        {
            var sx: Number = Math.max(_basePivotX - _viewport.width, Math.min(_shipView.x, _basePivotX + _viewport.width));
            var sy: Number = Math.max(_basePivotY - _viewport.height, Math.min(_shipView.y, _basePivotY + _viewport.height));
            var scale: Number = 1 - ((Math.abs((sx-_basePivotX) / _viewport.width) + Math.abs((sy-_basePivotY) / _viewport.height))) * 0.25;

            Starling.juggler.tween(_container, event != null ? 0.3 : 0, {
                pivotX: (_basePivotX + sx) / 2,
                pivotY: (_basePivotY + sy) / 2,
                scaleX: _baseScale * scale,
                scaleY: _baseScale * scale
            });

            var dx: Number = sx - _basePivotX;
            var dy: Number = sy - _basePivotY;

            Starling.juggler.tween(_background, event != null ? 0.3 : 0, {
                x: stage.stageWidth * 0.5 - dx * 0.05,
                y: stage.stageHeight * 0.5 - dy * 0.05
            });

            Starling.juggler.tween(_stars, event != null ? 0.3 : 0, {
                x: stage.stageWidth * 0.5 - dx * 0.1,
                y: stage.stageHeight * 0.5 - dy * 0.1
            });

            if (!_aimMode)
            {
                updateTrajectory(_space.flightTime);
            }

            if (!_shipView.getBounds(stage).intersects(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight)))
            {
                _space.ship.crash();
            }
        }

        public function advanceTime(time: Number):void
        {
            _time += time;
            while (_time >= colorTime)
            {
                _time -= colorTime;
                colors.push(colors.shift());
            }

            _overlay.color = Color.interpolate(colors[0], colors[1], _time / colorTime);
        }
    }
}
