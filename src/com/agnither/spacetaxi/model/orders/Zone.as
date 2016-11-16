/**
 * Created by agnither on 15.11.16.
 */
package com.agnither.spacetaxi.model.orders
{
    import com.agnither.spacetaxi.model.Order;
    import com.agnither.spacetaxi.model.Planet;

    import starling.events.EventDispatcher;

    public class Zone extends EventDispatcher
    {
        public static const UPDATE: String = "Zone.UPDATE";
        
        private var _planet: Planet;
        public function get planet():Planet
        {
            return _planet;
        }
        
        private var _angle: Number;
        public function get angle():Number
        {
            return _angle;
        }

        private var _size: Number;
        public function get size():Number
        {
            return _size;
        }
        
        private var _order: Order;
        public function get order():Order
        {
            return _order;
        }
        
        public function Zone(planet: Planet, angle: Number, size: Number)
        {
            _planet = planet;
            _angle = angle;
            _size = size;
        }
        
        public function setOrder(order: Order):void
        {
            _order = order;
            dispatchEventWith(UPDATE);
        }
    }
}
