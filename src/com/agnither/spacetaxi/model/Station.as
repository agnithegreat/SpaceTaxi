/**
 * Created by agnither on 21.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.model.orders.Zone;

    public class Station
    {
        private var _price: Number;
        public function get price():Number
        {
            return _price;
        }
        
        private var _zone: Zone;
        public function get zone():Zone
        {
            return _zone;
        }
        
        public function Station(price: Number, zone: Zone)
        {
            _price = price;
            
            _zone = zone;
            _zone.active = true;
        }
    }
}
