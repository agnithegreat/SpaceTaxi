/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.model.orders.Zone;

    import starling.events.Event;

    public class Planet extends SpaceBody
    {
        public static const ORDER: String = "Planet.ORDER";
        
        private var _zones: Vector.<Zone>;
        public function getZone(id: int = -1):Zone
        {
            id = id >= 0 ? id : _zones.length * Math.random();
            return _zones[id];
        }

        public function Planet(radius: int, mass: Number)
        {
            super(radius, mass);

            _zones = new <Zone>[];

//            var length: Number = 2 * Math.PI * radius;
//            var amount: int = length / Space.PLANET_ZONE_SIZE;
            const amount: int = 16;
            const size: Number = 2 * Math.PI / amount;
            for (var i:int = 0; i < amount; i++)
            {
                var zone: Zone = new Zone(this, i * size, size);
                zone.addEventListener(Zone.UPDATE, handleOrder);
                _zones.push(zone);
            }
        }

        public function getZoneByShip(ship: Ship):Zone
        {
            var angle: Number = Math.atan2(ship.position.y - y, ship.position.x - x);
            var zoneId: int = Math.round(angle / (Math.PI * 2) * _zones.length);
            zoneId += zoneId < 0 ? _zones.length : (zoneId >= _zones.length ? -_zones.length : 0);
            return _zones[zoneId];
        }

        override public function clone():SpaceBody
        {
            var body: Planet = new Planet(_radius, _mass);
            body.place(_position.x, _position.y);
            return body;
        }

        private function handleOrder(event: Event):void
        {
            dispatchEventWith(ORDER, false, event.currentTarget);
        }
    }
}
