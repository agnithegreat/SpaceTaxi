/**
 * Created by agnither on 17.12.16.
 */
package com.holypanda.kosmos.utils
{
    import com.holypanda.kosmos.vo.LevelVO;
    import com.holypanda.kosmos.vo.game.CollectibleVO;
    import com.holypanda.kosmos.vo.game.ObjectVO;
    import com.holypanda.kosmos.vo.game.PlanetVO;
    import com.holypanda.kosmos.vo.game.PortalVO;
    import com.holypanda.kosmos.vo.game.ShipVO;
    import com.holypanda.kosmos.vo.game.ZoneVO;

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
            
            data.stars = level.settings.stars;
            
            data.viewports = new <Rectangle>[];
            for (var i:int = 0; i < level.viewports.length; i++)
            {
                var viewport: Object = level.viewports[i];
                data.viewports.push(new Rectangle(viewport.x, viewport.y, viewport.width, viewport.height));
            }
            
            var planets: Vector.<PlanetVO> = new <PlanetVO>[];
            for (i = 0; i < level.planets.length; i++)
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

            var zones: Vector.<ZoneVO> = new <ZoneVO>[];
            for (i = 0; i < level.zones.length; i++)
            {
                var z: Object = level.zones[i];
                var zone: ZoneVO = new ZoneVO();
                zone.id = z.id;
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
            var angle: Number = GeomUtils.getAngle(planet.position, object.position);
            object.position.x = planet.position.x + (planet.radius + radius) * Math.cos(angle);
            object.position.y = planet.position.y + (planet.radius + radius) * Math.sin(angle);
        }
    }
}
