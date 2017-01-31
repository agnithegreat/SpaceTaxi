/**
 * Created by agnither on 15.11.16.
 */
package com.holypanda.kosmos.model
{
    import com.holypanda.kosmos.model.orders.Zone;

    import starling.events.EventDispatcher;

    public class Order extends EventDispatcher
    {
        private var _money: int;
        public function get money():int
        {
            return _money;
        }
        
        private var _wave: int;
        public function get wave():int
        {
            return _wave;
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

        private var _active: Boolean;
        public function get active():Boolean
        {
            return _active;
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

        public function Order(money: int, wave: int, mood: Number, departure: Zone, arrival: Zone)
        {
            _money = money;
            _wave = wave;
            _departure = departure;
            _arrival = arrival;
        }

        public function activate():void
        {
            _active = true;
            _departure.active = true;
        }

        public function start():void
        {
            _started = true;
            _departure.active = false;
            _arrival.active = true;
        }

        public function complete():void
        {
            _active = false;
            _started = false;
            _completed = true;

            _arrival.active = false;
        }
        
        public function destroy():void
        {
            _departure = null;
            _arrival = null;
        }
    }
}
