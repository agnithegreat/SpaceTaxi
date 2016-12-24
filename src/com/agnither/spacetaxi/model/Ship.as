/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
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

        protected var _fuel: int;
        public function get fuel():int
        {
            return _fuel;
        }
        protected var _fuelMax: int;
        public function get fuelMax():int
        {
            return _fuelMax;
        }

        protected var _durability: int;
        public function get durability():int
        {
            return _durability;
        }
        protected var _durabilityMax: int;
        public function get durabilityMax():int
        {
            return _durabilityMax;
        }

        protected var _capacity: int;
        public function get capacity():int
        {
            return _capacity;
        }
        protected var _capacityMax: int;
        public function get capacityMax():int
        {
            return _capacityMax;
        }
        
        protected var _planet: Planet;
        public function get planet():Planet
        {
            return _planet;
        }

        private var _landing: Boolean;

        public function Ship(radius: int, mass: Number, rotation: Number)
        {
            super(radius, mass);
            
            _rotation = rotation;

            reset();
        }
        
        override public function reset():void
        {
            super.reset();
            
            _landed = false;
            _crashed = false;

            // TODO: FUEL - setup
            _fuelMax = 9;
            _fuel = _fuelMax;

            // TODO: DURABILITY - setup
            _durabilityMax = 9;
            _durability = _durabilityMax;
            
            // TODO: CAPACITY - setup
            _capacityMax = 5;
            _capacity = _capacityMax;
        }

        public function launch(fuel: int = 0):void
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
            _landing = false;

            if (fuel > 0)
            {
                _fuel -= fuel;
                // TODO: LOW FUEL
                // TODO: NO FUEL
            }

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
            _landed = true;
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

        public function crash():void
        {
            _durability = 0;
            stop();
            _crashed = true;
            dispatchEventWith(CRASH);
        }

        public function stop():void
        {
            _speed.x = 0;
            _speed.y = 0;
        }
        
        public function order(add: Boolean):void
        {
            _capacity += add ? -1 : 1;
            dispatchEventWith(ORDER);
        }

        public function fuelUp(amount: Number):void
        {
            _fuel = Math.min(_fuel + amount, _fuelMax);
        }

        public function repair():void
        {

        }
        
        override public function clone():SpaceBody
        {
            var body: Ship = new Ship(_radius, _mass, _rotation);
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
                _rotation = Math.atan2(y - planet.y, x - planet.x);
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
