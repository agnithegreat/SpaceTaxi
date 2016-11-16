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
        
        protected var _crashed: Boolean;
        public function get crashed():Boolean
        {
            return _crashed;
        }
        
        protected var _orders: Vector.<Order>;

        public function Ship(radius: int, mass: Number)
        {
            super(radius, mass);

            _orders = new <Order>[];
        }

        public function launch():void
        {
            _landed = false;
        }
        
        public function land():void
        {
            stop();
            _landed = true;
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

        public function crash():void
        {
            stop();
            _crashed = true;
        }

        public function stop():void
        {
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
