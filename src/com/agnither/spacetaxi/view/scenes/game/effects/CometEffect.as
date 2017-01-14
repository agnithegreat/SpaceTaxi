/**
 * Created by agnither on 13.01.17.
 */
package com.agnither.spacetaxi.view.scenes.game.effects
{
    import com.agnither.spacetaxi.Application;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.display.Image;

    public class CometEffect extends Image implements IAnimatable
    {
        private var _direction: Number;
        private var _delta: Number;

        public function CometEffect()
        {
            super(Application.assetsManager.getTexture("misc/comet"));

            pivotX = width * 0.5;
            pivotY = height * 0.5;
            scaleX = 0.25;
            scaleY = 0.25;

            _direction = Math.random() * Math.PI * 2;
            rotation = _direction - Math.PI * 0.75;

            alpha = 0;
            _delta = 3;

            Starling.juggler.add(this);
        }

        public function advanceTime(time: Number):void
        {
            x += Math.cos(_direction) * 500 * time;
            y += Math.sin(_direction) * 500 * time;
            alpha += time * _delta;

            if (alpha >= 1)
            {
                _delta = -2;
            } else if (alpha <= 0)
            {
                removeFromParent(true);
            }
        }

        override public function dispose():void
        {
            Starling.juggler.remove(this);

            super.dispose();
        }
    }
}
