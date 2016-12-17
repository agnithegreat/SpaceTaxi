/**
 * Created by agnither on 17.12.16.
 */
package com.agnither.spacetaxi.utils
{
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.spacetaxi.vo.OrderVO;
    import com.agnither.spacetaxi.vo.PlanetVO;
    import com.agnither.spacetaxi.vo.ShipVO;
    import com.agnither.spacetaxi.vo.ZoneVO;

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
                planet.x = pl.x;
                planet.y = pl.y;
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
                order.departure.x = or.departure.x;
                order.departure.y = or.departure.y;
                order.departure.size = or.departure.size;

                order.arrival = new ZoneVO();
                order.arrival.x = or.arrival.x;
                order.arrival.y = or.arrival.y;
                order.arrival.size = or.arrival.size;
                
                orders.push(order);
            }
            data.orders = orders;

            return data;
        }
    }
}
