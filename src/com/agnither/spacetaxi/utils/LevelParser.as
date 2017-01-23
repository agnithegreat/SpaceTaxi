/**
 * Created by agnither on 17.12.16.
 */
package com.agnither.spacetaxi.utils
{
    import com.agnither.spacetaxi.vo.CollectibleVO;
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.spacetaxi.vo.ObjectVO;
    import com.agnither.spacetaxi.vo.OrderVO;
    import com.agnither.spacetaxi.vo.PlanetVO;
    import com.agnither.spacetaxi.vo.PortalVO;
    import com.agnither.spacetaxi.vo.ShipVO;
    import com.agnither.spacetaxi.vo.ZoneVO;

    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.Dictionary;

    public class LevelParser
    {
        public static const colors: Dictionary = new Dictionary();
        
        public static function init():void
        {
            colors["1/2"] = 0x18dce6;
            colors["1/4"] = 0xf64b2c;
            colors["1/8"] = 0x77da1b;
            colors["2/2"] = 0x00c3ee;
            colors["2/3"] = 0x81ee00;
            colors["2/4"] = 0xee002d;
        }
        
        public static function parse(id: int, episode: int, level: Object):LevelVO
        {
            var data: LevelVO = new LevelVO();

            data.id = id;
            data.episode = episode;

            if (level == null) return data;
            
            data.title = level.settings.title;
            data.stars = level.settings.stars;
            
            data.viewport = new Rectangle(level.viewport.x, level.viewport.y, level.viewport.width, level.viewport.height);
            
            var planets: Vector.<PlanetVO> = new <PlanetVO>[];
            for (var i:int = 0; i < level.planets.length; i++)
            {
                var pl: Object = level.planets[i];
                var planet: PlanetVO = new PlanetVO();
                planet.position = new Point(pl.x, pl.y);
                planet.radius = pl.radius;
                planet.mass = pl.mass;
                planet.bounce = pl.bounce;
                planet.type = pl.type;
                planet.skin = pl.skin;
                planets.push(planet);
            }
            data.planets = planets;

            var portals: Vector.<PortalVO> = new <PortalVO>[];
            for (i = 0; i < level.portals.length; i++)
            {
                var port: Object = level.portals[i];
                var portal: PortalVO = new PortalVO();
                portal.position = new Point(port.x, port.y);
                portal.radius = port.radius;
                portals.push(portal);
            }
            data.portals = portals;

            var ship: ShipVO = new ShipVO();
            ship.position = new Point(level.ship.x, level.ship.y);
            ship.rotation = level.ship.rotation;
            magnetToPlanet(ship, getNearestPlanet(ship.position, planets), 10);
            data.ship = ship;
            
            var orders: Vector.<OrderVO> = new <OrderVO>[];
            for (i = 0; i < level.orders.length; i++)
            {
                var or: Object = level.orders[i];
                var order: OrderVO = new OrderVO();
                order.id = or.id;
                order.cost = or.cost;
                order.wave = or.wave;
                
                order.departure = new ZoneVO();
                order.departure.type = or.departure.type;
                order.departure.position = new Point(or.departure.x, or.departure.y);
                order.departure.size = or.departure.size;
                order.departure.planet = getNearestPlanet(order.departure.position, planets);
                magnetToPlanet(order.departure, order.departure.planet, 0);

                order.arrival = new ZoneVO();
                order.arrival.type = or.arrival.type;
                order.arrival.position = new Point(or.arrival.x, or.arrival.y);
                order.arrival.size = or.arrival.size;
                order.arrival.planet = getNearestPlanet(order.arrival.position, planets);
                magnetToPlanet(order.arrival, order.arrival.planet, 0);

                orders.push(order);
            }
            data.orders = orders;

            var zones: Vector.<ZoneVO> = new <ZoneVO>[];
            for (i = 0; i < level.zones.length; i++)
            {
                var z: Object = level.zones[i];
                var zone: ZoneVO = new ZoneVO();
                zone.type = z.type;
                zone.position = new Point(z.x, z.y);
                zone.size = z.size;
                zone.planet = getNearestPlanet(zone.position, planets);
                magnetToPlanet(zone, zone.planet, 0);
                zones.push(zone);
            }
            data.zones = zones;

            var collectibles: Vector.<CollectibleVO> = new <CollectibleVO>[];
            for (i = 0; i < level.collectibles.length; i++)
            {
                var coll: Object = level.collectibles[i];
                var collectible: CollectibleVO = new CollectibleVO();
                collectible.position = new Point(coll.x, coll.y);
                collectible.type = coll.type;
                collectible.size = coll.size;
                collectibles.push(collectible);
            }
            data.collectibles = collectibles;

            return data;
        }
        
        private static function getNearestPlanet(position: Point, planets: Vector.<PlanetVO>):PlanetVO
        {
            var nearestPlanet: PlanetVO = null;
            var nearestDistance: Number = 0;
            for (var i:int = 0; i < planets.length; i++)
            {
                var planet: PlanetVO = planets[i];
                var distance: Number = Point.distance(position, planet.position);
                if (nearestPlanet == null || nearestDistance > distance)
                {
                    nearestPlanet = planet;
                    nearestDistance = distance;
                }
            }
            return nearestPlanet;
        }
        
        private static function magnetToPlanet(object: ObjectVO, planet: PlanetVO, radius: Number):void
        {
            var angle: Number = Math.atan2(object.position.y - planet.position.y, object.position.x - planet.position.x);
            object.position.x = planet.position.x + (planet.radius + radius) * Math.cos(angle);
            object.position.y = planet.position.y + (planet.radius + radius) * Math.sin(angle);
        }
    }
}
