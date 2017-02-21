/**
 * Created by agnither on 16.11.16.
 */
package com.holypanda.kosmos.controller.game
{
    import com.holypanda.kosmos.model.Ship;
    import com.holypanda.kosmos.model.orders.Zone;

    import starling.events.EventDispatcher;

    public class ZoneController extends EventDispatcher
    {
        public static const UPDATE: String = "ZoneController.UPDATE";
        public static const DONE: String = "ZoneController.DONE";
        
        private var _zones: Vector.<Zone>;
        public function get zones():Vector.<Zone>
        {
            return _zones;
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
        
        public function ZoneController()
        {
            _zones = new <Zone>[];
            _wave = 0;
            _completed = 0;
        }
        
        public function addZone(zone: Zone):void
        {
            _zones.push(zone);
        }

        public function checkZones(ship: Ship):Zone
        {
            for (var i:int = 0; i < _zones.length; i++)
            {
                var zone: Zone = _zones[i];
                if (zone.active && zone.check(ship))
                {
                    zone.complete();
                    nextWave();
                    return zone;
                }
            }
            return null;
        }

        public function start():void
        {
            nextWave();
        }

        public function nextWave():void
        {
            _wave++;

            var newZones: int = 0;
            for (var i:int = 0; i < _zones.length; i++)
            {
                var zone: Zone = _zones[i];
                if (!zone.active && !zone.completed && zone.id <= _wave)
                {
                    zone.activate();
                    newZones++;
                }
            }

            if (newZones == 0)
            {
                dispatchEventWith(DONE);
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
