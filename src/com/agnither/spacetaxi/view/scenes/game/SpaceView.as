/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view.scenes.game
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.Collectible;
    import com.agnither.spacetaxi.model.Meteor;
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.Space;
    import com.agnither.spacetaxi.model.orders.Zone;
    import com.agnither.spacetaxi.tasks.logic.LevelFailTask;
    import com.agnither.spacetaxi.tasks.logic.RestartGameTask;
    import com.agnither.spacetaxi.utils.LevelParser;
    import com.agnither.spacetaxi.view.scenes.game.effects.CometEffect;
    import com.agnither.spacetaxi.view.scenes.game.effects.ExplosionEffect;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.AbstractComponent;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
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
        private var _starsParallax1: ParallaxLayer;
        private var _starsParallax2: ParallaxLayer;
        private var _starsParallax3: ParallaxLayer;

        private var _container: Sprite;
        private var _animationsContainer: Sprite;
        private var _lowerContainer: Sprite;
        private var _zonesContainer: Sprite;
        private var _objectsContainer: Sprite;
        private var _upperContainer: Sprite;

        private var _planets: Vector.<PlanetView>;
        private var _portals: Vector.<PortalView>;
        private var _collectibles: Vector.<CollectibleView>;
        private var _zones: Vector.<ZoneView>;
        private var _shipView: ShipView;

        private var _trajectory: Sprite;
        private var _trajectoryLength: Number;
        private var _aimMode: Boolean;

        private var _previousDot: Point;
        private var _dotCounter: int;

        private var _viewport: Rectangle;
        private var _basePivotX: Number;
        private var _basePivotY: Number;

        private var _aiming: Boolean;

        private var _time: Number;

        private var _touch: Point;
        private var _delta: Point;

        public function SpaceView()
        {
            super();
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

            _starsParallax1 = new ParallaxLayer(0.1, 60, 0.4);
            addChild(_starsParallax1);
            _starsParallax1.init();

            _starsParallax2 = new ParallaxLayer(0.15, 40, 0.6);
            addChild(_starsParallax2);
            _starsParallax2.init();

            _starsParallax3 = new ParallaxLayer(0.2, 20, 0.8);
            addChild(_starsParallax3);
            _starsParallax3.init();

            _overlay = new Image(Texture.fromColor(100, 100, 0xFFFFFF, 0.2));
            _overlay.width = stage.stageWidth;
            _overlay.height = stage.stageHeight;
            addChild(_overlay);

            _container = new Sprite();
            addChild(_container);

            _animationsContainer = new Sprite();
            _container.addChild(_animationsContainer);

            _lowerContainer = new Sprite();
            _container.addChild(_lowerContainer);

            _planets = new <PlanetView>[];
            _portals = new <PortalView>[];
            _collectibles = new <CollectibleView>[];

            _zonesContainer = new Sprite();
            _container.addChild(_zonesContainer);

            _zones = new <ZoneView>[];

            _trajectory = new Sprite();
            _container.addChild(_trajectory);

            _objectsContainer = new Sprite();
            _container.addChild(_objectsContainer);

            _upperContainer = new Sprite();
            _container.addChild(_upperContainer);
        }

        override protected function activate():void
        {
            _space = Application.appController.space;
            _space.addEventListener(Space.NEW_METEOR, handleNewMeteor);
            _space.addEventListener(Space.PAUSE, handlePause);
            _space.addEventListener(Space.RESTART, handleRestart);
            _space.addEventListener(Space.SHOW_TRAJECTORY, handleShowTrajectory);
            _space.addEventListener(Space.UPDATE_TRAJECTORY, handleUpdateTrajectory);
            _space.addEventListener(Space.HIDE_TRAJECTORY, handleHideTrajectory);

            _viewport = _space.viewport;
            _basePivotX = _viewport.x + _viewport.width / 2;
            _basePivotY = _viewport.y + _viewport.height / 2;

            _container.x = stage.stageWidth / 2;
            _container.y = stage.stageHeight / 2;
            _container.pivotX = _basePivotX;
            _container.pivotY = _basePivotY;

            for (var i: int = 0; i < _space.planets.length; i++)
            {
                var planet: Planet = _space.planets[i];
                var planetView: PlanetView = new PlanetView(planet);
                _lowerContainer.addChild(planetView);
                _planets.push(planetView);

                if (LevelParser.colors[planet.skin] != null)
                {
                    var sputnikView: SputnikView = new SputnikView(planet, _upperContainer, _lowerContainer);
                    _upperContainer.addChild(sputnikView);
                }
            }

            for (i = 0; i < _space.collectibles.length; i++)
            {
                var collectible: Collectible = _space.collectibles[i];
                var collectibleView: CollectibleView = new CollectibleView(collectible);
                _objectsContainer.addChild(collectibleView);
                _collectibles.push(collectibleView);
            }

            for (i = 0; i < _space.zones.zones.length; i++)
            {
                var zone: Zone = _space.zones.zones[i];
                var zoneView: ZoneView = new ZoneView(zone);
                _zonesContainer.addChild(zoneView);
                _zones.push(zoneView);
            }
            
            for (i = 0; i < _space.portals.length; i++)
            {
                var portalView: PortalView = new PortalView(_space.portals[i]);
                _portals.push(portalView);
                _lowerContainer.addChild(portalView);
            }

            _shipView = new ShipView(_space.ship);
            _shipView.addEventListener(ShipView.EXPLODE, handleExplode);
            _objectsContainer.addChild(_shipView);

            _previousDot = new Point();

            _delta = new Point();
            _touch = null;

            Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
            addEventListener(TouchEvent.TOUCH, handleTouch);

            handleEnterFrame(null);

            _time = 0;
            Starling.juggler.add(this);
        }

        override protected function deactivate():void
        {
            _space.removeEventListener(Space.NEW_METEOR, handleNewMeteor);
            _space.removeEventListener(Space.PAUSE, handlePause);
            _space.removeEventListener(Space.RESTART, handleRestart);
            _space.removeEventListener(Space.SHOW_TRAJECTORY, handleShowTrajectory);
            _space.removeEventListener(Space.UPDATE_TRAJECTORY, handleUpdateTrajectory);
            _space.removeEventListener(Space.HIDE_TRAJECTORY, handleHideTrajectory);
            _space = null;

            while (_planets.length > 0)
            {
                var planetView: PlanetView = _planets.shift();
                planetView.removeFromParent(true);
            }

            while (_portals.length > 0)
            {
                var portalView: PortalView = _portals.shift();
                portalView.removeFromParent(true);
            }

            while (_collectibles.length > 0)
            {
                var collectibleView: CollectibleView = _collectibles.shift();
                collectibleView.removeFromParent(true);
            }

            while (_zones.length > 0)
            {
                var orderView: ZoneView = _zones.shift();
                orderView.removeFromParent(true);
            }
            
            _animationsContainer.removeChildren(0, -1, true);
            
            _lowerContainer.removeChildren(0, -1, true);
            _upperContainer.removeChildren(0, -1, true);

            resetTrajectory();

            _viewport = null;
            _previousDot = null;

            _shipView.destroy();
            _shipView = null;

            Starling.current.stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
            removeEventListener(TouchEvent.TOUCH, handleTouch);

            Starling.juggler.remove(this);
        }

        private function handleExplode(event: Event):void
        {
            _shipView.removeEventListener(ShipView.EXPLODE, handleExplode);

            var explosion: ExplosionEffect = new ExplosionEffect();
            explosion.x = _shipView.x;
            explosion.y = _shipView.y;
            _upperContainer.addChild(explosion);
        }

        private function handleTouch(event: TouchEvent):void
        {
            var touch: Touch = event.getTouch(stage);
            if (touch != null)
            {
                var position: Point = touch.getLocation(stage);
                var shipPos: Point = _shipView.localToGlobal(new Point());
                var distance: Number = Point.distance(position, shipPos);
                const segment: int = 100 * Application.scaleFactor;
                switch (touch.phase)
                {
                    case TouchPhase.HOVER:
                    {
                        break;
                    }
                    case TouchPhase.BEGAN:
                    {
                        if (distance <= segment)
                        {
                            _aiming = true;
                        } else {
                            _touch = touch.getLocation(stage);
                        }
                        break;
                    }
                    case TouchPhase.MOVED:
                    {
                        if (_aiming)
                        {
                            var angle: Number = Math.atan2(shipPos.y - _shipView.offset.y - position.y, shipPos.x - _shipView.offset.x - position.x);
                            var power: Number = Math.pow(distance / segment, 2);
                            _space.setPullPoint(angle, power, false, true);
                        } else {
                            position = touch.getLocation(stage);
                            _delta.x = _touch.x - position.x;
                            _delta.y = _touch.y - position.y;
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
                        _touch = null;
                        _delta.x = 0;
                        _delta.y = 0;
                        break;
                    }
                }
            }
        }

        private function handleNewMeteor(event: Event):void
        {
            var meteorView: MeteorView = new MeteorView(event.data as Meteor);
            _animationsContainer.addChild(meteorView);
        }

        private function handlePause(event: Event):void
        {
            if (event.data)
            {
                Starling.current.stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
                Starling.current.stage.removeEventListener(TouchEvent.TOUCH, handleTouch);
                Starling.juggler.remove(this);
            } else {
                Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
                Starling.current.stage.addEventListener(TouchEvent.TOUCH, handleTouch);
                Starling.juggler.add(this);
            }              
        }

        private function handleRestart(event: Event):void
        {
            deactivate();
            activate();
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

                    if (!_aimMode)
                    {
                        Starling.juggler.tween(dot, 0.5, {delay: 3, alpha: 0, onComplete: dot.removeFromParent, onCompleteArgs: [true]});
                    }

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
        
        private function handleEnterFrame(event: EnterFrameEvent):void
        {
            if (Math.random() < 0.005)
            {
                var comet: CometEffect = new CometEffect();
                comet.x = _viewport.x + Math.random() * _viewport.width;
                comet.y = _viewport.y + Math.random() * _viewport.height;
                _animationsContainer.addChild(comet);
            }

            if (!_aimMode)
            {
                updateTrajectory(_space.flightTime);
            }

            var dx: Number = _shipView.x - _basePivotX;
            var dy: Number = _shipView.y - _basePivotY;

            var sx: Number = Math.abs(dx);
            var sy: Number = Math.abs(dy);
            var scale: Number = Math.min(stage.stageWidth / sx, stage.stageHeight / sy, Application.scaleFactor) * 0.85;

            if (sx > _viewport.width * 2 || sy > _viewport.height * 2)
            {
                if (!_shipView.getBounds(stage).intersects(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight)))
                {
                    TaskSystem.getInstance().addTask(new LevelFailTask());
                }

                return;
            }

            var ddx: int = 2 * _delta.x + dx;
            var ddy: int = 2 * _delta.y + dy;

            Starling.juggler.tween(_container, event != null ? 0.3 : 0, {
                scaleX: scale,
                scaleY: scale,
                pivotX: _basePivotX + ddx * 0.5,
                pivotY: _basePivotY + ddy * 0.5
            });

            Starling.juggler.tween(_background, event != null ? 0.3 : 0, {
                x: stage.stageWidth * 0.5 - ddx * 0.05,
                y: stage.stageHeight * 0.5 - ddy * 0.05
            });

            Starling.juggler.tween(_starsParallax1, event != null ? 0.3 : 0, {
                x: -ddx,
                y: -ddy
            });
            Starling.juggler.tween(_starsParallax2, event != null ? 0.3 : 0, {
                x: -ddx,
                y: -ddy
            });
            Starling.juggler.tween(_starsParallax3, event != null ? 0.3 : 0, {
                x: -ddx,
                y: -ddy
            });
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
