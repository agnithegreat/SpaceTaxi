/**
 * Created by agnither on 14.11.16.
 */
package com.holypanda.kosmos.view.scenes.game
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.model.Planet;
    import com.holypanda.kosmos.model.SpaceBody;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;

    public class BlackHoleView extends Sprite implements IAnimatable
    {
        private var _planet: Planet;
        
        private var _layer1: Image;
        private var _layer2: Image;
//        private var _skull: Image;
        private var _baseScale: Number;

        public function BlackHoleView(planet: Planet)
        {
            super();
            
            _planet = planet;
            _planet.addEventListener(SpaceBody.UPDATE, handleUpdate);
            handleUpdate(null);

            _baseScale = _planet.radius / 190 * 2;

            _layer1 = new MovieClip(Application.assetsManager.getTextures("planets/blackhole/circle_2"));
            _layer1.pivotX = _layer1.width / 2;
            _layer1.pivotY = _layer1.height / 2;
            _layer1.scaleX = _baseScale;
            _layer1.scaleY = _baseScale;
            addChild(_layer1);

            _layer2 = new MovieClip(Application.assetsManager.getTextures("planets/blackhole/circle_1"));
            _layer2.pivotX = _layer2.width / 2;
            _layer2.pivotY = _layer2.height / 2;
            _layer2.scaleX = _baseScale;
            _layer2.scaleY = _baseScale;
            addChild(_layer2);

//            _skull = new MovieClip(Application.assetsManager.getTextures("blackhole/skull"));
//            _skull.pivotX = _skull.width / 2;
//            _skull.pivotY = _skull.height / 2;
//            _skull.scaleX = _baseScale;
//            _skull.scaleY = _baseScale;
//            addChild(_skull);

            Starling.juggler.add(this);
        }

        private function handleUpdate(event: Event):void
        {
            x = _planet.x;
            y = _planet.y;
            
            scaleX = (1 + Math.cos(_planet.time) * _planet.scale);
            scaleY = (1 + Math.sin(_planet.time) * _planet.scale);
        }


        public function advanceTime(time: Number):void
        {
            _layer1.rotation += time * 0.3;
            _layer2.rotation -= time * 0.3;
        }
    }
}
