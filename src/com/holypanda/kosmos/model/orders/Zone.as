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

        private var _id: int;
        public function get id():int
        {
            return _id;
        }
        
        private var _zone: ZoneVO;
        public function get zone():ZoneVO
        {
            return _zone;
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
        
        public function Zone(id: int, zone: ZoneVO, planet: Planet)
        {
            _id = id;
            _zone = zone;
            _planet = planet;
            _active = true;
        }
        
        public function check(ship: Ship):Boolean
        {
            return Point.distance(ship.position, new Point(_zone.position.x, _zone.position.y)) <= _zone.size + ship.radius;
        }
        
        public function set active(value: Boolean):void
        {
            _active = value;
            dispatchEventWith(UPDATE);
        }
        
        public function destroy():void
        {
            _zone = null;
            _planet = null;
        }
    }
}
