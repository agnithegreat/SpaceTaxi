/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view
{
    import com.agnither.spacetaxi.model.Ship;
    import com.agnither.spacetaxi.model.SpaceBody;

    import dragonBones.starling.StarlingArmatureDisplay;
    import dragonBones.starling.StarlingFactory;

    import starling.display.Sprite;
    import starling.events.Event;

    public class ShipView extends Sprite
    {
        private var _ship: Ship;

        private var _animation: StarlingArmatureDisplay;
        
        public function ShipView(ship: Ship)
        {
            super();
            
            _ship = ship;
            _ship.addEventListener(SpaceBody.UPDATE, handleUpdate);
            _ship.addEventListener(Ship.ORDER, handleOrder);
            _ship.addEventListener(Ship.LAUNCH, handleLaunch);
            _ship.addEventListener(Ship.COLLIDE, handleCollide);
            _ship.addEventListener(Ship.LAND, handleLand);
            _ship.addEventListener(Ship.CRASH, handleCrash);

            _animation = StarlingFactory.factory.buildArmatureDisplay("Ship", "ship");
//            _animation.addEventListener(EventObject.START, _animationHandler);
//            _animation.addEventListener(EventObject.LOOP_COMPLETE, _animationHandler);
//            _animation.addEventListener(EventObject.COMPLETE, _animationHandler);
//            _animation.addEventListener(EventObject.FRAME_EVENT, _frameEventHandler);
            _animation.scaleX = _ship.radius / 400 * 2;
            _animation.scaleY = _ship.radius / 400 * 2;
            addChild(_animation);

            handleUpdate(null);
        }

        private function handleUpdate(event: Event):void
        {
            x = _ship.x + _ship.offset.x;
            y = _ship.y + _ship.offset.y;

            _animation.rotation = _ship.rotation - Math.PI/2;
        }

        private function handleOrder(event: Event):void
        {
            _animation.armature.animation.gotoAndPlayByFrame("order");
        }

        private function handleLaunch(event: Event):void
        {
            _animation.armature.animation.gotoAndPlayByFrame("launch");
        }

        private function handleCollide(event: Event):void
        {

        }

        private function handleLand(event: Event):void
        {
            _animation.armature.animation.gotoAndPlayByFrame("land");
        }

        private function handleCrash(event: Event):void
        {
//            destroy();
        }

        private function destroy():void
        {
            _ship.removeEventListener(SpaceBody.UPDATE, handleUpdate);
            _ship.removeEventListener(Ship.ORDER, handleOrder);
            _ship.removeEventListener(Ship.LAUNCH, handleLaunch);
            _ship.removeEventListener(Ship.COLLIDE, handleCollide);
            _ship.removeEventListener(Ship.LAND, handleLand);
            _ship.removeEventListener(Ship.CRASH, handleCrash);
            _ship = null;

            removeChild(_animation, true);
            _animation = null;

            removeFromParent(true);
        }
    }
}
