/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    public class Ship extends DynamicSpaceBody
    {
        protected var _landed: Boolean;
        public function get landed():Boolean
        {
            return _landed;
        }

        public function Ship(radius: int, mass: Number)
        {
            super(radius, mass);
        }

        public function launch():void
        {
            _landed = false;
        }
        
        public function land():void
        {
            _landed = true;
            _speed.x = 0;
            _speed.y = 0;
        }

        override public function clone():SpaceBody
        {
            var body: Ship = new Ship(_radius, _mass);
            body.place(_position.x, _position.y);
            body.accelerate(_speed.x, _speed.y);
            return body;
        }
    }
}
