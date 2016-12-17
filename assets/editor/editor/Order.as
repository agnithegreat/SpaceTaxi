package editor
{
    import flash.display.MovieClip;
    import flash.text.TextField;

    public class Order extends MovieClip
    {
        protected var _id: int;
        protected var _cost: int;
        
        public var idTF: TextField;
        public var costTF: TextField;

        public function Order():void
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

        public function get cost():int
        {
            return _cost;
        }
        [Inspectable(type="Number", defaultValue="0")]
        public function set cost(value: int):void
        {
            _cost = value;
            costTF.text = String(_cost);
        }
    }

}