/**
 * Created by agnither on 16.11.16.
 */
package com.agnither.spacetaxi.controller.game
{
    import com.agnither.spacetaxi.model.Order;
    import com.agnither.spacetaxi.model.Ship;

    import starling.events.EventDispatcher;

    public class OrderController extends EventDispatcher
    {
        public static const UPDATE: String = "OrderController.UPDATE";

        private var _orders: Vector.<Order>;
        public function get orders():Vector.<Order>
        {
            return _orders;
        }
        
        private var _money: int;
        public function get money():int
        {
            return _money;
        }
        
        public function OrderController()
        {
            _orders = new <Order>[];
            _money = 0;
        }
        
        public function start():void
        {
            for (var i:int = 0; i < _orders.length; i++)
            {
                var order: Order = _orders[i];
                order.activate();
            }
        }
        
        public function addOrder(order: Order):void
        {
            _orders.push(order);
            dispatchEventWith(UPDATE);
        }

        public function removeOrder(order: Order):void
        {
            _orders.splice(_orders.indexOf(order), 1);
            dispatchEventWith(UPDATE);
        }

        public function checkOrders(ship: Ship):void
        {
            for (var i:int = 0; i < _orders.length; i++)
            {
                var order: Order = _orders[i];
                if (!order.started && order.departure.check(ship))
                {
                    order.start();
                    ship.order(true);
                } else if (order.started && order.arrival.check(ship))
                {
                    _money += order.money;
                    order.complete();
                    ship.order(false);

                    removeOrder(order);
                }
            }
        }
        
        public function step(delta: Number):void
        {
            for (var i:int = 0; i < _orders.length; i++)
            {
                _orders[i].step(delta);
            }
        }

        public function checkDamage(value: Number):void
        {
            for (var i:int = 0; i < _orders.length; i++)
            {
                _orders[i].damage(value);
            }
        }
    }
}
