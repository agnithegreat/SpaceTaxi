/**
 * Created by agnither on 21.11.16.
 */
package com.agnither.spacetaxi.model
{
    public class Station
    {
        private var _price: Number;
        public function get price():Number
        {
            return _price;
        }
        
        public function Station(price: Number)
        {
            _price = price;
        }
    }
}
