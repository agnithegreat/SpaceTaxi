/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.controller.game.OrderController;
    import com.agnither.spacetaxi.enums.PlanetType;
    import com.agnither.spacetaxi.model.orders.Zone;
    import com.agnither.spacetaxi.utils.GeomUtils;
    import com.agnither.spacetaxi.utils.LevelParser;
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.spacetaxi.vo.OrderVO;
    import com.agnither.spacetaxi.vo.PlanetVO;

    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.events.EventDispatcher;

    public class Space extends EventDispatcher implements IAnimatable
    {
        public static const SHOW_TRAJECTORY: String = "Space.SHOW_TRAJECTORY";
        public static const UPDATE_TRAJECTORY: String = "Space.UPDATE_TRAJECTORY";
        public static const HIDE_TRAJECTORY: String = "Space.HIDE_TRAJECTORY";
        public static const STEP: String = "Space.STEP";

        public static const G: Number = 6.67;
        public static const DISTANCE_POWER: Number = 2;
        public static const DELTA: Number = 0.15;
        public static const MIN_SPEED: Number = 1;
        public static const CONTROL_SPEED: Number = 100;
        public static const MAX_SPEED: Number = 1000;
        public static const TRAJECTORY_STEPS: Number = 50;
        public static const TRAJECTORY_LENGTH: Number = 100;
        public static const PULL_MULTIPLIER: Number = 0.1;
        public static const PULL_SCALE: int = 1;
        
        public static const DAMAGE_MULTIPLIER: Number = 0.5;
        public static const MIN_DAMAGE: Number = 10;

        private var _ship: Ship;
        public function get ship():Ship
        {
            return _ship;
        }
        
        private var _planets: Vector.<Planet>;
        private var _planetsDict: Dictionary;
        public function get planets():Vector.<Planet>
        {
            return _planets;
        }
        
        private var _viewport: Rectangle;
        public function get viewport():Rectangle
        {
            return _viewport;
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

        private var _trajectory: Vector.<Point>;
        public function get trajectory():Vector.<Point>
        {
            return _trajectory;
        }

        private var _time: Number = 0;
        private var _flightTime: Number = 0;
        public function get flightTime():Number 
        {
            return _flightTime;
        }
        
        private var _trajectoryTime: Number = 0;
        public function get trajectoryTime():Number
        {
            return _trajectoryTime;
        }

        private var _orderController: OrderController;
        public function get orders():OrderController
        {
            return _orderController;
        }

        private var _landPlanet: Planet;

        public function Space()
        {
        }

        public function init():void
        {
            var level: LevelVO = LevelParser.parse(Application.assetsManager.getObject("test"));

            _ship = new Ship(10, 1, level.ship.rotation);
            _ship.place(level.ship.x, level.ship.y);
            _ship.landPrepare(null);

            _planets = new <Planet>[];
            _planetsDict = new Dictionary();
            for (var i:int = 0; i < level.planets.length; i++)
            {
                addPlanet(level.planets[i]);
            }

            _viewport = level.viewport;
            _center = new Point();
            _center.x = _viewport.x + _viewport.width / 2;
            _center.y = _viewport.y + _viewport.height / 2;

            _pullPoint = new Point();
            _trajectory = new <Point>[];

            _orderController = new OrderController();
            for (i = 0; i < level.orders.length; i++)
            {
                var order: OrderVO = level.orders[i];
                _orderController.addOrder(new Order(order.cost, 100, new Zone(order.departure), new Zone(order.arrival)));
            }
            _orderController.start();
        }

        public function setPullPoint(x: int, y: int):void
        {
            if (_ship.landed && _ship.fuel > 0)
            {
                var px: int = Math.round(x * PULL_MULTIPLIER / PULL_SCALE) * PULL_SCALE;
                var py: int = Math.round(y * PULL_MULTIPLIER / PULL_SCALE) * PULL_SCALE;
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
                _trajectoryTime = 0;
                dispatchEventWith(SHOW_TRAJECTORY);

                var ship: Ship = _ship.clone() as Ship;
                launchShip(ship, true);
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
                _trajectoryTime += DELTA;
            }
            dispatchEventWith(UPDATE_TRAJECTORY);

            if (!ship.landed && !ship.crashed)
            {
                Starling.juggler.delayCall(computeTrajectory, 0.01, ship);
            }
        }

        public function launch():void
        {
            if (_ship.landed && _ship.fuel > 0)
            {
                launchShip(_ship);

                _time = 0;
                _flightTime = 0;

                dispatchEventWith(HIDE_TRAJECTORY);
            }
        }

        private function addPlanet(planetData: PlanetVO):void
        {
            var planet: Planet = new Planet(planetData.radius, planetData.mass, planetData.bounce, PlanetType.getType(planetData.type), planetData.skin);
            planet.place(planetData.x, planetData.y);
            _planets.push(planet);
            _planetsDict[planetData] = planet;
            Starling.juggler.add(planet);
        }

        private function launchShip(ship: Ship, test: Boolean = false):void
        {
            ship.launch(test ? 0 : 1);
            ship.accelerate(_pullPoint.x, _pullPoint.y);
        }

        private function step(ship: Ship, delta: Number):void
        {
            if (!ship.landed)
            {
                checkMove(ship, delta);
                checkGravity(ship);
                checkSpeed(ship);
                ship.update();
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
                    if (!ship.crashed)
                    {
                        checkLand(ship, planetCollided);
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
            ship.update();
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
                        if (planet.type.safe)
                        {
                            var damage: Number = DAMAGE_MULTIPLIER * Point.distance(ship.speed, new Point());
                            if (damage >= MIN_DAMAGE)
                            {
                                ship.collide(1);
                                _orderController.checkDamage(1);
                            }
                        } else {
                            ship.crash();
                            _orderController.checkDamage(ship.durability);
                        }

                        ship.rotate(GeomUtils.getVectorDelta(ship.speed, shipPlanet) * 2 - Math.PI);
                        ship.multiply(planet.bounce * 0.01);
                        return planet;
                    } else if (d <= ship.radius*2)
                    {
                        return planet;
                    }
                }
            }
            return null;
        }

        private function checkLand(ship: Ship, planet: Planet):void
        {
            var d: Number = Point.distance(ship.speed, new Point());
            if (d <= MIN_SPEED)
            {
                _landPlanet = planet;
                ship.land(_landPlanet);

                if (_ship == ship)
                {
                    _orderController.checkOrders(_ship);
                }
            }
        }

        public function advanceTime(delta: Number):void
        {
            _orderController.step(delta);

            if (_ship.landed || _ship.crashed) return;

            var scaleSize: int = 50 * DELTA;
            var timeScale: Number = Math.sqrt(Math.max(0.01, Math.min(1, _flightTime / scaleSize, (_trajectoryTime-_flightTime) / scaleSize)));

            _time += delta * timeScale;
            var amount: int = _time * 1000 * DELTA;
            _time -= amount / (1000 * DELTA);
            for (var i:int = 0; i < amount; i++)
            {
                step(_ship, DELTA);
                _flightTime += DELTA;
            }

            if (_landPlanet != null && _trajectoryTime - _flightTime < 10)
            {
                _ship.landPrepare(_landPlanet);
            }

            dispatchEventWith(STEP);
        }
    }
}
