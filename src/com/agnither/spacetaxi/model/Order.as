/**
 * Created by agnither on 15.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.model.orders.Zone;

    import starling.events.EventDispatcher;

    public class Order extends EventDispatcher
    {
        private var _money: int;
        public function get money():int
        {
            return _money;
        }
        
        private var _departure: Zone;
        public function get departure():Zone
        {
            return _departure;
        }
        
        private var _arrival: Zone;
        public function get arrival():Zone
        {
            return _arrival;
        }
        
        private var _started: Boolean;
        public function get started():Boolean
        {
            return _started;
        }
        
        private var _completed: Boolean;
        public function get completed():Boolean
        {
            return _completed;
        }

        public function Order(money: int, departure: Zone, arrival: Zone)
        {
            _money = money;
            _departure = departure;
            _arrival = arrival;
        }
        
        public function activate():void
        {
            _departure.setOrder(this);
            _arrival.setOrder(this);
        }
        
        public function start():void
        {
            _started = true;
        }

        public function complete():void
        {
            _completed = true;
            _started = false;
        }
    }
}
