/**
 * Created by agnither on 14.11.16.
 */
package com.holypanda.kosmos.model
{
    import com.holypanda.kosmos.vo.game.CollectibleVO;

    public class Collectible extends SpaceBody
    {
        public static const COLLECT: String = "SpaceBody.COLLECT";
        
        private var _collectible: CollectibleVO;
        public function get type():String
        {
            return _collectible.type;
        }
        
        public function Collectible(collectible: CollectibleVO)
        {
            _collectible = collectible;
            
//            super(_collectible.size, 1);
            super(40, 1);
        }
        
        public function collect():void
        {
            dispatchEventWith(COLLECT);
        }

        override public function clone():SpaceBody
        {
            var body: Collectible = new Collectible(_collectible);
            body.place(_position.x, _position.y);
            return body;
        }

        override public function destroy():void
        {
            super.destroy();

            _collectible = null;
        }
    }
}
