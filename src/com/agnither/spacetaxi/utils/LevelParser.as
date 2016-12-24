/**
 * Created by agnither on 17.12.16.
 */
package com.agnither.spacetaxi.utils
{
    import com.agnither.spacetaxi.vo.CollectibleVO;
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.spacetaxi.vo.OrderVO;
    import com.agnither.spacetaxi.vo.PlanetVO;
    import com.agnither.spacetaxi.vo.ShipVO;
    import com.agnither.spacetaxi.vo.ZoneVO;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class LevelParser
    {
        public static function parse(level: Object):LevelVO
        {
            var data: LevelVO = new LevelVO();

            data.viewport = new Rectangle(level.viewport.x, level.viewport.y, level.viewport.width, level.viewport.height);

            var ship: ShipVO = new ShipVO();
            ship.x = level.ship.x;
            ship.y = level.ship.y;
            ship.rotation = level.ship.rotation;
            data.ship = ship;
            
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
            
            var orders: Vector.<OrderVO> = new <OrderVO>[];
            for (i = 0; i < level.orders.length; i++)
            {
                var or: Object = level.orders[i];
                var order: OrderVO = new OrderVO();
                order.id = or.id;
                order.cost = or.cost;
                
                order.departure = new ZoneVO();
                order.departure.type = or.departure.type;
                order.departure.position = new Point(or.departure.x, or.departure.y);
                order.departure.size = or.departure.size;
                order.departure.planet = getNearestPlanet(order.departure.position, planets);

                order.arrival = new ZoneVO();
                order.arrival.type = or.arrival.type;
                order.arrival.position = new Point(or.arrival.x, or.arrival.y);
                order.arrival.size = or.arrival.size;
                order.arrival.planet = getNearestPlanet(order.arrival.position, planets);
                
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
    }
}
