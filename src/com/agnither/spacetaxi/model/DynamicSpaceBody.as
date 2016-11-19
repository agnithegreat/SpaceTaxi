/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import flash.geom.Point;

    public class DynamicSpaceBody extends SpaceBody
    {
        protected var _speed: Point;
        public function get speed():Point
        {
            return _speed;
        }

        public function DynamicSpaceBody(radius: int, mass: Number)
        {
            _speed = new Point();
            super(radius, mass);
        }

        public function move(delta: Number):void
        {
            _position.x += _speed.x * delta;
            _position.y += _speed.y * delta;
        }

        public function accelerate(x: Number, y: Number):void
        {
            _speed.x += x;
            _speed.y += y;
        }

        public function rotate(angle: Number):void
        {
            var tx: Number = _speed.x * Math.cos(angle) - _speed.y * Math.sin(angle);
            var ty: Number = _speed.x * Math.sin(angle) + _speed.y * Math.cos(angle);
            _speed.x = tx;
            _speed.y = ty;
        }

        public function multiply(multiplier: Number):void
        {
            _speed.x *= multiplier;
            _speed.y *= multiplier;
        }

        override public function clone():SpaceBody
        {
            var body: DynamicSpaceBody = new DynamicSpaceBody(_radius, _mass);
            body.place(_position.x, _position.y);
            body.accelerate(_speed.x, _speed.y);
            return body;
        }

        override public function reset():void
        {
            super.reset();
            
            _speed.x = 0;
            _speed.y = 0;
        }
    }
}
