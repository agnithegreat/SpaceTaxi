package editor
{
    import flash.display.MovieClip;
    import flash.text.TextField;

    public class Arrival extends MovieClip
    {
        protected var _id: int;
        protected var _size: int;

        public var idTF: TextField;

        public function Arrival():void
        {
        }

        public function get id():int
        {
            return _id;
        }
        [Inspectable(type="Number", defaultValue="0")]
        public function set id(value: int):void
        {
            _id = value;
            idTF.text = String(_id);
        }

        public function get size():int
        {
            return _size;
        }
        [Inspectable(type="Number", defaultValue="0")]
        public function set size(value: int):void
        {
            _size = value;
        }
    }

}