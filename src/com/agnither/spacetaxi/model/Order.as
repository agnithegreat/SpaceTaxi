/**
 * Created by agnither on 15.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.model.orders.Zone;

    import starling.events.EventDispatcher;

    public class Order extends EventDispatcher
    {
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

        public function Order(departure: Zone, arrival: Zone)
        {
            _departure = departure;
            _arrival = arrival;
        }
        
        public function activate():void
        {
            _departure.setOrder(this);
            _arrival.setOrder(this);
        }
    }
}
