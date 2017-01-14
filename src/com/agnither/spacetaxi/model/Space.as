/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.controller.game.OrderController;
    import com.agnither.spacetaxi.controller.game.ZoneController;
    import com.agnither.spacetaxi.enums.PlanetType;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.model.orders.Zone;
    import com.agnither.spacetaxi.utils.GeomUtils;
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
    import starling.events.Event;
    import starling.events.EventDispatcher;

    public class Space extends EventDispatcher implements IAnimatable
    {
        public static const NEW_METEOR: String = "Space.NEW_METEOR";
        public static const RESTART: String = "Space.RESTART";
        public static const SHOW_TRAJECTORY: String = "Space.SHOW_TRAJECTORY";
        public static const UPDATE_TRAJECTORY: String = "Space.UPDATE_TRAJECTORY";
        public static const HIDE_TRAJECTORY: String = "Space.HIDE_TRAJECTORY";
        public static const LEVEL_COMPLETE: String = "Space.LEVEL_COMPLETE";

        public static const G: Number = 6.67;
        public static const DISTANCE_POWER: Number = 2;
        public static const DELTA: Number = 0.15;
        public static const MIN_SPEED: Number = 1;
        public static const DAMAGE_SPEED: Number = 35;
        public static const CONTROL_SPEED: Number = 100;
        public static const TRAJECTORY_STEPS: Number = 250; // default 50
        public static const TRAJECTORY_LENGTH: Number = 10000; // default 100
        public static const PULL_MULTIPLIER: Number = 0.05;
        public static const PULL_SCALE: int = 1;

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
        
        private var _dynamics: Vector.<DynamicSpaceBody>;
        public function get dynamics():Vector.<DynamicSpaceBody>
        {
            return _dynamics;
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
        
        private var _shipTime: Number = 0;
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

        public function init(level: LevelVO):void
        {
            _ship = new Ship(10, 1, level.ship.rotation);
            _ship.place(level.ship.position.x, level.ship.position.y);
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
            
            _dynamics = new <DynamicSpaceBody>[];

            _viewport = level.viewport;
            _center = new Point();
            _center.x = _viewport.x + _viewport.width / 2;
            _center.y = _viewport.y + _viewport.height / 2;

            _pullPoint = new Point();
            _trajectory = new <Point>[];
            
            _time = 0;
            _shipTime = 0;

            _zoneController = new ZoneController();
            for (i = 0; i < level.zones.length; i++)
            {
                var zone: ZoneVO = level.zones[i];
                _zoneController.addZone(new Zone(3, zone, _planetsDict[zone.planet]));
            }
            
            _orderController = new OrderController();
            _orderController.addEventListener(OrderController.DONE, handleOrdersDone);
            for (i = 0; i < level.orders.length; i++)
            {
                var order: OrderVO = level.orders[i];
                var departure: Zone = new Zone(i, order.departure, _planetsDict[order.departure.planet]);
                var arrival: Zone = new Zone(i, order.arrival, _planetsDict[order.arrival.planet]);
                _zoneController.addZone(departure);
                _zoneController.addZone(arrival);
                _orderController.addOrder(new Order(order.cost, order.wave, 100, departure, arrival));
            }
            _orderController.start();
        }
        
        public function restart(level: LevelVO):void
        {
            destroy();
            init(level);
            dispatchEventWith(RESTART);
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

            while (_dynamics.length > 0)
            {
                var body: DynamicSpaceBody = _dynamics.shift();
                body.destroy();
            }
            _dynamics = null;

            _landPlanet = null;

            _viewport = null;
            _center = null;
            _pullPoint = null;
            _trajectory = null;
            
            _zoneController.destroy();
            _zoneController = null;

            _orderController.removeEventListener(OrderController.DONE, handleOrdersDone);
            _orderController.destroy();
            _orderController = null;
        }

        public function setPullPoint(x: int, y: int):void
        {
            if (_ship.stable && _ship.fuel > 0)
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
            if (_ship.stable)
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
            while (!ship.stable && ship.alive && i < TRAJECTORY_STEPS)
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

            if (!ship.stable && ship.alive)
            {
                Starling.juggler.delayCall(computeTrajectory, 0.01, ship);
            }
        }

        public function launch():void
        {
            if (_ship.stable && _ship.fuel > 0 && _trajectory.length > 5)
            {
                launchShip(_ship);
                _orderController.increment(1);

                _shipTime = 0;
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

        private function step(body: DynamicSpaceBody, delta: Number):void
        {
            if (!body.stable)
            {
                checkMove(body, delta);
                checkDistance(body);
                checkGravity(body);
                checkSpeed(body);
                body.update();
            }
        }

        private function checkMove(body: DynamicSpaceBody, delta: Number):void
        {
            var d: Number = Point.distance(body.speed, new Point());
            var controlSpeedMultiplier: Number = d / CONTROL_SPEED;
            var maxDelta: Number = controlSpeedMultiplier > 1 ? delta / controlSpeedMultiplier : delta;
            var currentDelta: Number = maxDelta;
            while (!body.stable && currentDelta > 0)
            {
                var planetCollided: Planet = checkCollisions(body, currentDelta);
                if (planetCollided != null)
                {
                    if (body is Ship && body.alive)
                    {
                        checkLand(body as Ship, planetCollided);
                    }
                }
                
                if (body == _ship)
                {
                    var collectible: Collectible = checkCollectible(_ship, currentDelta);
                    if (collectible != null)
                    {
                        // TODO: add reward, do some stuff
                        SoundManager.playSound(SoundManager.BOX_TAKE);
                        collectible.collect();
                        _collectibles.splice(_collectibles.indexOf(collectible), 1);
                    }
                }
                
                if (body.alive)
                {
                    body.move(currentDelta);
                }

                delta -= currentDelta;
                currentDelta = Math.min(delta, maxDelta);
            }
        }

        private function checkDistance(body: DynamicSpaceBody):void
        {
            var d: Number = Point.distance(body.position, _viewport.topLeft.add(new Point(_viewport.width * 0.5, _viewport.height * 0.5)));
            if (d > _viewport.width * 4 || d > _viewport.height * 4)
            {
                body.crash();
            }
        }

        private function checkGravity(body: DynamicSpaceBody):void
        {
            var acX: Number = 0;
            var acY: Number = 0;
            for (var i:int = 0; i < _planets.length; i++)
            {
                var planet: Planet = _planets[i];
                var d: Number = Point.distance(planet.position, body.position);
                var angle: Number = Math.atan2(planet.y - body.y, planet.x - body.x);
                var accMod: Number = G * planet.mass / Math.pow(d, DISTANCE_POWER);
                acX += accMod * Math.cos(angle);
                acY += accMod * Math.sin(angle);
            }
            body.accelerate(acX, acY);
            body.update();
        }

        private function checkSpeed(body: DynamicSpaceBody):void
        {
            var d: Number = Point.distance(body.speed, new Point());
            var maxSpeedMultiplier: Number = d / body.maxSpeed;
            if (maxSpeedMultiplier > 1)
            {
                body.multiply(1 / maxSpeedMultiplier);
            }
        }

        private function checkCollisions(body: DynamicSpaceBody, delta: Number):Planet
        {
            var nextPosition: Point = new Point(body.position.x + body.speed.x * delta, body.position.y + body.speed.y * delta);
            for (var i: int = 0; i < _planets.length; i++)
            {
                var planet: Planet = _planets[i];
                var bodyPlanet: Point = planet.position.subtract(nextPosition);
                var d: Number = Point.distance(planet.position, nextPosition);
                if (d <= body.radius + planet.radius)
                {
                    if (planet.type.solid)
                    {
                        if (planet.type.safe)
                        {
                            if (body.speedMod >= DAMAGE_SPEED)
                            {
                                if (body == _ship)
                                {
                                    _ship.collide(1);
                                    _orderController.checkDamage(1);
                                }
                            }
                        } else {
                            if (body == _ship)
                            {
                                _ship.collide(int.MAX_VALUE);
                                _orderController.checkDamage(int.MAX_VALUE);
                            }
                        }

                        body.rotate(GeomUtils.getVectorDelta(body.speed, bodyPlanet) * 2 - Math.PI);
                        body.multiply(body is Ship ? planet.bounce * 0.01 : 1);
                        return planet;
                    } else if (d <= body.radius*2)
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

                if (ship == _ship)
                {
                    _zoneController.checkZones(_ship);
                }
            }
        }

        private function createMeteor():void
        {
            var meteor: Meteor = new Meteor(1, 1);
            meteor.place(_viewport.x + Math.random() * _viewport.width, _viewport.height + Math.random() * _viewport.height);
            _dynamics.push(meteor);
            dispatchEventWith(NEW_METEOR, false, meteor);
        }

        public function advanceTime(delta: Number):void
        {
            var max: int = _viewport.width * _viewport.height * 0.00001;
            if (_dynamics.length < max && Math.random() < 0.005)
            {
                createMeteor();
            }

            _time += delta;
            var amount: int = _time * 1000 * DELTA;
            _time -= amount / (1000 * DELTA);
            for (var i: int = 0; i < amount; i++)
            {
                for (var j:int = 0; j < _dynamics.length; j++)
                {
                    if (_dynamics[j].alive)
                    {
                        step(_dynamics[j], DELTA);
                    } else {
                        _dynamics.splice(j--, 1);
                    }
                }
            }
            
            if (_ship.stable || !_ship.alive) return;

            var scaleSize: Number = 50 * DELTA;
            var fromStart: Number = _flightTime / scaleSize;
            var toEnd: Number = ship.speedMod >= DAMAGE_SPEED ? 1 : (_trajectoryTime - _flightTime) / scaleSize;
            var timeScale: Number = Math.sqrt(Math.max(0.01, Math.min(1, fromStart, toEnd)));

            _shipTime += delta * timeScale;
            amount = _shipTime * 1000 * DELTA;
            _shipTime -= amount / (1000 * DELTA);
            for (i = 0; i < amount; i++)
            {
                step(_ship, DELTA);
                _flightTime += DELTA;
            }

            if (_landPlanet != null && _trajectoryTime - _flightTime < 10)
            {
                _ship.landPrepare(_landPlanet);
            }
        }

        private function handleOrdersDone(event: Event):void
        {
            dispatchEventWith(LEVEL_COMPLETE);
        }
    }
}
