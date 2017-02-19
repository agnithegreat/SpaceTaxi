/**
 * Created by agnither on 16.11.16.
 */
package com.holypanda.kosmos.controller.game
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.enums.ZoneType;
    import com.holypanda.kosmos.model.Ship;
    import com.holypanda.kosmos.model.orders.Zone;

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
                    useZone(zone, ship);
                }
            }
        }

        private function useZone(zone: Zone, ship: Ship):void
        {
            switch (zone.zone.type)
            {
                case ZoneType.DEPARTURE:
                case ZoneType.ARRIVAL:
                {
                    Application.appController.space.orders.checkOrders(ship, zone);
                    break;
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
