/**
 * Created by agnither on 16.11.16.
 */
package com.agnither.spacetaxi.controller.game
{
    import com.agnither.spacetaxi.model.Order;
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.Ship;
    import com.agnither.spacetaxi.model.orders.Zone;

    import starling.core.Starling;

    import starling.events.EventDispatcher;

    public class OrderController extends EventDispatcher
    {
        public static const UPDATE: String = "OrderController.UPDATE";
        
        private var _orders: Vector.<Order>;
        public function get orders():Vector.<Order>
        {
            return _orders;
        }
        
        public function OrderController()
        {
            _orders = new <Order>[];
        }
        
        public function start(delay: Number = 0):void
        {
            Starling.juggler.delayCall(activateOrder, delay);
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

        public function checkOrder(planet: Planet, ship: Ship):void
        {
            var zone: Zone = planet.getZoneByShip(ship);
            var order: Order = zone.order;
            if (order != null)
            {
                if (!ship.hasOrder(order) && order.departure == zone)
                {
                    ship.addOrder(order);
                    zone.setOrder(null);
                } else if (ship.hasOrder(order) && order.arrival == zone)
                {
                    ship.removeOrder(order);
                    zone.setOrder(null);
                    removeOrder(order);
                }
            }
        }

        public function hasOrder(planet: Planet, ship: Ship):Boolean
        {
            var zone: Zone = planet.getZoneByShip(ship);
            return zone.order != null && (zone.order.departure == zone || zone.order.arrival == zone);
        }
        
        private function activateOrder():void
        {
            if (_orders.length > 0)
            {
                _orders[0].activate();
            }
        }
    }
}
