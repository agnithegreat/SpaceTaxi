/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view.scenes.game
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.orders.Zone;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;

    public class OrderView extends Sprite implements IAnimatable
    {
        private var _zone: Zone;

        private var _image: Image;
        
        private var _time: Number;

        public function OrderView(zone: Zone, arrival: Boolean)
        {
            super();

            _zone = zone;
            _zone.addEventListener(Zone.UPDATE, handleUpdate);
            handleUpdate(null);

            _image = new Image(Application.assetsManager.getTexture("coin"));
            _image.pivotX = _image.width * 0.5;
            _image.pivotY = _image.height * 0.5;
            _image.width = _zone.zone.size * 2;
            _image.height = _zone.zone.size * 2;
            addChild(_image);

            x = _zone.zone.x;
            y = _zone.zone.y;
            alpha = arrival ? 1 : 0.5;

            _time = 0;
            Starling.juggler.add(this);
        }

        private function handleUpdate(event: Event):void
        {
            visible = _zone.order != null && _zone.order.active;
        }

        public function advanceTime(time:Number):void
        {
            _time += time;
            
            scaleX = 1 + 0.1 * Math.cos(_time * 4);
            scaleY = scaleX;
        }
    }
}
