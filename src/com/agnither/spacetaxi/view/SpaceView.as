/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view
{
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.Space;

    import flash.display.Shape;
    import flash.geom.Point;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    public class SpaceView extends Sprite
    {
        private var _space: Space;
        
        private var _shipView: ShipView;
        private var _planets: Vector.<PlanetView>;
        
        private var _trajectory: Shape;
        private var _speed: Shape;

        public function SpaceView(space: Space)
        {
            super();
            
            _space = space;
            _space.addEventListener(Space.TRAJECTORY, handleTrajectory);

            _planets = new <PlanetView>[];
            for (var i:int = 0; i < _space.planets.length; i++)
            {
                var planet: Planet = _space.planets[i];
                var planetView: PlanetView = new PlanetView(planet);
                addChild(planetView);
                _planets.push(planetView);
            }

            _shipView = new ShipView(_space.ship);
            addChild(_shipView);

            _speed = new Shape();
            Starling.current.nativeStage.addChild(_speed);

            _trajectory = new Shape();
            Starling.current.nativeStage.addChild(_trajectory);

            Starling.current.stage.addEventListener(TouchEvent.TOUCH, handleTouch);
        }

        private function handleTouch(event: TouchEvent):void
        {
            var touch: Touch = event.getTouch(stage);
            if (touch != null)
            {
                var position: Point = touch.getLocation(this);
                _space.setPullPoint(position.x, position.y);
                switch (touch.phase)
                {
                    case TouchPhase.BEGAN:
                    case TouchPhase.MOVED:
                    {
                        _space.updateTrajectory();
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

        private function handleTrajectory(event: Event):void
        {
            _speed.graphics.clear();
            if (_space.ship.landed)
            {
                _speed.graphics.lineStyle(3, 0xFF0000);
                _speed.graphics.moveTo(_space.ship.position.x, _space.ship.position.y);
                _speed.graphics.lineTo(_space.ship.position.x + _space.pullPoint.x, _space.ship.position.y + _space.pullPoint.y);
            }

            _trajectory.graphics.clear();
            if (_space.trajectory.length > 0)
            {
                _trajectory.graphics.lineStyle(2, 0xFFFFFF);
                _trajectory.graphics.moveTo(_space.trajectory[0], _space.trajectory[1]);
                for (var i:int = 2; i < _space.trajectory.length; i += 2)
                {
                    _trajectory.graphics.lineTo(_space.trajectory[i], _space.trajectory[i+1]);
                }
            }
        }
    }
}
