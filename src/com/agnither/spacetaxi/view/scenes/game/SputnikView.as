/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view.scenes.game
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.SpaceBody;
    import com.agnither.spacetaxi.utils.LevelParser;

    import starling.animation.IAnimatable;
    import starling.core.Starling;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.extensions.TextureMaskStyle;

    public class SputnikView extends Sprite implements IAnimatable
    {
        private var _planet: Planet;

        private var _baseScale: Number;

        private var _upperContainer: Sprite;
        private var _lowerContainer: Sprite;

        private var _shadow: Image;
        private var _shadowMask: Image;
        private var _sputnik: Image;

        private var _angle: Number;
        private var _progress: Number;

        public function SputnikView(planet: Planet, upperContainer: Sprite, lowerContainer: Sprite)
        {
            super();

            _upperContainer = upperContainer;
            _lowerContainer = lowerContainer;
            
            _planet = planet;
            _planet.addEventListener(SpaceBody.UPDATE, handleUpdate);
            _baseScale = _planet.radius / 428 * 2;

            handleUpdate(null);

            _shadowMask = new Image(Application.assetsManager.getTexture("planets/" + _planet.skin));
            _shadowMask.pivotX = _shadowMask.width * 0.5;
            _shadowMask.pivotY = _shadowMask.height * 0.5;
            _shadowMask.scaleX = _baseScale;
            _shadowMask.scaleY = _baseScale;
            _shadowMask.style = new TextureMaskStyle();
            addChild(_shadowMask);

            _shadow = new Image(Application.assetsManager.getTexture("misc/Sputnik/shadow"));
            _shadow.pivotX = _shadow.width * 0.5;
            _shadow.pivotY = _shadow.height * 0.5;
            _shadow.mask = _shadowMask;
            addChild(_shadow);

            _sputnik = new Image(Application.assetsManager.getTexture("misc/Sputnik/01"));
            _sputnik.pivotX = _sputnik.width * 0.5;
            _sputnik.pivotY = _sputnik.height * 0.5;
            _sputnik.color = LevelParser.colors[_planet.skin];
            addChild(_sputnik);

            _angle = Math.random() * Math.PI * 2;
            _progress = Math.random();
            updateSputnik();

            Starling.juggler.add(this);
        }

        private function handleUpdate(event: Event):void
        {
            x = _planet.x;
            y = _planet.y;
            
            scaleX = (1 + Math.cos(_planet.time) * _planet.scale);
            scaleY = (1 + Math.cos(_planet.time + Math.PI) * _planet.scale);
        }

        private function updateSputnik():void
        {
            _progress = _progress % 1;

            var delta: Number = Math.abs(_progress - 0.5);

            if (delta < 0.25)
            {
                _shadow.visible = true;
                _upperContainer.addChildAt(this, 0);
            } else {
                _shadow.visible = false;
                _lowerContainer.addChildAt(this, 0);
            }

            var scale: Number = _baseScale * (0.5 - delta * 0.4);
            _shadow.scaleX = scale * 1.2;
            _shadow.scaleY = scale * 1.2;
            _sputnik.scaleX = scale;
            _sputnik.scaleY = scale;

            var amplitude: Number = _planet.radius * 1.3;
            _shadow.x = amplitude * Math.cos(_angle) * Math.sin(_progress * Math.PI * 2) * 0.9;
            _shadow.y = amplitude * Math.sin(_angle) * Math.sin(_progress * Math.PI * 2) * 0.9;
            _sputnik.x = amplitude * Math.cos(_angle) * Math.sin(_progress * Math.PI * 2);
            _sputnik.y = amplitude * Math.sin(_angle) * Math.sin(_progress * Math.PI * 2);
        }

        public function advanceTime(time:Number):void
        {
            _progress += time * Math.sqrt(_planet.mass / _planet.radius) * 0.05;
            updateSputnik();
        }

        override public function dispose():void
        {
            Starling.juggler.remove(this);

            _planet.removeEventListener(SpaceBody.UPDATE, handleUpdate);
            _planet = null;

            _upperContainer = null;
            _lowerContainer = null;

            _shadowMask.removeFromParent(true);
            _shadowMask = null;

            _shadow.removeFromParent(true);
            _shadow = null;

            _sputnik.removeFromParent(true);
            _sputnik = null;

            super.dispose();
        }
    }
}
