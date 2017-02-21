/**
 * Created by agnither on 14.11.16.
 */
package com.holypanda.kosmos.model
{
    import com.holypanda.kosmos.utils.GeomUtils;

    import starling.events.Event;

    public class Ship extends DynamicSpaceBody
    {
        public static const ORDER: String = "Ship.ORDER";
        public static const LAUNCH: String = "Ship.LAUNCH";
        public static const COLLIDE: String = "Ship.COLLIDE";
        public static const BOUNCE: String = "Ship.BOUNCE";
        public static const LAND_PREPARE: String = "Ship.LAND_PREPARE";
        public static const LAND: String = "Ship.LAND";
        public static const CRASH: String = "Ship.CRASH";
        
        protected var _rotation: Number;
        public function get rotation():Number
        {
            return _rotation;
        }
        
        protected var _planet: Planet;
        public function get planet():Planet
        {
            return _planet;
        }

        private var _landing: Boolean;

        private var _clone: Boolean;

        public function Ship(radius: int, mass: Number, rotation: Number, clone: Boolean = false)
        {
            super(radius, mass);
            
            _rotation = rotation;
            _maxSpeed = 100;
            
            _clone = clone;

            reset();
        }
        
        override public function reset():void
        {
            super.reset();
            
            _stable = false;
        }

        public function launch(fuel: int = 0):void
        {
            if (_planet != null)
            {
                _planet.removeEventListener(SpaceBody.UPDATE, handlePlanetUpdate);
                _planet = null;
            }
            _stable = false;
            _landing = false;

            dispatchEventWith(LAUNCH);
        }

        override public function accelerate(x: Number, y: Number):void
        {
            super.accelerate(x, y);

            if (x == 0 && y == 0) return;
            
            if (_landing && _planet != null)
            {
                rotateToPlanet(_planet);
            } else {
                _rotation = Math.atan2(_speed.y, _speed.x);
            }
        }

        public function collide(power: int = 0):void
        {
            dispatchEventWith(COLLIDE, false, power);

            crash();
        }

        public function landPrepare(planet: Planet):void
        {
            _planet = planet;
            _landing = true;
            dispatchEventWith(LAND_PREPARE);
        }

        public function land(planet: Planet):void
        {
            _planet = planet;
            _planet.addEventListener(SpaceBody.UPDATE, handlePlanetUpdate);
            
            stop();
            _stable = true;
            dispatchEventWith(LAND);
        }

        override public function multiply(multiplier: Number):void
        {
            super.multiply(multiplier);
            
            if (multiplier > 0)
            {
                dispatchEventWith(BOUNCE);
            }
        }

        override public function crash():void
        {
            super.crash();
            
            stop();
            dispatchEventWith(CRASH);
        }

        public function stop():void
        {
            _speed.x = 0;
            _speed.y = 0;
        }
        
        public function order():void
        {
            dispatchEventWith(ORDER);
        }

        public function repair():void
        {
            _alive = true;
        }
        
        override public function clone():SpaceBody
        {
            var body: Ship = new Ship(_radius, _mass, _rotation, true);
            body.place(_position.x, _position.y);
            body.accelerate(_speed.x, _speed.y);
            return body;
        }

        private function handlePlanetUpdate(event: Event):void
        {
            rotateToPlanet(_planet);
        }

        private function rotateToPlanet(planet: Planet):void
        {
            if (planet != null)
            {
                _rotation = GeomUtils.getAngle(planet.position, _position);
                update();
            }
        }

        override public function destroy():void
        {
            super.destroy();

            _planet = null;
        }
    }
}
