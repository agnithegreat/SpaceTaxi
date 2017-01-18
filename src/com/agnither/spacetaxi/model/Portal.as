/**
 * Created by agnither on 21.11.16.
 */
package com.agnither.spacetaxi.model
{
    public class Portal extends SpaceBody
    {
        private var _connection: Portal;
        public function set connection(value: Portal):void
        {
            _connection = value;
        }
        public function get connection():Portal
        {
            return _connection;
        }
        
        public function Portal(radius: Number)
        {
            super(radius, 0);
        }
    }
}
