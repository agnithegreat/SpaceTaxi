/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.controller.game.OrderController;
    import com.agnither.spacetaxi.controller.game.ZoneController;
    import com.agnither.spacetaxi.enums.PlanetType;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.model.orders.Zone;
    import com.agnither.spacetaxi.utils.GeomUtils;
    import com.agnither.spacetaxi.utils.LevelParser;
    import com.agnither.spacetaxi.vo.CollectibleVO;
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.spacetaxi.vo.OrderVO;
    import com.agnither.spacetaxi.vo.PlanetVO;
    import com.agnither.spacetaxi.vo.ZoneVO;

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
        
        public static const DAMAGE_SPEED: Number = 20;

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
        
        private var _collectibles: Vector.<Collectible>;
        public function get collectibles():Vector.<Collectible>
        {
            return _collectibles;
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

        private var _zoneController: ZoneController;
        public function get zones():ZoneController
        {
            return _zoneController;
        }

        private var _orderController: OrderController;
        public function get orders():OrderController
        {
            return _orderController;
        }

        private var _landPlanet: Planet;
        
        private var _danger: Boolean;
        public function get danger():Boolean
        {
            return _danger;
        }

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

            _collectibles = new <Collectible>[];
            for (i = 0; i < level.collectibles.length; i++)
            {
                var coll: CollectibleVO = level.collectibles[i];
                var collectible: Collectible = new Collectible(coll);
                collectible.place(coll.position.x, coll.position.y);
                _collectibles.push(collectible);
            }

            _viewport = level.viewport;
            _center = new Point();
            _center.x = _viewport.x + _viewport.width / 2;
            _center.y = _viewport.y + _viewport.height / 2;

            _pullPoint = new Point();
            _trajectory = new <Point>[];

            _zoneController = new ZoneController();
            for (i = 0; i < level.zones.length; i++)
            {
                var zone: ZoneVO = level.zones[i];
                _zoneController.addZone(new Zone(3, zone, _planetsDict[zone.planet]));
            }
            
            _orderController = new OrderController();
            for (i = 0; i < level.orders.length; i++)
            {
                var order: OrderVO = level.orders[i];
                var departure: Zone = new Zone(i, order.departure, _planetsDict[order.departure.planet]);
                var arrival: Zone = new Zone(i, order.arrival, _planetsDict[order.arrival.planet]);
                _zoneController.addZone(departure);
                _zoneController.addZone(arrival);
                _orderController.addOrder(new Order(order.cost, 100, departure, arrival));
            }
            _orderController.start();
        }
        
        public function destroy():void
        {
            Starling.juggler.removeDelayedCalls(computeTrajectory);
            
            _ship.destroy();
            _ship = null;
            
            while (_collectibles.length > 0)
            {
                var collectible: Collectible = _collectibles.shift();
                collectible.destroy();
            }
            
            while (_planets.length > 0)
            {
                var planet: Planet = _planets.shift();
                planet.destroy();
            }
            _planetsDict = null;
            _planets = null;

            _landPlanet = null;

            _viewport = null;
            _center = null;
            _pullPoint = null;
            _trajectory = null;
            
            _zoneController.destroy();
            _zoneController = null;
            
            _orderController.destroy();
            _orderController = null;
        }

        public function setPullPoint(x: int, y: int):void
        {
            if (_ship.landed && _ship.fuel > 0)
            {
                var px: int = -Math.round(x * PULL_MULTIPLIER / PULL_SCALE) * PULL_SCALE;
                var py: int = -Math.round(y * PULL_MULTIPLIER / PULL_SCALE) * PULL_SCALE;
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
                _danger = false;
                dispatchEventWith(SHOW_TRAJECTORY);

                var ship: Ship = _ship.clone() as Ship;
                launchShip(ship, true);
                computeTrajectory(ship);
            }
        }

        private function computeTrajectory(ship: Ship):void
        {
            var i: int = 0;
            var durability: int = ship.durability;
            while (!ship.landed && !ship.crashed && i < TRAJECTORY_STEPS)
            {
                i++;
                _trajectory.push(ship.position.clone());
                step(ship, DELTA);
                _trajectoryTime += DELTA;
            }
            if (ship.durability < durability)
            {
                _danger = true;
            }
            if (_trajectory.length <= 5) return;
            dispatchEventWith(UPDATE_TRAJECTORY);

            if (!ship.landed && !ship.crashed)
            {
                Starling.juggler.delayCall(computeTrajectory, 0.01, ship);
            }
        }

        public function launch():void
        {
            if (_ship.landed && _ship.fuel > 0 && _trajectory.length > 5)
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
            planet.place(planetData.position.x, planetData.position.y);
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
                
                var collectible: Collectible = checkCollectible(ship, currentDelta);
                if (collectible != null)
                {
                    if (ship == _ship)
                    {
                        // TODO: add reward, do some stuff
                        collectible.collect();
                        _collectibles.splice(_collectibles.indexOf(collectible), 0);
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
                            if (ship.speedMod >= DAMAGE_SPEED)
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

        private function checkCollectible(ship: Ship, delta: Number):Collectible
        {
            var nextPosition: Point = new Point(ship.position.x + ship.speed.x * delta, ship.position.y + ship.speed.y * delta);
            for (var i: int = 0; i < _collectibles.length; i++)
            {
                var collectible: Collectible = _collectibles[i];
                var d: Number = Point.distance(collectible.position, nextPosition);
                if (d <= ship.radius + collectible.radius)
                {
                    return collectible;
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
                    _zoneController.checkZones(_ship);
                }
            }
        }

        public function advanceTime(delta: Number):void
        {
            _orderController.step(delta);

            if (_ship.landed || _ship.crashed) return;

            var scaleSize: Number = 50 * DELTA;
            var fromStart: Number = _flightTime / scaleSize;
            var toEnd: Number = ship.speedMod >= DAMAGE_SPEED ? 1 : (_trajectoryTime - _flightTime) / scaleSize;
            var timeScale: Number = Math.sqrt(Math.max(0.01, Math.min(1, fromStart, toEnd)));

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
