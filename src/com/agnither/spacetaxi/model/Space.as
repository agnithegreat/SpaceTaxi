/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.utils.GeomUtils;

    import flash.geom.Point;

    import starling.animation.IAnimatable;
    import starling.events.EventDispatcher;

    public class Space extends EventDispatcher implements IAnimatable
    {
        public static const TRAJECTORY: String = "Space.TRAJECTORY";

        public static const G: Number = 667;
        public static const DELTA: Number = 0.1;
        public static const BOUNCE: Number = 0.7;
        public static const MIN_SPEED: Number = 20;
        public static const CONTROL_SPEED: Number = 100;
        public static const MAX_SPEED: Number = 1000;
        public static const TRAJECTORY_STEPS: Number = 1000;
        public static const PULL_MULTIPLIER: Number = 1;

        private var _ship: Ship;
        public function get ship():Ship
        {
            return _ship;
        }
        
        private var _planets: Vector.<Planet>;
        public function get planets():Vector.<Planet>
        {
            return _planets;
        }

        private var _pullPoint: Point;
        public function get pullPoint():Point
        {
            return _pullPoint;
        }
        
        private var _trajectory: Vector.<int>;
        public function get trajectory():Vector.<int>
        {
            return _trajectory;
        }

        public function Space()
        {
        }

        public function init():void
        {
            _ship = new Ship(1, 1);
            _ship.place(47, 223);

            _planets = new <Planet>[];
            addPlanet(95, 205, 50, 201);
            addPlanet(300, 95, 50, 197);
            addPlanet(565, 370, 100, 348);

//            addPlanet(700, 176, 50, 201);
//            addPlanet(700, 176, 30, -200);

            _pullPoint = new Point();
            _trajectory = new <int>[];
        }
        
        public function setPullPoint(x: int, y: int):void
        {
            if (_ship.landed)
            {
                _pullPoint.x = (_ship.x - x) * PULL_MULTIPLIER;
                _pullPoint.y = (_ship.y - y) * PULL_MULTIPLIER;
            }
        }

        public function updateTrajectory():void
        {
            if (_ship.landed)
            {
                _trajectory.length = 0;
                var ship: Ship = _ship.clone() as Ship;
                ship.launch();
                ship.accelerate(_pullPoint.x, _pullPoint.y);
                var i: int = 0;
                while (!ship.landed && i < TRAJECTORY_STEPS)
                {
                    i++;
                    step(ship, DELTA);
                    _trajectory.push(ship.x, ship.y);
                }
                dispatchEventWith(TRAJECTORY);
            }
        }

        public function launch():void
        {
            if (_ship.landed)
            {
                _ship.launch();
                _ship.accelerate(_pullPoint.x, _pullPoint.y);

//                _trajectory.length = 0;
//                dispatchEventWith(TRAJECTORY);
            }
        }

        private function addPlanet(x: int, y: int, radius: int, mass: Number):void
        {
            var planet: Planet = new Planet(radius, mass);
            planet.place(x, y);
            _planets.push(planet);
        }

        private function step(ship: Ship, delta: Number):void
        {
            if (!ship.landed)
            {
                checkGravity(ship, delta);
                checkSpeed(ship, delta);
                checkMove(ship, delta);
                ship.update();
            }
        }

        private function checkGravity(ship: Ship, delta: Number):void
        {
            var acX: Number = 0;
            var acY: Number = 0;
            for (var i:int = 0; i < _planets.length; i++)
            {
                var planet: Planet = _planets[i];
                var d: Number = Point.distance(planet.position, ship.position);
                var angle: Number = Math.atan2(planet.y - ship.y, planet.x - ship.x);
                var accMod: Number = G * planet.mass / Math.pow(d, 2);
                acX += accMod * Math.cos(angle) * delta;
                acY += accMod * Math.sin(angle) * delta;
            }
            ship.accelerate(acX, acY);
        }

        private function checkSpeed(ship: Ship, delta: Number):void
        {
            var d: Number = Point.distance(ship.speed, new Point());
            var maxSpeedMultiplier: Number = d / MAX_SPEED;
            if (maxSpeedMultiplier > 1)
            {
                ship.multiply(1 / maxSpeedMultiplier);
            }
        }

        private function checkMove(ship: Ship, delta: Number):void
        {
            var d: Number = Point.distance(ship.speed, new Point());
            var controlSpeedMultiplier: Number = d / CONTROL_SPEED;
            var maxDelta: Number = controlSpeedMultiplier > 1 ? delta / controlSpeedMultiplier : delta;
            var currentDelta: Number = maxDelta;
            while (!ship.landed && currentDelta > 0)
            {
                if (checkCollisions(ship, currentDelta))
                {
                    checkLand(ship);
                }
                ship.move(currentDelta);

                delta -= currentDelta;
                currentDelta = Math.min(delta, maxDelta);
            }
        }

        private function checkCollisions(ship: Ship, delta: Number):Boolean
        {
            var nextPosition: Point = new Point(ship.position.x + ship.speed.x * delta, ship.position.y + ship.speed.y * delta);
            for (var i: int = 0; i < _planets.length; i++)
            {
                var planet: Planet = _planets[i];
                var shipPlanet: Point = planet.position.subtract(nextPosition);
                var d: Number = Point.distance(planet.position, nextPosition);
                if (d <= ship.radius + planet.radius)
                {
                    ship.rotate(GeomUtils.getAngleDelta(ship.speed, shipPlanet) * 2 - Math.PI);
                    ship.multiply(BOUNCE);
                    return true;
                }
            }
            return false;
        }

        private function checkLand(ship: Ship):void
        {
            var d: Number = Point.distance(ship.speed, new Point());
            if (d <= MIN_SPEED)
            {
                ship.land();
            }
        }

        public function advanceTime(delta: Number):void
        {
//            step(_ship, delta);
            step(_ship, DELTA);
        }
    }
}
