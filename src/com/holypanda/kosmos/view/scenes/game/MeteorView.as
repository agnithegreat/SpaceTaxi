/**
 * Created by agnither on 14.11.16.
 */
package com.holypanda.kosmos.view.scenes.game
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.model.Meteor;
    import com.holypanda.kosmos.model.SpaceBody;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;

    public class MeteorView extends Sprite implements IAnimatable
    {
        public static var LIST: Array = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10"];
        
        private var _meteor: Meteor;

        private var _image: Image;

        private var _rotationSpeed: Number;

        public function MeteorView(meteor: Meteor)
        {
            super();
            
            _meteor = meteor;
            _meteor.addEventListener(SpaceBody.UPDATE, handleUpdate);

            var rand: int = Math.random() * LIST.length;
            _image = new Image(Application.assetsManager.getTexture("misc/Meteor/" + LIST[rand]));
            _image.pivotX = _image.width * 0.5;
            _image.pivotY = _image.height * 0.5;
            _image.scaleX = 0.5;
            _image.scaleY = 0.5;
            addChild(_image);

            _rotationSpeed = 0.2 + Math.random() * 0.2;

            handleUpdate(null);
            
            Starling.juggler.add(this);
        }

        public function advanceTime(time:Number):void
        {
            rotation += time * _rotationSpeed;

            if (!_meteor.alive)
            {
                destroy();
            }
        }

        private function handleUpdate(event: Event):void
        {
            x = _meteor.x;
            y = _meteor.y;
        }

        private function clear():void
        {
            Starling.juggler.remove(this);

            if (_meteor != null)
            {
                _meteor.removeEventListener(SpaceBody.UPDATE, handleUpdate);
                _meteor = null;
            }
        }

        public function destroy():void
        {
            clear();

            removeChild(_image, true);
            _image = null;

            removeFromParent(true);
        }
    }
}
