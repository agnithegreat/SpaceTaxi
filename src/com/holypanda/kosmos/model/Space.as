/**
 * Created by agnither on 14.11.16.
 */
package com.holypanda.kosmos.model
{
    import com.holypanda.kosmos.controller.game.DialogController;
    import com.holypanda.kosmos.controller.game.OrderController;
    import com.holypanda.kosmos.controller.game.ZoneController;
    import com.holypanda.kosmos.enums.PlanetType;
    import com.holypanda.kosmos.managers.analytics.GamePlayAnalytics;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.model.orders.Zone;
    import com.holypanda.kosmos.utils.GeomUtils;
    import com.holypanda.kosmos.vo.LevelVO;
    import com.holypanda.kosmos.vo.game.CollectibleVO;
    import com.holypanda.kosmos.vo.game.OrderVO;
    import com.holypanda.kosmos.vo.game.PlanetVO;
    import com.holypanda.kosmos.vo.game.PortalVO;

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
        public static const PAUSE: String = "Space.PAUSE";
        public static const RESTART: String = "Space.RESTART";
        public static const SHOW_TRAJECTORY: String = "Space.SHOW_TRAJECTORY";
        public static const UPDATE_TRAJECTORY: String = "Space.UPDATE_TRAJECTORY";
        public static const HIDE_TRAJECTORY: String = "Space.HIDE_TRAJECTORY";
        public static const LEVEL_COMPLETE: String = "Space.LEVEL_COMPLETE";

        public static const G: Number = 66.7;
        public static const DISTANCE_POWER: Number = 2;
        public static const DELTA: Number = 0.15;
        public static const MIN_SPEED: Number = 5;
        public static const DAMAGE_SPEED: Number = 30;
        public static const CONTROL_SPEED: Number = 200;
        public static const TRAJECTORY_STEPS: int = 200; // 20 min, 250 max
        public static const TRAJECTORY_LENGTH: int = 100000; // 100 min, 100000 max

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
        
        private var _portals: Vector.<Portal>;
        public function get portals():Vector.<Portal>
        {
            return _portals;
        }
        private var _portalsMatrix: Dictionary;
        
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
        
        private var _viewports: Vector.<Rectangle>;
        
        private var _viewport: Rectangle;
        public function get viewport():Rectangle
        {
            return _viewport;
        }

        private var _pullPoint: Point;

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

        private var _dialogController: DialogController;
        public function get dialogController():DialogController
        {
            return _dialogController;
        }

        private var _landPlanet: Planet;

        private var _phantom: Ship;
        public function get phantom():Ship
        {
            return _phantom;
        }

        private var _moves: int;
        public function get moves():int
        {
            return _moves;
        }

        private var _complete: Boolean;
        private var _completeNotify: Boolean;
        
        private var _win: Boolean;
        public function get win():Boolean
        {
            return _win;
        }
        
        private var _revived: Boolean;
        public function get revived():Boolean
        {
            return _revived;
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

            _portals = new <Portal>[];
            _portalsMatrix = new Dictionary();
            for (i = 0; i < level.portals.length; i++)
            {
                var port: PortalVO = level.portals[i];
                var portal: Portal = new Portal(15);
                portal.place(port.position.x, port.position.y);
                _portals.push(portal);

                if (i % 2 == 1)
                {
                    previous.connection = portal;
                    portal.connection = previous;
                }
                var previous: Portal = portal;
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

            _viewports = level.viewports;

            _pullPoint = new Point();
            _trajectory = new <Point>[];
            
            _time = 0;
            _shipTime = 0;
            _moves = 0;
            _complete = false;
            _completeNotify = false;
            _win = false;
            _revived = false;

            _zoneController = new ZoneController();

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

            _dialogController = new DialogController();
//            _dialogController.init();
//            _dialogController.start();
            
            GamePlayAnalytics.startLevel(level.id);
        }
        
        public function pause(value: Boolean):void
        {
            dispatchEventWith(PAUSE, false, value);
        }
        
        public function revive(value: Boolean):void
        {
            if (value)
            {
                if (!_ship.alive)
                {
                    _ship.repair();
                }
                _ship.update();
            }
            _revived = true;
            _complete = false;
            _completeNotify = false;
        }
        
        public function restart(level: LevelVO):void
        {
            destroy();
            init(level);
            dispatchEventWith(RESTART);
        }

        public function lose():void
        {
            _complete = true;
            _win = false;
        }

        public function destroy():void
        {
            Starling.juggler.removeDelayedCalls(computeTrajectory);
            
            _ship.destroy();
            _ship = null;
            
            if (_phantom != null)
            {
                _phantom.destroy();
                _phantom = null;
            }
            
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

            while (_portals.length > 0)
            {
                var portal: Portal = _portals.shift();
                portal.destroy();
            }
            _portalsMatrix = null;
            _portals = null;

            while (_dynamics.length > 0)
            {
                var body: DynamicSpaceBody = _dynamics.shift();
                body.destroy();
            }
            _dynamics = null;

            _landPlanet = null;

            _viewport = null;
            _viewports = null;
            _pullPoint = null;
            _trajectory = null;
            
            _zoneController.destroy();
            _zoneController = null;

            _orderController.removeEventListener(OrderController.DONE, handleOrdersDone);
            _orderController.destroy();
            _orderController = null;
        }

        public function setPullPoint(angle: Number, power: Number, full: Boolean, show: Boolean):void
        {
            if (_ship.stable)
            {
                GamePlayAnalytics.setMovement(angle, power);
                
                var planet: Planet = _ship.planet;
                var d: Number = Point.distance(planet.position, _ship.position);
                var pow: Number = Math.sqrt(G * planet.mass / d * power);
                _pullPoint.x = Math.cos(angle) * pow;
                _pullPoint.y = Math.sin(angle) * pow;
                updateTrajectory(full, show);
            }
        }

        public function updateTrajectory(full: Boolean, show: Boolean):void
        {
            if (_ship.stable)
            {
                Starling.juggler.removeDelayedCalls(computeTrajectory);
                _trajectory.length = 0;
                _trajectoryTime = 0;
                dispatchEventWith(SHOW_TRAJECTORY);
                
                if (_phantom != null)
                {
                    _phantom.destroy();
                    _phantom = null;
                }

                Starling.juggler.removeDelayedCalls(createPhantom);
                Starling.juggler.delayCall(createPhantom, 0, show, full);
            }
        }

        private function createPhantom(show: Boolean, full: Boolean):void
        {
            _phantom = _ship.clone() as Ship;
            launchShip(_phantom);

            computeTrajectory(_phantom, show, full);
        }

        private function computeTrajectory(ship: Ship, show: Boolean, full: Boolean):void
        {
            var i: int = 0;
            while (!ship.stable && ship.alive && i < TRAJECTORY_STEPS)
            {
                i++;
                _trajectory.push(ship.position.clone());
                step(ship, DELTA);
                _trajectoryTime += DELTA;
            }

            if (_trajectory.length <= 10) return;

            if (show)
            {
                dispatchEventWith(UPDATE_TRAJECTORY);
            }

            if ((_trajectory.length < TRAJECTORY_LENGTH || full) && !ship.stable && ship.alive)
            {
                Starling.juggler.delayCall(computeTrajectory, 0, ship, show, full);
            }
        }

        public function launch():void
        {
            if (_ship.stable && _trajectory.length > 10)
            {
                GamePlayAnalytics.launch();
                
                computeTrajectory(_phantom, false, true);

                launchShip(_ship);
                _moves++;

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

        public function launchShip(ship: Ship):void
        {
            ship.launch(1);
            ship.accelerate(_pullPoint.x, _pullPoint.y);
        }

        private function step(body: DynamicSpaceBody, delta: Number):void
        {
            if (!body.stable)
            {
                checkMove(body, delta);
                checkGravity(body, delta);
                checkSpeed(body);
                checkCollectibles(body as Ship);
                checkPortals(body);
                body.update();
            }
        }

        private function checkGravity(body: DynamicSpaceBody, delta: Number):void
        {
            var acX: Number = 0;
            var acY: Number = 0;
            for (var i:int = 0; i < _planets.length; i++)
            {
                var planet: Planet = _planets[i];
                var d: Number = Point.distance(planet.position, body.position);
                var angle: Number = Math.atan2(planet.y - body.y, planet.x - body.x);
                var accMod: Number = G * planet.mass / Math.pow(d, DISTANCE_POWER) * delta;
                acX += accMod * Math.cos(angle);
                acY += accMod * Math.sin(angle);
            }
            body.accelerate(acX, acY);
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
                    if (body is Ship)
                    {
                        checkLand(body as Ship, planetCollided);
                    }
                }

                if (body.alive)
                {
                    body.move(currentDelta);
                }

                delta -= currentDelta;
                currentDelta = Math.min(delta, maxDelta);
            }
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

        private function checkCollectibles(ship: Ship):void
        {
            if (ship == _ship)
            {
                for (var i: int = 0; i < _collectibles.length; i++)
                {
                    var collectible: Collectible = _collectibles[i];
                    var d: Number = Point.distance(collectible.position, ship.position);
                    if (d <= ship.radius + collectible.radius)
                    {
                        // TODO: add reward, do some stuff
                        SoundManager.playSound(SoundManager.BOX_TAKE);
                        collectible.collect();

                        _collectibles.splice(i--, 1);
                    }
                }
            }
        }

        private function checkPortals(body: DynamicSpaceBody):void
        {
            var portalCollision: Portal;
            for (var i: int = 0; i < _portals.length; i++)
            {
                var portal: Portal = _portals[i];
                var d: Number = Point.distance(portal.position, body.position);
                if (d <= body.radius + portal.radius)
                {
                    portalCollision = portal;
                }
            }
            if (portalCollision == null)
            {
                delete _portalsMatrix[body];
            } else if (_portalsMatrix[body] != portalCollision)
            {
                var delta:Point = body.position.subtract(portalCollision.position);
                body.place(portalCollision.connection.position.x + delta.x, portalCollision.connection.position.y + delta.y);
                _portalsMatrix[body] = portalCollision.connection;
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
                        var damage: int = 0;
                        if (!planet.type.safe)
                        {
                            damage = int.MAX_VALUE;
                        } else if (body.speedMod >= DAMAGE_SPEED)
                        {
                            damage = 1;
                        }
                        
                        if (damage > 0 && body is Ship)
                        {
                            (body as Ship).collide(damage);
                        } else {
                            body.rotate(GeomUtils.getVectorDelta(body.speed, bodyPlanet) * 2 - Math.PI);
                            body.multiply(body is Ship ? planet.bounce * 0.01 : 1);
                        }
                        return planet;
                    } else if (d <= body.radius*2)
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
            _time += delta;
            var amount: int = _time * 1000 * DELTA;
            _time -= amount / (1000 * DELTA);
            
            processShip(delta);
            processMeteors(amount);
        }

        public function processMeteors(amount: Number):void
        {
            var max: int = _viewport.width * _viewport.height * 0.00001;
            if (_dynamics.length < max && Math.random() < 0.005)
            {
                createMeteor();
            }

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
        }
        
        private function processShip(delta: Number):void
        {
            if (_complete)
            {
                if (!_completeNotify)
                {
                    _completeNotify = true;
                    dispatchEventWith(LEVEL_COMPLETE);
                }
            } else if (!_ship.alive)
            {
                lose();
            }

            if (_ship.stable) return;

            var scaleSize: Number = 50 * DELTA;
            var fromStart: Number = _flightTime / scaleSize;
            var toEnd: Number = ship.speedMod >= DAMAGE_SPEED ? 1 : (_trajectoryTime - _flightTime) / scaleSize;
            var timeScale: Number = Math.sqrt(Math.max(0.01, Math.min(1, fromStart, toEnd)));

            _shipTime += delta * timeScale;
            var amount: int = _shipTime * 1000 * DELTA;
            _shipTime -= amount / (1000 * DELTA);
            for (var i: int = 0; i < amount; i++)
            {
                step(_ship, DELTA);
                _flightTime += DELTA;
            }

            if (_landPlanet != null && _trajectoryTime - _flightTime < 10)
            {
                _ship.landPrepare(_landPlanet);
            }

            var shipRect: Rectangle = new Rectangle(ship.x - ship.radius, ship.y - ship.radius, ship.radius * 2, ship.radius * 2);
            if (_viewport == null || !_viewport.intersects(shipRect))
            {
                var nearest: Rectangle;
                var distance: Number;
                for (i = 0; i < _viewports.length; i++)
                {
                    var viewport: Rectangle = _viewports[i];
                    var dist: Number = Point.distance(new Point(viewport.x + viewport.width * 0.5, viewport.y + viewport.height * 0.5), _ship.position);
                    if (nearest == null || distance > dist)
                    {
                        nearest = viewport;
                        distance = dist;
                    }
                    _viewport = nearest;
                }
            }
        }

        private function handleOrdersDone(event: Event):void
        {
            _win = true;
            _complete = true;
        }
    }
}
