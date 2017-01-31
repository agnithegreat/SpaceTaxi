/**
 * Created by agnither on 14.11.16.
 */
package com.holypanda.kosmos.view.scenes.game
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.model.Portal;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;

    public class PortalView extends Sprite implements IAnimatable
    {
        private var _portal: Portal;

        private var _layer1: Image;
        private var _layer2: Image;

        public function PortalView(portal: Portal)
        {
            super();

            _portal = portal;
            
            _layer1 = new MovieClip(Application.assetsManager.getTextures("misc/Portal/portal_bottom"));
            _layer1.pivotX = _layer1.width / 2;
            _layer1.pivotY = _layer1.height / 2;
            addChild(_layer1);

            _layer2 = new MovieClip(Application.assetsManager.getTextures("misc/Portal/portal_over"));
            _layer2.pivotX = _layer2.width / 2;
            _layer2.pivotY = _layer2.height / 2;
            addChild(_layer2);

            var scale: Number = _portal.radius / 20;
            scaleX = scale;
            scaleY = scale;

            x = _portal.x;
            y = _portal.y;

            Starling.juggler.add(this);
        }

        public function advanceTime(time: Number):void
        {
            _layer1.rotation -= time * 0.3;
            _layer2.rotation += time * 0.3;
        }

        override public function dispose():void
        {
            Starling.juggler.remove(this);

            _portal = null;

            _layer1.removeFromParent(true);
            _layer1 = null;

            _layer2.removeFromParent(true);
            _layer2 = null;

            super.dispose();
        }
    }
}
