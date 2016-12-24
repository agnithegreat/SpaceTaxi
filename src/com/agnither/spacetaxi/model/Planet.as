/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.model
{
    import com.agnither.spacetaxi.enums.PlanetType;

    public class Planet extends SpaceBody
    {
        private var _bounce: int;
        public function get bounce():int
        {
            return _bounce;
        }
        
        private var _type: PlanetType;
        public function get type():PlanetType
        {
            return _type;
        }

        private var _skin: String;
        public function get skin():String
        {
            return _skin;
        }

        private var _time: Number;
        private var _timeMultiplier: Number;
        public function get time():Number
        {
            return _time * _timeMultiplier;
        }
        
        private var _scale: Number = 0.03;
        public function get scale():Number
        {
            return _scale;
        }

        public function Planet(radius: int, mass: int, bounce: int, type: PlanetType, skin: String)
        {
            super(radius, mass);

            _bounce = bounce;
            _type = type;
            _skin = skin;

            _time = Math.random();
            _timeMultiplier = 1 + (Math.random()-0.5) * 0.1;
        }

        override public function advanceTime(delta: Number):void
        {
            super.advanceTime(delta);
            
            _time += delta;
            dispatchEventWith(UPDATE);
        }

        override public function clone():SpaceBody
        {
            var body: Planet = new Planet(_radius, _mass, _bounce, _type, _skin);
            body.place(_position.x, _position.y);
            return body;
        }
        
        override public function destroy():void
        {
            super.destroy();
            
            _type = null;
        }
    }
}
