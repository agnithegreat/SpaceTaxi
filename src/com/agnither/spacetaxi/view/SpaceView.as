/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.Space;
    import com.agnither.spacetaxi.view.effects.ExplosionEffect;
    import com.agnither.utils.gui.components.AbstractComponent;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.core.Starling;
    import starling.display.Canvas;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.geom.Polygon;
    import starling.text.TextField;
    import starling.text.TextFieldAutoSize;
    import starling.text.TextFormat;

    public class SpaceView extends AbstractComponent
    {
        private static const DASH_LENGTH: int = 10;
        private static const GAP_LENGTH: int = 4;

        private var _space: Space;

        private var _background: Image;
        private var _stars: Image;

        private var _container: Sprite;
        private var _planetsContainer: Sprite;
        private var _objectsContainer: Sprite;
        private var _effectsContainer: Sprite;

        private var _shipView: ShipView;
        private var _planets: Vector.<PlanetView>;

        private var _distanceTF: TextField;

        private var _trajectory: Canvas;
        private var _counter: int;

        private var _dashStart: Point;
        private var _draw: Boolean;
        private var _lineLength: Number;
        private var _maxLength: int;

        private var _baseWidth: Number;
        private var _baseHeight: Number;
        private var _basePivotX: Number;
        private var _basePivotY: Number;
        private var _baseScale: Number;

        private var _aiming: Boolean;

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
            _background.tileGrid = new flash.geom.Rectangle(0, 0, _background.width, _background.height);
            _background.width = stage.stageWidth;
            _background.height = stage.stageHeight;
            addChild(_background);

            _stars = new Image(Application.assetsManager.getTexture("stars_pattern"));
            _stars.tileGrid = new flash.geom.Rectangle(0, 0, _stars.width, _stars.height);
            _stars.width = stage.stageWidth;
            _stars.height = stage.stageHeight;
            addChild(_stars);

            _container = new Sprite();
            addChild(_container);

            _planetsContainer = new Sprite();
            _container.addChild(_planetsContainer);

            _distanceTF = new TextField(50, 50, "", new TextFormat("futura_30_bold_italic_white_numeric", -1, 0xFFFFFF));
            _distanceTF.autoSize = TextFieldAutoSize.BOTH_DIRECTIONS;
            addChild(_distanceTF);

            _planets = new <PlanetView>[];
            for (var i:int = 0; i < _space.planets.length; i++)
            {
                var planet: Planet = _space.planets[i];
                var planetView: PlanetView = new PlanetView(planet);
                _planetsContainer.addChild(planetView);
                _planets.push(planetView);
            }

            _objectsContainer = new Sprite();
            _container.addChild(_objectsContainer);

            _effectsContainer = new Sprite();
            _container.addChild(_effectsContainer);

            addShip();

            _trajectory = new Canvas();
            _container.addChild(_trajectory);

            var rect: flash.geom.Rectangle = _container.getBounds(stage);
            _baseWidth = rect.width;
            _baseHeight = rect.height;
            _baseScale = Math.max(stage.stageWidth / _baseWidth, stage.stageHeight / _baseHeight) * 0.8;
            _basePivotX = rect.x + _baseWidth / 2;
            _basePivotY = rect.y + _baseHeight / 2;

            _container.x = stage.stageWidth / 2;
            _container.y = stage.stageHeight / 2;
            _container.pivotX = _basePivotX;
            _container.pivotY = _basePivotY;
            _container.scaleX = _baseScale;
            _container.scaleY = _baseScale;

            _dashStart = new Point();

            Starling.current.stage.addEventListener(TouchEvent.TOUCH, handleTouch);

            handleStep(null);
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
            _trajectory.visible = true;

            _trajectory.clear();
            _trajectory.beginFill(0xFFFFFF, 1);
            _counter = 0;

            _lineLength = 0;
            _draw = true;
            _maxLength = _draw ? DASH_LENGTH : GAP_LENGTH;
        }

        private function handleUpdateTrajectory(event: Event):void
        {
            if (_counter == 0)
            {
                _dashStart = _space.trajectory[_counter];
                _counter++;
            }
            if (_space.trajectory.length > _counter)
            {
                for (_counter; _counter < Math.min(_space.trajectory.length, Space.TRAJECTORY_LENGTH); _counter++)
                {
                    _lineLength += Point.distance(_space.trajectory[_counter], _space.trajectory[_counter-1]);
                    if (_lineLength > _maxLength)
                    {
                        _lineLength = 0;
                        _draw = !_draw;
                        _maxLength = _draw ? DASH_LENGTH : GAP_LENGTH;
                    }
                    if (_draw)
                    {
                        var points: Array = getLine(_dashStart, _space.trajectory[_counter], 2);
                        _trajectory.drawPolygon(new Polygon(points));
                    } else {
                        _dashStart = _space.trajectory[_counter];
                    }
                }
            }
        }

        private function handleHideTrajectory(event: Event):void
        {
            _trajectory.visible = false;
        }

        private function handleStep(event: Event):void
        {
            var dx: Number = _shipView.x - _baseWidth * 0.5;
            var dy: Number = _shipView.y - _baseHeight * 0.5;

            var realDistance: Number = Math.pow(dx * dx + dy * dy, 0.5);
            var angle: Number = Math.atan2(dy, dx);

            dx = Math.max(-_baseWidth, Math.min(dx, _baseWidth));
            dy = Math.max(-_baseHeight, Math.min(dy, _baseHeight));
            var d: Number = Math.pow(dx * dx + dy * dy, 0.5);
            var scale: Number = 1 - d * 0.25 / _baseWidth;

            Starling.juggler.tween(_container, event != null ? 0.3 : 0, {
                pivotX: _basePivotX + dx * 0.25,
                pivotY: _basePivotY + dy * 0.25,
                scaleX: _baseScale * scale,
                scaleY: _baseScale * scale
            });

            _distanceTF.text = String(Math.round(realDistance - d));
            _distanceTF.pivotX = _distanceTF.width * 0.5;
            _distanceTF.pivotY = _distanceTF.height * 0.5;
            _distanceTF.x = stage.stageWidth * 0.5 + Math.cos(angle) * stage.stageHeight * 0.45;
            _distanceTF.y = stage.stageHeight * 0.5 + Math.sin(angle) * stage.stageHeight * 0.45;
            _distanceTF.visible = !_shipView.getBounds(stage).intersects(new flash.geom.Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
        }

        private function getLine(p1: Point, p2: Point, thickness: int):Array
        {
            var angle: Number = Math.atan2(p2.y - p1.y, p2.x - p1.x);
            var points: Array = [];
            var dx: Number = Math.cos(angle - Math.PI * 0.5) * thickness;
            var dy: Number = Math.sin(angle - Math.PI * 0.5) * thickness;
            points.push(p1.x - dx, p1.y - dy);
            points.push(p1.x + dx, p1.y + dy);
            points.push(p2.x + dx, p2.y + dy);
            points.push(p2.x - dx, p2.y - dy);
            return points;
        }
    }
}
