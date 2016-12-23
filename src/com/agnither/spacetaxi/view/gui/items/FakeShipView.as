/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view.gui.items
{
    import dragonBones.starling.StarlingArmatureDisplay;
    import dragonBones.starling.StarlingFactory;

    import starling.display.Sprite;

    public class FakeShipView extends Sprite
    {
        private var _animation: StarlingArmatureDisplay;
        private var _mount: StarlingArmatureDisplay;
        
        public function FakeShipView()
        {
            super();

            _animation = StarlingFactory.factory.buildArmatureDisplay("Ship", "ship");
            _animation.scaleX = 0.35;
            _animation.scaleY = 0.35;
            addChild(_animation);
            _animation.animation.gotoAndStopByFrame("launch");
            _animation.rotation = Math.PI * 0.5;

            _mount = _animation.getChildAt(2) as StarlingArmatureDisplay;
            
            _animation.animation.gotoAndPlayByFrame("launch");
            _mount.animation.gotoAndPlayByFrame("close");
        }

        public function destroy():void
        {
            removeChild(_animation, true);
            _animation = null;

            removeFromParent(true);
        }
    }
}
