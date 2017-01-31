/**
 * Created by agnither on 14.01.17.
 */
package com.holypanda.kosmos.utils
{
    import com.holypanda.kosmos.model.Ship;
    import com.holypanda.kosmos.model.Space;
    import com.holypanda.kosmos.model.orders.Zone;

    import flash.geom.Point;
    import flash.utils.Dictionary;

    import starling.core.Starling;

    public class ShipAI
    {
        private static const angleStep: Number = 0.05;
        private static const powerStep: Number = 0.1;

        private static var dict: Dictionary = new Dictionary();
        public static function create(space: Space, ship: Ship):void
        {
            dict[ship] = new ShipAI(space, ship);
        }

        private var _space: Space;

        private var _ship: Ship;

        private var _target: Zone;

        private var _busy: Boolean;
        private var _busyId: int;
        private var _reset: Boolean;

        private var _baseAngle: Number;
        private var _angle: Number;
        private var _power: Number;

        private var _angleMod: Number;
        private var _sign: Number;

        public function ShipAI(space: Space, ship: Ship)
        {
            _space = space;
            _ship = ship;
        }

        public function destroy():void
        {
            Starling.juggler.removeByID(_busyId);

            _space = null;
            _ship = null;
            _target = null;
        }

        public function compute():void
        {
            if (_busy) return;

            if (_target == null || _target.active == false)
            {
                var filter: Array = [];
                if (_ship.fuel < 2)
                {
                    filter.push("fuel");
                } else {
                    filter.push("departure");
                    filter.push("arrival");
                }
                _target = findNearestTarget(_ship.position, filter);
            }
            if (_target != null)
            {
                findPath();
            }
        }

        public function cancel():void
        {
            _busy = false;
            Starling.juggler.removeByID(_busyId);
        }

        private function findPath():void
        {
            _baseAngle = Math.atan2(_ship.y - _ship.planet.y, _ship.x - _ship.planet.x);
            var angle2: Number = Math.atan2(_target.zone.position.y - _ship.y, _target.zone.position.x - _ship.x);
            var delta: Number = GeomUtils.getAngleDelta(_baseAngle, angle2);
            _angle = Math.abs(delta) < Math.PI * 0.5 ? _baseAngle + delta * 0.5 : angle2;

            _angleMod = 0;
            _sign = -1;

            _power = 0.5;

            _busy = true;
            _reset = true;
            _busyId = Starling.juggler.repeatCall(analyzePath, 0);
        }

        private function analyzePath():void
        {
            if (_reset)
            {
                _reset = false;

                _space.setPullPoint(angle, _power, true, true);
            }

            if (_space.phantom != null && _target != null)
            {
                var fast: Boolean;
                if (_space.phantom.alive)
                {
                    if (_space.phantom.stable)
                    {
                        if (Point.distance(_space.phantom.position, _target.zone.position) <= _target.zone.size)
                        {
                            cancel();

                            _target = null;

                            _space.launch();
                        } else {
                            _reset = true;
                        }
                    } else if (_space.trajectoryTime > 100)
                    {
                        fast = true;
                        _reset = true;
                    }
                } else {
                    fast = true;
                    _reset = true;
                }

                if (_reset)
                {
                    if (_power < 3)
                    {
                        _power += fast ? powerStep * 5 : powerStep;
                    } else {
                        _power = 0.5;

                        do
                        {
                            _sign *= -1;
                            if (_sign == -1)
                            {
                                _angleMod += angleStep;
                            }
                        }
                        while (Math.abs(GeomUtils.getAngleDelta(angle, _baseAngle)) > Math.PI * 0.5);
                    }
                }
            }
        }
        
        private function get angle():Number
        {
            return _angle + _sign * _angleMod * Math.PI;
        }

        private function findNearestTarget(position: Point, filter: Array):Zone
        {
            var nearest: Zone = null;
            var nearestDistance: Number = 0;

            for (var j: int = 0; j < _space.zones.zones.length; j++)
            {
                var zone:Zone = _space.zones.zones[j];
                if (filter.indexOf(zone.zone.type) >= 0)
                {
                    if (zone.active)
                    {
                        var distance:Number = Point.distance(position, zone.zone.position);
                        if (nearest == null || nearestDistance > distance)
                        {
                            nearest = zone;
                            nearestDistance = distance;
                        }
                    }
                }
            }
            if (nearest != null)
            {
                return nearest;
            }
            return null;
        }
    }
}
