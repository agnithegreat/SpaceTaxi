/**
 * Created by agnither on 17.12.16.
 */
package com.agnither.spacetaxi.vo
{
    import flash.geom.Rectangle;

    public class LevelVO
    {
        public var id: int;
        public var episode: int;
        
        public var title: String;
        public var stars: Array;
        
        public var ship: ShipVO;
        public var planets: Vector.<PlanetVO>;
        public var portals: Vector.<PortalVO>;
        public var orders: Vector.<OrderVO>;
        public var zones: Vector.<ZoneVO>;
        public var collectibles: Vector.<CollectibleVO>;
        public var viewport: Rectangle;
        
        public function countStars(moves: int):int
        {
            var count: int = 3;
            while (count > 0 && stars[count-1] < moves)
            {
                count--;
            }
            return count;
        }
    }
}
