/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.Space;
    import com.agnither.utils.gui.components.AbstractComponent;

    import flash.display.Shape;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class SpaceView extends AbstractComponent
    {
        private static const DASH_LENGTH: int = 12;
        private static const GAP_LENGTH: int = 8;

        private var _space: Space;

        private var _background: Image;
        private var _stars: Image;
        private var _container: Sprite;
        private var _milkyway: Image;

        private var _shipView: ShipView;
        private var _planets: Vector.<PlanetView>;

        private var _trajectory: Shape;
        private var _counter: int;

        private var _draw: Boolean;
        private var _lineLength: Number;
        private var _maxLength: int;

        public function SpaceView(space: Space)
        {
            super();
            
            _space = space;
            _space.addEventListener(Space.SHOW_TRAJECTORY, handleShowTrajectory);
            _space.addEventListener(Space.UPDATE_TRAJECTORY, handleUpdateTrajectory);
            _space.addEventListener(Space.HIDE_TRAJECTORY, handleHideTrajectory);
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

            _milkyway = new Image(Application.assetsManager.getTexture("milkyway-min"));
            _milkyway.width = stage.stageWidth;
            _milkyway.height = stage.stageHeight;
            addChild(_milkyway);

            _planets = new <PlanetView>[];
            for (var i:int = 0; i < _space.planets.length; i++)
            {
                var planet: Planet = _space.planets[i];
                var planetView: PlanetView = new PlanetView(planet);
                _container.addChild(planetView);
                _planets.push(planetView);
            }

            _shipView = new ShipView(_space.ship);
            _container.addChild(_shipView);

            var rect: flash.geom.Rectangle = _container.getBounds(stage);
            var scale: Number = Math.max(stage.stageWidth / rect.width, stage.stageHeight / rect.height) * 0.8;
            _container.x = (stage.stageWidth - rect.width * scale) * 0.5 - rect.x;
            _container.y = (stage.stageHeight - rect.height * scale) * 0.5 - rect.y;
            _container.scaleX = scale;
            _container.scaleY = scale;

            _trajectory = new Shape();
            _trajectory.x = _container.x;
            _trajectory.y = _container.y;
            _trajectory.scaleX = scale;
            _trajectory.scaleY = scale;
            Application.flashViewport.addChild(_trajectory);

            Starling.current.stage.addEventListener(TouchEvent.TOUCH, handleTouch);
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
//                        var position: Point = touch.getLocation(this);
//                        trace(position.x, position.y);
                        break;
                    }
                    case TouchPhase.BEGAN:
                    case TouchPhase.MOVED:
                    {
                        var position: Point = touch.getLocation(_shipView);
                        _space.setPullPoint(position.x, position.y);
                        break;
                    }
                    case TouchPhase.ENDED:
                    {
                        _space.launch();
                        break;
                    }
                }
            }
        }

        private function handleShowTrajectory(event: Event):void
        {
            _trajectory.visible = true;
            
            _trajectory.graphics.clear();
            _trajectory.graphics.lineStyle(3, 0xFFFFFF, 0.5);
            _counter = 0;

            _lineLength = 0;
            _draw = true;
            _maxLength = _draw ? DASH_LENGTH : GAP_LENGTH;
        }

        private function handleUpdateTrajectory(event: Event):void
        {
            if (_counter == 0)
            {
                _trajectory.graphics.moveTo(_space.trajectory[_counter].x, _space.trajectory[_counter].y);
                _counter++;
            }
            if (_space.trajectory.length > _counter)
            {
                for (_counter; _counter < _space.trajectory.length; _counter++)
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
                        _trajectory.graphics.lineTo(_space.trajectory[_counter].x, _space.trajectory[_counter].y);
                    } else {
                        _trajectory.graphics.moveTo(_space.trajectory[_counter].x, _space.trajectory[_counter].y);
                    }
                }
            }
        }

        private function handleHideTrajectory(event: Event):void
        {
            _trajectory.visible = false;
        }
    }
}
