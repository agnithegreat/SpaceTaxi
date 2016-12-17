package editor
{
    import flash.display.MovieClip;
    import flash.text.TextField;

    public class Planet extends MovieClip
    {
        protected var _mass: int = 100;
        protected var _bounce: int = 0;
        protected var _skin: String = "_1";
        protected var _type: String = "normal";

        public var massTF: TextField;

        public function Planet():void
        {
        }

        public function get mass():int
        {
            return _mass;
        }
        [Inspectable(type="Number", defaultValue="100", minValue="1")]
        public function set mass(value: int):void
        {
            _mass = value;
            massTF.text = String(_mass);
        }

        public function get bounce():int
        {
            return _bounce;
        }
        [Inspectable(type="Number", defaultValue="0", minValue="0", maxValue="0")]
        public function set bounce(value: int):void
        {
            _bounce = value;
        }

        public function get skin():String
        {
            return _skin;
        }
        [Inspectable(type="List", enumeration="_1,_2,_3,_5,_6,_7,_8,_9,_10,_12", defaultValue="_1")]
        public function set skin(value: String):void
        {
            _skin = value;
            gotoAndStop(_skin);
        }

        public function get type():String
        {
            return _type;
        }
        [Inspectable(type="List", enumeration="normal", defaultValue="normal")]
        public function set type(value: String):void
        {
            _type = value;
        }
    }

}