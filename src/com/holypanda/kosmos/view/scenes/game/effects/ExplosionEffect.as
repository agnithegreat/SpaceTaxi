/**
 * Created by agnither on 21.11.16.
 */
package com.holypanda.kosmos.view.scenes.game.effects
{
    import dragonBones.events.EventObject;
    import dragonBones.starling.StarlingArmatureDisplay;
    import dragonBones.starling.StarlingFactory;

    import starling.display.Sprite;
    import starling.events.Event;

    public class ExplosionEffect extends Sprite
    {
        private var _animation: StarlingArmatureDisplay;
        
        public function ExplosionEffect()
        {
            super();

            _animation = StarlingFactory.factory.buildArmatureDisplay("Explosion", "ship");
            _animation.addEventListener(EventObject.COMPLETE, handleComplete);
            _animation.scaleX = 0.25;
            _animation.scaleY = 0.25;
            addChild(_animation);

            _animation.armature.animation.play();
        }

        private function handleComplete(event: Event):void
        {
            destroy();
        }

        private function destroy():void
        {
            removeChild(_animation, true);
            _animation = null;

            removeFromParent(true);
        }
    }
}
