/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    public class Planet extends SpaceBody
    {
        public function Planet(radius: int, mass: Number)
        {
            super(radius, mass);
        }

        override public function clone():SpaceBody
        {
            var body: Planet = new Planet(_radius, _mass);
            body.place(_position.x, _position.y);
            return body;
        }
    }
}
