/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.utils.GeomUtils;

    import starling.events.Event;

    public class Ship extends DynamicSpaceBody
    {
        public static const ORDER: String = "Ship.ORDER";
        public static const LAUNCH: String = "Ship.LAUNCH";
        public static const COLLIDE: String = "Ship.COLLIDE";
        public static const LAND: String = "Ship.LAND";
        public static const CRASH: String = "Ship.CRASH";
        
        protected var _rotation: Number;
        public function get rotation():Number
        {
            return _rotation;
        }
        
        protected var _landed: Boolean;
        public function get landed():Boolean
        {
            return _landed;
        }
        
        protected var _crashed: Boolean;
        public function get crashed():Boolean
        {
            return _crashed;
        }

        protected var _fuel: Number;
        public function get fuel():Number
        {
            return _fuel;
        }

        protected var _durability: Number;
        public function get durability():Number
        {
            return _durability;
        }
        
        protected var _planet: Planet;
        public function get planet():Planet
        {
            return _planet;
        }

        public function Ship(radius: int, mass: Number)
        {
            super(radius, mass);

            reset();
        }
        
        override public function reset():void
        {
            super.reset();
            
            _rotation = 0;
            
            _landed = false;
            _crashed = false;

            // TODO: FUEL - setup
            _fuel = 100;

            // TODO: DURABILITY - setup
            _durability = 100;
        }

        public function launch(fuel: Number = 0):void
        {
            if (_fuel < fuel) {
                throw new Error("no fuel");
            }

            if (_planet != null)
            {
                _planet.removeEventListener(SpaceBody.UPDATE, handlePlanetUpdate);
                _planet = null;
            }
            _landed = false;

            if (fuel > 0)
            {
                _fuel -= fuel;
                // TODO: LOW FUEL
                // TODO: NO FUEL
            }

            dispatchEventWith(LAUNCH);
        }

        public function collide(power: Number = 0):void
        {
            dispatchEventWith(COLLIDE);

            if (power > 0)
            {
                _durability -= power;
                // TODO: LOW DURABILITY
                if (_durability <= 0)
                {
                    crash();
                }
            }
        }

        override public function accelerate(x: Number, y: Number):void
        {
            super.accelerate(x, y);

            _rotation = Math.atan2(y, x);
            dispatchEventWith(UPDATE);
        }
        
        public function land(planet: Planet):void
        {
            _planet = planet;
            _planet.addEventListener(SpaceBody.UPDATE, handlePlanetUpdate);
            
            stop();
            _landed = true;
            dispatchEventWith(LAND);
        }

        public function crash():void
        {
            // TODO: EXPLOSION
            stop();
            _crashed = true;
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
        
        override public function clone():SpaceBody
        {
            var body: Ship = new Ship(_radius, _mass);
            body.place(_position.x, _position.y);
            body.accelerate(_speed.x, _speed.y);
            return body;
        }

        private function handlePlanetUpdate(event: Event):void
        {
            var angle: Number = Math.PI + Math.atan2(y - _planet.y, x - _planet.x);
            var angleDelta: Number = GeomUtils.getAngleDelta(_rotation, angle);
            _rotation += angleDelta * 0.2;
            update();
        }
    }
}
