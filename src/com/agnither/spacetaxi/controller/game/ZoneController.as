/**
 * Created by agnither on 16.11.16.
 */
package com.agnither.spacetaxi.controller.game
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.Ship;
    import com.agnither.spacetaxi.model.orders.Zone;

    import starling.events.EventDispatcher;

    public class ZoneController extends EventDispatcher
    {
        private var _zones: Vector.<Zone>;
        public function get zones():Vector.<Zone>
        {
            return _zones;
        }
        
        public function ZoneController()
        {
            _zones = new <Zone>[];
        }
        
        public function addZone(zone: Zone):void
        {
            _zones.push(zone);
        }

        public function checkZones(ship: Ship):void
        {
            for (var i:int = 0; i < _zones.length; i++)
            {
                var zone: Zone = _zones[i];
                if (zone.active && zone.check(ship))
                {
                    Application.appController.space.orders.checkOrders(ship, zone);
                }
            }
        }
        
        public function destroy():void
        {
            while (_zones.length > 0)
            {
                var zone: Zone = _zones.shift();
                zone.destroy();
            }
        }
    }
}
