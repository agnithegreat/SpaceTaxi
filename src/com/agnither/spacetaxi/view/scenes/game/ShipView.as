/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view.scenes.game
{
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.Ship;
    import com.agnither.spacetaxi.model.SpaceBody;
    import com.agnither.spacetaxi.utils.GeomUtils;

    import dragonBones.starling.StarlingArmatureDisplay;
    import dragonBones.starling.StarlingFactory;

    import flash.geom.Point;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;

    public class ShipView extends Sprite
    {
        public static const EXPLODE: String = "ShipView.EXPLODE";
        
        private var _ship: Ship;

        private var _animation: StarlingArmatureDisplay;
        private var _thrust: Boolean;

        private var _mount: StarlingArmatureDisplay;
        private var _mounted: Boolean;

        private var _delayed: Boolean;

        private var _offset: Point;
        
        public function ShipView(ship: Ship)
        {
            super();
            
            _ship = ship;
            _ship.addEventListener(SpaceBody.UPDATE, handleUpdate);
            _ship.addEventListener(Ship.ORDER, handleOrder);
            _ship.addEventListener(Ship.LAUNCH, handleLaunch);
            _ship.addEventListener(Ship.COLLIDE, handleCollide);
            _ship.addEventListener(Ship.BOUNCE, handleBounce);
            _ship.addEventListener(Ship.LAND_PREPARE, handleLandPrepare);
            _ship.addEventListener(Ship.LAND, handleLand);
            _ship.addEventListener(Ship.CRASH, handleCrash);

            _animation = StarlingFactory.factory.buildArmatureDisplay("Ship", "ship");
            _animation.scaleX = 0.2;
            _animation.scaleY = 0.2;
            addChild(_animation);
            _animation.animation.gotoAndStopByFrame("launch");
            _animation.rotation = _ship.rotation + Math.PI * 0.5;

            _mount = _animation.getChildAt(2) as StarlingArmatureDisplay;

            _offset = new Point();

            handleUpdate(null);
        }

        private function handleUpdate(event: Event):void
        {
            var planet: Planet = _ship.planet;
            if (planet != null)
            {
                var angle: Number = Math.atan2(_ship.y - planet.y, _ship.x - planet.x);
                var nx: Number = planet.radius * Math.cos(angle) * Math.cos(planet.time) * planet.scale;
                var ny: Number = planet.radius * Math.sin(angle) * Math.cos(planet.time + Math.PI) * planet.scale;

                _offset.x += (nx - _offset.x) * 0.2;
                _offset.y += (ny - _offset.y) * 0.2;
            }

            x = _ship.x + _offset.x;
            y = _ship.y + _offset.y;

            var delta: Number = GeomUtils.getAngleDelta(_animation.rotation, _ship.rotation + Math.PI * 0.5);
            _animation.rotation += delta * 0.15;
        }

        private function stopFire():void
        {
            if (_thrust)
            {
                _animation.animation.gotoAndPlayByFrame("land");
                _thrust = false;
            }
        }

        private function mount():void
        {
            if (!_mounted)
            {
                _mount.animation.gotoAndPlayByFrame("open");
                _mounted = true;
            }
        }

        private function handleOrder(event: Event):void
        {
            SoundManager.playSound(SoundManager.OPEN_CLOSE);
            
            _animation.animation.gotoAndPlayByFrame("order");
        }

        private function handleLaunch(event: Event):void
        {
            _animation.animation.gotoAndPlayByFrame("launch");
            _mount.animation.gotoAndPlayByFrame("close");
            _thrust = true;
            _mounted = false;
            _delayed = false;

            SoundManager.playSound(SoundManager.START);
            SoundManager.playSound(SoundManager.FLY);
        }

        private function handleCollide(event: Event):void
        {
            if (event.data > 0)
            {
                SoundManager.playSound(SoundManager.CRASH);
            } else {
                SoundManager.playSound(SoundManager.EARTHING);
            }
//            SoundManager.playSound(SoundManager.JUMP_PLANET);
        }

        private function handleBounce(event: Event):void
        {
            SoundManager.playSound(SoundManager.JUMP_PLANET);
        }

        private function handleLandPrepare(event: Event):void
        {
            if (!_delayed)
            {
                Starling.juggler.delayCall(stopFire, 0.8);
                Starling.juggler.delayCall(mount, 0.8);
                _delayed = true;
            }
        }

        private function handleLand(event: Event):void
        {
            SoundManager.playSound(SoundManager.LEGS);

            stopFire();
            mount();
        }

        private function handleCrash(event: Event):void
        {
            clear();
            Starling.juggler.tween(_animation, 0.1, {alpha: 0, onComplete: destroy});
            
            dispatchEventWith(EXPLODE);

            SoundManager.playSound(SoundManager.EXPLOSION);
        }

        private function clear():void
        {
            Starling.juggler.removeDelayedCalls(stopFire);
            Starling.juggler.removeDelayedCalls(mount);

            if (_ship != null)
            {
                _ship.removeEventListener(SpaceBody.UPDATE, handleUpdate);
                _ship.removeEventListener(Ship.ORDER, handleOrder);
                _ship.removeEventListener(Ship.LAUNCH, handleLaunch);
                _ship.removeEventListener(Ship.COLLIDE, handleCollide);
                _ship.removeEventListener(Ship.BOUNCE, handleBounce);
                _ship.removeEventListener(Ship.LAND_PREPARE, handleLandPrepare);
                _ship.removeEventListener(Ship.LAND, handleLand);
                _ship.removeEventListener(Ship.CRASH, handleCrash);
                _ship = null;
            }
        }

        public function destroy():void
        {
            clear();

            removeChild(_animation, true);
            _animation = null;

            _mount = null;
            
            _offset = null;

            removeFromParent(true);
        }
    }
}
