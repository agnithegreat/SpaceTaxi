/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.Ship;
    import com.agnither.spacetaxi.model.SpaceBody;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;

    public class ShipView extends Sprite
    {
        private var _ship: Ship;

        private var _image: Image;
        
        public function ShipView(ship: Ship)
        {
            super();
            
            _ship = ship;
            _ship.addEventListener(SpaceBody.UPDATE, handleUpdate);
            _ship.addEventListener(Ship.COLLIDE, handleCollide);
            _ship.addEventListener(Ship.LAND, handleLand);
            _ship.addEventListener(Ship.CRASH, handleCrash);

//            _image = new Image(Application.assetsManager.getTexture("Special/taxi"));
            _image = new Image(Application.assetsManager.getTexture("ship_body_close"));
            _image.pivotX = _image.width / 2;
            _image.pivotY = _image.height / 2;
            _image.scaleX = _ship.radius / 400 * 2;
            _image.scaleY = _ship.radius / 400 * 2;
            addChild(_image);

            handleUpdate(null);
        }

        private function handleUpdate(event: Event):void
        {
            x = _ship.x + _ship.offset.x;
            y = _ship.y + _ship.offset.y;

            _image.rotation = _ship.rotation - Math.PI/2;
        }

        private function handleCollide(event: Event):void
        {

        }

        private function handleLand(event: Event):void
        {

        }

        private function handleCrash(event: Event):void
        {
            destroy();
        }

        private function destroy():void
        {
            _ship.removeEventListener(SpaceBody.UPDATE, handleUpdate);
            _ship.removeEventListener(Ship.COLLIDE, handleCollide);
            _ship.removeEventListener(Ship.LAND, handleLand);
            _ship.removeEventListener(Ship.CRASH, handleCrash);
            _ship = null;

            removeChild(_image, true);
            _image = null;

            removeFromParent(true);
        }
    }
}
