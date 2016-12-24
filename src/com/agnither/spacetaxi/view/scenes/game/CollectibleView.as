/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view.scenes.game
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.Collectible;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;

    public class CollectibleView extends Sprite implements IAnimatable
    {
        private var _collectible: Collectible;

        private var _image: Image;

        private var _time: Number;

        public function CollectibleView(collectible: Collectible)
        {
            super();

            _collectible = collectible;
            _collectible.addEventListener(Collectible.COLLECT, handleCollect);

            _image = new Image(Application.assetsManager.getTexture("misc/loot_box"));
            _image.pivotX = _image.width * 0.5;
            _image.pivotY = _image.height * 0.5;
            addChild(_image);

            x = _collectible.x;
            y = _collectible.y;

            _time = Math.random();

            Starling.juggler.add(this);
        }

        public function advanceTime(time:Number):void
        {
            _time += time;
            rotation = Math.PI * 0.2 * Math.cos(_time * 2);
        }

        private function handleCollect(event: Event):void
        {
            destroy();
        }

        public function destroy():void
        {
            Starling.juggler.remove(this);

            if (_collectible != null)
            {
                _collectible.removeEventListener(Collectible.COLLECT, handleCollect);
                _collectible = null;
            }

            if (_image != null)
            {
                _image.removeFromParent(true);
                _image = null;
            }

            removeFromParent(true);
        }
    }
}
