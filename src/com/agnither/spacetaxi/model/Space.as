/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.controller.game.OrderController;
    import com.agnither.spacetaxi.enums.PlanetType;
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
        public static const STEP: String = "Space.STEP";

        public static const G: Number = 6.67;
        public static const DISTANCE_POWER: Number = 2;
        public static const DELTA: Number = 0.2;
        public static const BOUNCE: Number = 0.5;
        public static const MIN_SPEED: Number = 1;
        public static const CONTROL_SPEED: Number = 100;
        public static const MAX_SPEED: Number = 1000;
        public static const MAX_DISTANCE: Number = 4000;
        public static const TRAJECTORY_STEPS: Number = 50;
        public static const TRAJECTORY_LENGTH: Number = 150;
        public static const PULL_MULTIPLIER: Number = 0.1;
        public static const PULL_SCALE: int = 1;
        
        public static const PLANET_ZONE_SIZE: int = 40;
        
        public static const FUEL_MULTIPLIER: Number = 0.3;
        public static const DAMAGE_MULTIPLIER: Number = 1;
        public static const MIN_DAMAGE: Number = 10;

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

        private var _center: Point;
        public function get center():Point
        {
            return _center;
        }
        
        private var _pullPoint: Point;
        public function get pullPoint():Point
        {
            return _pullPoint;
        }
        public function get fuel():Number
        {
            return FUEL_MULTIPLIER * Point.distance(_pullPoint, new Point());
        }
        
        private var _trajectory: Vector.<Point>;
        public function get trajectory():Vector.<Point>
        {
            return _trajectory;
        }

        private var _time: Number = 0;
        private var _useTrajectory: Boolean;

        private var _orderController: OrderController;

        public function Space()
        {
        }

        public function init():void
        {
            _ship = new Ship(20, 1);
            resetShip();

            _center = new Point();

            _planets = new <Planet>[];
            addPlanet(95, 205, 50, 201, PlanetType.NORMAL);
            addPlanet(300, 95, 50, 197, PlanetType.NORMAL);
            addPlanet(565, 370, 100, 348, PlanetType.NORMAL);

//            addPlanet(230, 430, 100, 500, PlanetType.LAVA);
//            addPlanet(230, 430, 50, 3000, PlanetType.BLACK_HOLE);

            _center.x /= _planets.length;
            _center.y /= _planets.length;

            _pullPoint = new Point();
            _trajectory = new <Point>[];

            _orderController = new OrderController();
            _orderController.addOrder(new Order(100, 100, _planets[1].getZone(), _planets[2].getZone()));
            _orderController.addOrder(new Order(100, 100, _planets[0].getZone(), _planets[1].getZone()));
            _orderController.addOrder(new Order(100, 100, _planets[2].getZone(), _planets[0].getZone()));
            _orderController.addOrder(new Order(100, 100, _planets[2].getZone(), _planets[1].getZone()));
            _orderController.addOrder(new Order(100, 100, _planets[0].getZone(), _planets[2].getZone()));
            _orderController.addOrder(new Order(100, 100, _planets[1].getZone(), _planets[0].getZone()));
            _orderController.start(3);
        }

        private function resetShip():void
        {
            _ship.reset();
            _ship.place(30, 235);
        }

        public function setPullPoint(x: int, y: int):void
        {
            if (_ship.landed)
            {
                var px: int = Math.round(x * PULL_MULTIPLIER / PULL_SCALE) * PULL_SCALE;
                var py: int = Math.round(y * PULL_MULTIPLIER / PULL_SCALE) * PULL_SCALE;
                if (px != _pullPoint.x || py != _pullPoint.y)
                {
                    _pullPoint.x = px;
                    _pullPoint.y = py;

                    var scale: Number = _ship.fuel / fuel;
                    if (scale < 1)
                    {
                        _pullPoint.x *= scale * 0.9999;
                        _pullPoint.y *= scale * 0.9999;
                    }
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
                ship.launch(0);
                ship.accelerate(_pullPoint.x, _pullPoint.y);
                computeTrajectory(ship);
            }
        }

        private function computeTrajectory(ship: Ship):void
        {
            var i: int = 0;
            while (!ship.landed && !ship.crashed && i < TRAJECTORY_STEPS)
            {
                i++;
                _trajectory.push(ship.position.clone());
                step(ship, DELTA);
            }
            _trajectory.push(ship.position.clone());
            dispatchEventWith(UPDATE_TRAJECTORY);

            if (!ship.landed && !ship.crashed)
            {
                Starling.juggler.delayCall(computeTrajectory, 0.01, ship);
            }
        }

        public function launch():void
        {
            if (_ship.landed)
            {
                _ship.launch(fuel);
                _ship.accelerate(_pullPoint.x, _pullPoint.y);

                _time = 0;
                _useTrajectory = true;

                dispatchEventWith(HIDE_TRAJECTORY);
            }
        }

        private function addPlanet(x: int, y: int, radius: int, mass: Number, type: PlanetType):void
        {
            var planet: Planet = new Planet(radius, mass, type);
            planet.place(x, y);
            _planets.push(planet);
            Starling.juggler.add(planet);

            _center.x += x;
            _center.y += y;
        }

        private function step(ship: Ship, delta: Number):void
        {
            if (!ship.landed)
            {
                checkGravity(ship);
                checkSpeed(ship);
                checkMove(ship, delta);
                checkDistance(ship);
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
                var accMod: Number = G * planet.mass / Math.pow(d, DISTANCE_POWER);
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
                    var damage: Number = planetCollided.type.safe ? DAMAGE_MULTIPLIER * Point.distance(ship.speed, new Point()) : ship.durability;
                    damage = damage >= MIN_DAMAGE ? damage : 0;
                    ship.collide(damage);
                    _orderController.checkDamage(damage);
                    
                    if (!ship.crashed)
                    {
                        var order: Boolean = _orderController.hasOrder(planetCollided, ship);
                        if (order)
                        {
                            ship.land(planetCollided);
                            if (_ship == ship)
                            {
                                _orderController.checkOrder(planetCollided, ship);
                            }
                        } else {
                            checkLand(ship, planetCollided);
                        }
                    }
                }
                if (!ship.crashed)
                {
                    ship.move(currentDelta);
                }

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
                    if (planet.type.solid)
                    {
                        ship.rotate(GeomUtils.getAngleDelta(ship.speed, shipPlanet) * 2 - Math.PI);
                        ship.multiply(BOUNCE);
                        return planet;
                    } else if (d <= ship.radius*2) return planet;
                    else return null;
                }
            }
            return null;
        }

        private function checkLand(ship: Ship, planet: Planet):void
        {
            var d: Number = Point.distance(ship.speed, new Point());
            if (d <= MIN_SPEED)
            {
                ship.land(planet);
            }
        }

        private function checkDistance(ship: Ship):void
        {
            var d: Number = Point.distance(ship.position, _center);
            if (d >= MAX_DISTANCE)
            {
                ship.crash();
            }
        }

        public function advanceTime(delta: Number):void
        {
            _orderController.step(delta);
            
            if (_ship.landed) return;

            if (_ship.crashed)
            {
                trace("reset");
                resetShip();
                return;
            }

            _time += delta;
            var amount: int = _time * 1000 * DELTA;
            _time -= amount / (1000 * DELTA);
            for (var i:int = 0; i < amount; i++)
            {
                step(_ship, DELTA);
            }

            dispatchEventWith(STEP);
        }
    }
}
