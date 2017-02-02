/**
 * Created by agnither on 16.11.16.
 */
package com.holypanda.kosmos.controller.game
{
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.model.Order;
    import com.holypanda.kosmos.model.Ship;
    import com.holypanda.kosmos.model.orders.Zone;

    import starling.events.EventDispatcher;

    public class OrderController extends EventDispatcher
    {
        public static const UPDATE: String = "OrderController.UPDATE";
        public static const DONE: String = "OrderController.DONE";

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
        
        private var _wave: int;
        public function get wave():int
        {
            return _wave;
        }
        
        private var _completed: int;
        public function get completed():int
        {
            return _completed;
        }
        
        public function OrderController()
        {
            _orders = new <Order>[];
            _money = 0;
            _wave = 0;
            _completed = 0;
        }
        
        public function start():void
        {
            nextWave();
        }
        
        public function nextWave():void
        {
            _wave++;
            
            var newOrders: int = 0;
            for (var i:int = 0; i < _orders.length; i++)
            {
                var order: Order = _orders[i];
                if (!order.active && !order.completed && order.wave <= _wave)
                {
                    order.activate();
                    newOrders++;
                }
            }
            
            if (newOrders == 0)
            {
                dispatchEventWith(DONE);
            }
        }
        
        public function addOrder(order: Order):void
        {
            order.departure.active = false;
            order.arrival.active = false;
            _orders.push(order);
            dispatchEventWith(UPDATE);
        }

        public function removeOrder(order: Order):void
        {
            _orders.splice(_orders.indexOf(order), 1);
            dispatchEventWith(UPDATE);
        }

        public function checkOrders(ship: Ship, zone: Zone):void
        {
            var notCompleted: int = 0;
            
            for (var i:int = 0; i < _orders.length; i++)
            {
                var order: Order = _orders[i];
                if (!order.started && order.departure == zone)
                {
                    order.start();
                    ship.order();
                } else if (order.started && order.arrival == zone)
                {
                    _money += order.money;
                    SoundManager.playSound(SoundManager.COINS_LOOP);
                    
                    order.complete();
                    ship.order();
                    _completed++;
                }
                if (order.active && !order.completed)
                {
                    notCompleted++;
                }
            }
            if (notCompleted == 0)
            {
                nextWave();
            }
        }
        
        public function destroy():void
        {
            while (_orders.length > 0)
            {
                var order: Order = _orders.shift();
                order.destroy();
            }
        }
    }
}
