/**
 * Created by agnither on 15.11.16.
 */
package com.holypanda.kosmos.model.orders
{
    import com.holypanda.kosmos.model.Planet;
    import com.holypanda.kosmos.model.Ship;
    import com.holypanda.kosmos.vo.game.ZoneVO;

    import flash.geom.Point;

    import starling.events.EventDispatcher;

    public class Zone extends EventDispatcher
    {
        public static const UPDATE: String = "Zone.UPDATE";
        
        private var _zone: ZoneVO;
        public function get zone():ZoneVO
        {
            return _zone;
        }

        public function get id():int
        {
            return _zone.id;
        }
        
        private var _planet: Planet;
        public function get planet():Planet
        {
            return _planet;
        }
        
        private var _active: Boolean;
        public function get active():Boolean
        {
            return _active;
        }

        private var _completed: Boolean;
        public function get completed():Boolean
        {
            return _completed;
        }
        
        public function Zone(zone: ZoneVO, planet: Planet)
        {
            _zone = zone;
            _planet = planet;
            _zone.size = Math.min(_zone.size, _planet.radius * 0.7);
            _active = false;
            _completed = false;
        }
        
        public function check(ship: Ship):Boolean
        {
            return Point.distance(ship.position, new Point(_zone.position.x, _zone.position.y)) <= _zone.size + ship.radius;
        }

        public function activate():void
        {
            _active = true;
            dispatchEventWith(UPDATE);
        }
        
        public function complete():void
        {
            _active = false;
            _completed = true;
            dispatchEventWith(UPDATE);
        }
        
        public function destroy():void
        {
            _zone = null;
            _planet = null;
        }
    }
}
