/**
 * Created by agnither on 14.11.16.
 */
package com.holypanda.kosmos.model
{
    import flash.geom.Point;

    import starling.animation.IAnimatable;

    import starling.events.EventDispatcher;

    public class SpaceBody extends EventDispatcher implements IAnimatable
    {
        public static const UPDATE: String = "SpaceBody.UPDATE";

        protected var _radius: int;
        public function get radius():int
        {
            return _radius;
        }

        protected var _mass: int;
        public function get mass():int
        {
            return _mass;
        }
        
        protected var _position: Point;
        public function get position():Point
        {
            return _position;
        }
        public function get x():Number
        {
            return _position.x;
        }
        public function get y():Number
        {
            return _position.y;
        }

        protected var _alive: Boolean;
        public function get alive():Boolean
        {
            return _alive;
        }
        
        public function SpaceBody(radius: int, mass: int)
        {
            _radius = radius;
            _mass = mass;
            _alive = true;
            
            _position = new Point();
        }
        
        public function place(x: Number, y: Number):void
        {
            _position.x = x;
            _position.y = y;
        }

        public function advanceTime(delta: Number):void
        {
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

        public function reset():void
        {
            _alive = true;
        }
        
        public function destroy():void
        {
            removeEventListeners(UPDATE);
            
            _position = null;
        }
    }
}
