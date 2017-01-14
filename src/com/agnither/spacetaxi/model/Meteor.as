/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    public class Meteor extends DynamicSpaceBody
    {
        public function Meteor(radius: int, mass: Number)
        {
            super(radius, mass);

            _maxSpeed = 100;
            
            reset();
        }
        
        override public function clone():SpaceBody
        {
            var body: Meteor = new Meteor(_radius, _mass);
            body.place(_position.x, _position.y);
            body.accelerate(_speed.x, _speed.y);
            return body;
        }
    }
}
