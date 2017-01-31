/**
 * Created by agnither on 17.12.16.
 */
package com.holypanda.kosmos.vo
{
    import com.holypanda.kosmos.vo.game.CollectibleVO;
    import com.holypanda.kosmos.vo.game.OrderVO;
    import com.holypanda.kosmos.vo.game.PlanetVO;
    import com.holypanda.kosmos.vo.game.PortalVO;
    import com.holypanda.kosmos.vo.game.ShipVO;
    import com.holypanda.kosmos.vo.game.ZoneVO;

    import flash.geom.Rectangle;

    public class LevelVO
    {
        public var id: int;
        public var episode: int;
        
        public var stars: Array;
        
        public var ship: ShipVO;
        public var planets: Vector.<PlanetVO>;
        public var portals: Vector.<PortalVO>;
        public var orders: Vector.<OrderVO>;
        public var zones: Vector.<ZoneVO>;
        public var collectibles: Vector.<CollectibleVO>;
        public var viewports: Vector.<Rectangle>;
        
        public function countStars(moves: int):int
        {
            var count: int = 3;
            while (count > 1 && stars[3-count] < moves)
            {
                count--;
            }
            return count;
        }
        
        public function get reward():int
        {
            var sum: int = 0;
            for (var i:int = 0; i < orders.length; i++)
            {
                sum += orders[i].cost;
            }
            return sum;
        }
    }
}
