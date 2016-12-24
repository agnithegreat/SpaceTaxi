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
            return Math.max(0, _money * moodMultiplier);
        }

        private var _mood: Number;
        public function get moodMultiplier():Number
        {
            return (_mood - _time) * 0.01;
        }

        private var _time: Number;
        private var _startTime: Number;
        private var _endTime: Number;
        
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

        public function Order(money: int, mood: Number, departure: Zone, arrival: Zone)
        {
            _money = money;
            _mood = Math.min(mood, 100);
            _departure = departure;
            _arrival = arrival;
        }

        public function activate():void
        {
            _active = true;
            _time = 0;

            _departure.active = true;
        }

        public function start():void
        {
            _started = true;
            _startTime = _time;
            
            _departure.active = false;
            _arrival.active = true;
        }

        public function complete():void
        {
            _active = false;
            _started = false;
            _completed = true;
            _endTime = _time;

            _arrival.active = false;
        }

        public function damage(value: Number):void
        {
            if (_started)
            {
                _mood -= value;
            }
        }

        public function step(delta: Number):void
        {
            if (_active)
            {
                _time += delta;
            }
        }
        
        public function destroy():void
        {
            _departure = null;
            _arrival = null;
        }
    }
}
