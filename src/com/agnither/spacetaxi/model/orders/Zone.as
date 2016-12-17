/**
 * Created by agnither on 15.11.16.
 */
package com.agnither.spacetaxi.model.orders
{
    import com.agnither.spacetaxi.model.Order;
    import com.agnither.spacetaxi.model.Ship;
    import com.agnither.spacetaxi.model.Station;
    import com.agnither.spacetaxi.vo.ZoneVO;

    import flash.geom.Point;

    import starling.events.EventDispatcher;

    public class Zone extends EventDispatcher
    {
        public static const UPDATE: String = "Zone.UPDATE";
        
        private var _zone: ZoneVO;
        public function get zone():ZoneVO
        {
            return _zone;
        }
        
        private var _order: Order;
        public function get order():Order
        {
            return _order;
        }

        private var _station: Station;
        public function get station():Station
        {
            return _station;
        }
        
        public function Zone(zone: ZoneVO)
        {
            _zone = zone;
        }
        
        public function check(ship: Ship):Boolean
        {
            return Point.distance(ship.position, new Point(_zone.x, _zone.y)) <= _zone.size;
        }
        
        public function setOrder(order: Order):void
        {
            _order = order;
            dispatchEventWith(UPDATE);
        }

        public function setStation(station: Station):void
        {
            _station = station;
            dispatchEventWith(UPDATE);
        }
    }
}
