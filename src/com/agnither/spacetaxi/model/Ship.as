/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    public class Ship extends DynamicSpaceBody
    {
        public static const COLLIDE: String = "Ship.COLLIDE";
        public static const LAND: String = "Ship.LAND";
        public static const CRASH: String = "Ship.CRASH";
        
        private var _rotation: Number;
        public function get rotation():Number
        {
            return _rotation;
        }
        
        protected var _landed: Boolean;
        public function get landed():Boolean
        {
            return _landed;
        }
        
        protected var _crashed: Boolean;
        public function get crashed():Boolean
        {
            return _crashed;
        }
        
        protected var _orders: Vector.<Order>;

        public function Ship(radius: int, mass: Number)
        {
            super(radius, mass);

            _rotation = 0;
            
            _orders = new <Order>[];
        }

        public function launch():void
        {
            _landed = false;
        }

        public function collide():void
        {
            dispatchEventWith(COLLIDE);
        }

        override public function accelerate(x: Number, y: Number):void
        {
            super.accelerate(x, y);

            _rotation = Math.atan2(y, x);
            dispatchEventWith(UPDATE);
        }
        
        public function land():void
        {
            stop();
            _landed = true;
            dispatchEventWith(LAND);
        }

        public function crash():void
        {
            stop();
            _crashed = true;
            dispatchEventWith(CRASH);
        }

        public function stop():void
        {
            _speed.x = 0;
            _speed.y = 0;
        }
        
        public function addOrder(order: Order):void
        {
            _orders.push(order);
        }
        
        public function hasOrder(order: Order):Boolean
        {
            return _orders.indexOf(order) >= 0;
        }

        public function removeOrder(order: Order):void
        {
            _orders.splice(_orders.indexOf(order), 1);
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
