/**
 * Created by agnither on 14.11.16.
 */
package com.holypanda.kosmos.view.gui.items
{
    import dragonBones.starling.StarlingArmatureDisplay;
    import dragonBones.starling.StarlingFactory;

    import starling.display.Sprite;

    public class FakeShipView extends Sprite
    {
        private var _animation: StarlingArmatureDisplay;
        private var _mount: StarlingArmatureDisplay;
        
        public function FakeShipView(scale: Number, rotation: Number, launch: Boolean)
        {
            super();

            _animation = StarlingFactory.factory.buildArmatureDisplay("Ship", "ship");
            _animation.scaleX = scale;
            _animation.scaleY = scale;
            addChild(_animation);
            _animation.animation.gotoAndStopByFrame("launch");
            _animation.rotation = rotation;

            _mount = _animation.getChildAt(1) as StarlingArmatureDisplay;

            if (launch)
            {
                _animation.animation.gotoAndPlayByFrame("launch");
                _mount.animation.gotoAndStopByFrame("open");
            } else {
                _mount.animation.gotoAndStopByFrame("close");
            }
        }

        public function destroy():void
        {
            removeChild(_animation, true);
            _animation = null;

            removeFromParent(true);
        }
    }
}
