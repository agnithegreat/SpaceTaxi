/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.controller.game.OrderController;
    import com.agnither.spacetaxi.utils.GeomUtils;

    import flash.geom.Point;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.events.Event;
    import starling.events.EventDispatcher;

    public class Space extends EventDispatcher implements IAnimatable
    {
        public static const SHOW_TRAJECTORY: String = "Space.SHOW_TRAJECTORY";
        public static const UPDATE_TRAJECTORY: String = "Space.UPDATE_TRAJECTORY";
        public static const HIDE_TRAJECTORY: String = "Space.HIDE_TRAJECTORY";

        public static const G: Number = 6.67;
        public static const DELTA: Number = 0.2;
        public static const BOUNCE: Number = 0.7;
        public static const MIN_SPEED: Number = 1;
        public static const CONTROL_SPEED: Number = 100;
        public static const MAX_SPEED: Number = 1000;
        public static const MAX_DISTANCE: Number = 10000;
        public static const TRAJECTORY_STEPS: Number = 100;
        public static const PULL_MULTIPLIER: Number = 0.4;
        public static const PULL_SCALE: int = 2;

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
        
        private var _trajectory: Vector.<Point>;
        public function get trajectory():Vector.<Point>
        {
            return _trajectory;
        }

        private var _time: Number;

        private var _orderController: OrderController;

        public function Space()
        {
        }

        public function init():void
        {
            _ship = new Ship(5, 1);
            _ship.place(45, 225);

            _planets = new <Planet>[];
            addPlanet(95, 205, 50, 201);
            addPlanet(300, 95, 50, 197);
            addPlanet(565, 370, 100, 348);

            _pullPoint = new Point();
            _trajectory = new <Point>[];

            _orderController = new OrderController();
            _orderController.addEventListener(OrderController.UPDATE, handleUpdateOrders);
            _orderController.addOrder(new Order(_planets[1].getZone(), _planets[2].getZone()));
            _orderController.addOrder(new Order(_planets[0].getZone(), _planets[1].getZone()));
            _orderController.addOrder(new Order(_planets[2].getZone(), _planets[0].getZone()));
            _orderController.addOrder(new Order(_planets[2].getZone(), _planets[1].getZone()));
            _orderController.addOrder(new Order(_planets[0].getZone(), _planets[2].getZone()));
            _orderController.addOrder(new Order(_planets[1].getZone(), _planets[0].getZone()));
            _orderController.start(3);
        }

        public function setPullPoint(x: int, y: int):void
        {
            if (_ship.landed)
            {
                var px: int = Math.round((_ship.x - x) * PULL_MULTIPLIER / PULL_SCALE) * PULL_SCALE;
                var py: int = Math.round((_ship.y - y) * PULL_MULTIPLIER / PULL_SCALE) * PULL_SCALE;
                if (px != _pullPoint.x || py != _pullPoint.y)
                {
                    _pullPoint.x = px;
                    _pullPoint.y = py;
                    updateTrajectory();
                }
            }
        }

        public function updateTrajectory():void
        {
            if (_ship.landed)
            {
                Starling.juggler.removeDelayedCalls(computeTrajectory);
                _trajectory.length = 0;
                dispatchEventWith(SHOW_TRAJECTORY);
                var ship: Ship = _ship.clone() as Ship;
                ship.launch();
                ship.accelerate(_pullPoint.x, _pullPoint.y);
                computeTrajectory(ship);
            }
        }

        private function computeTrajectory(ship: Ship):void
        {
            var i: int = 0;
            var d: int = 0;
            while (!ship.landed && i < TRAJECTORY_STEPS && d < MAX_DISTANCE)
            {
                i++;
                _trajectory.push(ship.position.clone());
                step(ship, DELTA);
                d = Point.distance(ship.position, _ship.position);
            }
            _trajectory.push(ship.position.clone());
            dispatchEventWith(UPDATE_TRAJECTORY);

            if (d >= MAX_DISTANCE)
            {
                ship.crash();
            } else if (!ship.landed)
            {
                Starling.juggler.delayCall(computeTrajectory, 0.01, ship);
            }
        }

        public function launch():void
        {
            if (_ship.landed)
            {
                _ship.launch();
                _ship.accelerate(_pullPoint.x, _pullPoint.y);

                _time = 0;

//                dispatchEventWith(HIDE_TRAJECTORY);
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
                checkGravity(ship);
                checkSpeed(ship);
                checkMove(ship, delta);
                ship.update();
            }
        }

        private function checkGravity(ship: Ship):void
        {
            var acX: Number = 0;
            var acY: Number = 0;
            for (var i:int = 0; i < _planets.length; i++)
            {
                var planet: Planet = _planets[i];
                var d: Number = Point.distance(planet.position, ship.position);
                var angle: Number = Math.atan2(planet.y - ship.y, planet.x - ship.x);
                var accMod: Number = G * planet.mass / Math.pow(d, 2);
                acX += accMod * Math.cos(angle);
                acY += accMod * Math.sin(angle);
            }
            ship.accelerate(acX, acY);
        }

        private function checkSpeed(ship: Ship):void
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
                var planetCollided: Planet = checkCollisions(ship, currentDelta);
                if (planetCollided != null)
                {
                    var order: Boolean = _orderController.hasOrder(planetCollided, ship);
                    if (order)
                    {
                        ship.land();
                        if (_ship == ship)
                        {
                            _orderController.checkOrder(planetCollided, ship);
                        }
                    } else {
                        checkLand(ship);
                    }
                }
                ship.move(currentDelta);

                delta -= currentDelta;
                currentDelta = Math.min(delta, maxDelta);
            }
        }

        private function checkCollisions(ship: Ship, delta: Number):Planet
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
                    return planet;
                }
            }
            return null;
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
            if (_ship.landed) return;

            if (_trajectory.length > 0)
            {
                _time += delta;
                var pos: int = _time * 1000 * DELTA;
                if (_trajectory.length > pos)
                {
                    _ship.place(_trajectory[pos].x, _trajectory[pos].y);
                    _ship.update();

                    return;
                } else {
                    _ship.stop();
                }
            }

            step(_ship, DELTA);
        }

        private function handleUpdateOrders(event: Event):void
        {
            _orderController.start(3);
        }
    }
}
