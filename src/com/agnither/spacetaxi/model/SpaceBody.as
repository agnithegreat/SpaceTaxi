/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import flash.geom.Point;

    import starling.events.EventDispatcher;

    public class SpaceBody extends EventDispatcher
    {
        public static const UPDATE: String = "SpaceBody.UPDATE";

        protected var _radius: int;
        public function get radius():int
        {
            return _radius;
        }

        protected var _mass: Number;
        public function get mass():Number
        {
            return _mass;
        }
        
        protected var _position: Point;
        public function get position():Point
        {
            return _position;
        }
        public function get x():int
        {
            return Math.round(_position.x);
        }
        public function get y():int
        {
            return Math.round(_position.y);
        }
        
        public function SpaceBody(radius: int, mass: Number)
        {
            _radius = radius;
            _mass = mass;
            
            _position = new Point();
        }
        
        public function place(x: Number, y: Number):void
        {
            _position.x = x;
            _position.y = y;
        }
        
        public function update():void
        {
            dispatchEventWith(UPDATE);
        }
        
        public function clone():SpaceBody
        {
            var body: SpaceBody = new SpaceBody(_radius, _mass);
            body.place(_position.x, _position.y); 
            return body;
        }
    }
}
