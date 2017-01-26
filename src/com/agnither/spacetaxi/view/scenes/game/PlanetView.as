/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view.scenes.game
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.SpaceBody;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;

    public class PlanetView extends Sprite
    {
        private var _planet: Planet;

        private var _baseScale: Number;

        private var _image: Image;

        public function PlanetView(planet: Planet)
        {
            super();

            _planet = planet;
            _planet.addEventListener(SpaceBody.UPDATE, handleUpdate);

            _baseScale = _planet.radius / 400 * 2;

            _image = new Image(Application.assetsManager.getTexture("planets/" + _planet.skin));
            _image.pivotX = _image.width * 0.5;
            _image.pivotY = _image.height * 0.5;
            _image.scaleX = _baseScale;
            _image.scaleY = _baseScale;
            addChild(_image);

            handleUpdate(null);
        }

        private function handleUpdate(event: Event):void
        {
            x = _planet.x;
            y = _planet.y;
            
            scaleX = (1 + Math.cos(_planet.time) * _planet.scale);
            scaleY = (1 + Math.cos(_planet.time + Math.PI) * _planet.scale);
        }

        override public function dispose():void
        {
            _planet.removeEventListener(SpaceBody.UPDATE, handleUpdate);
            _planet = null;

            _image.removeFromParent(true);
            _image = null;

            super.dispose();
        }
    }
}
