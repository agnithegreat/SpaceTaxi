/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.managers.sound.SoundManager;

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
        
        protected var _planet: Planet;
        public function get planet():Planet
        {
            return _planet;
        }

        private var _landing: Boolean;

        private var _signal: String;
        
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

            // TODO: FUEL - setup
            _fuelMax = 3;
            _fuel = _fuelMax;

            // TODO: DURABILITY - setup
            _durabilityMax = 1;
            _durability = _durabilityMax;
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
            _stable = false;
            _landing = false;

            _fuel -= fuel;

            if (!_clone && _fuel < 2 && _signal == null)
            {
                _signal = SoundManager.playSound(SoundManager.LOW_FUEL, true);
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

            _durability -= power;
            if (_durability <= 0)
            {
                crash();
            }

            if (!_clone && _durability < 2 && _signal == null)
            {
                _signal = SoundManager.playSound(SoundManager.LOW_FUEL, true);
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
            
            _durability = 0;
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

        public function fuelUp(amount: Number):void
        {
            SoundManager.playSound(SoundManager.FUEL_LOAD);
            _fuel = Math.min(_fuel + amount, _fuelMax);

            if (_signal != null)
            {
                SoundManager.stopSound(_signal);
                _signal = null;
            }
        }

        public function repair():void
        {
            if (_signal != null)
            {
                SoundManager.stopSound(_signal);
                _signal = null;
            }
        }
        
        public function mute():void
        {
            if (_signal != null)
            {
                SoundManager.stopSound(_signal);
                _signal = null;
            }
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
                _rotation = Math.atan2(y - planet.y, x - planet.x);
                update();
            }
        }

        override public function destroy():void
        {
            super.destroy();

            if (_signal != null)
            {
                SoundManager.stopSound(_signal);
                _signal = null;
            }

            _planet = null;
        }
    }
}
