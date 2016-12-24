/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view.scenes.game
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.enums.ZoneType;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.model.SpaceBody;
    import com.agnither.spacetaxi.model.orders.Zone;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;

    public class ZoneView extends Sprite
    {
        public static const COLORS: Array = [0xba47ff, 0xff47bd, 0xff7947, 0xffe447, 0x62ff47, 0x47ffc5, 0x47e8ff, 0x4770ff];

        private var _zone: Zone;

        private var _back: Image;
        private var _animation: MovieClip;

        private var _sign: Image;

        private var _count: int;

        public function ZoneView(zone: Zone)
        {
            super();

            _zone = zone;

            var scale: Number = _zone.zone.size / 100;

            _back = new Image(Application.assetsManager.getTexture("misc/glow_back"));
            _back.pivotX = _back.width * 0.5;
            _back.pivotY = _back.height * 0.4;
            _back.scaleX = scale;
            _back.scaleY = scale;
            addChild(_back);

            var textures: Vector.<Texture> = Application.assetsManager.getTextures("misc/Glow/");
//            if (isArrival)
//            {
//                textures = textures.reverse();
//            }
            _animation = new MovieClip(textures);
            _animation.addEventListener(Event.COMPLETE, handleAnimationComplete);
            _animation.pivotX = _animation.width * 0.5;
            _animation.pivotY = _animation.height * 0.4;
            _animation.scaleX = scale;
            _animation.scaleY = scale;
            _animation.color = COLORS[_zone.id];
            addChild(_animation);
            Starling.juggler.add(_animation);

            setup();

            _zone.addEventListener(Zone.UPDATE, handleUpdate);
            handleUpdate(null);

            _zone.planet.addEventListener(SpaceBody.UPDATE, handlePlanetUpdate);
            handlePlanetUpdate(null);

            rotation = Math.atan2(_zone.zone.position.y - _zone.planet.y, _zone.zone.position.x - _zone.planet.x) + Math.PI * 0.5;
        }

        private function setup():void
        {
            switch (_zone.zone.type)
            {
                case ZoneType.DEPARTURE:
                {
                    _sign = new Image(Application.assetsManager.getTexture("misc/symbol"));
                    _sign.pivotX = _sign.width * 0.5;
                    _sign.pivotY = _sign.height * 0.5;
                    addChild(_sign);
                    break;
                }

                case ZoneType.ARRIVAL:
                {
                    break;
                }

                case ZoneType.FUEL:
                {
                    _sign = new Image(Application.assetsManager.getTexture("misc/symbol_station"));
                    _sign.pivotX = _sign.width * 0.5;
                    _sign.pivotY = _sign.height * 0.5;
                    addChild(_sign);
                    break;
                }
            }
        }

        private function handleAnimationComplete(event: Event):void
        {
            _count++;
            if (_count >= 2)
            {
                _animation.stop();
                Starling.juggler.delayCall(_animation.play, 1 + Math.random() * 2);
                _count = 0;
            }
        }

        private function handleUpdate(event: Event):void
        {
            visible = _zone.active;

            if (event != null)
            {
                SoundManager.playSound(SoundManager.CHECK_GREEN);
            }
        }

        private function handlePlanetUpdate(event: Event):void
        {
            var angle: Number = Math.atan2(_zone.zone.position.y - _zone.planet.y, _zone.zone.position.x - _zone.planet.x);
            var nx: Number = _zone.planet.radius * Math.cos(angle) * Math.cos(_zone.planet.time) * _zone.planet.scale;
            var ny: Number = _zone.planet.radius * Math.sin(angle) * Math.cos(_zone.planet.time + Math.PI) * _zone.planet.scale;

            x = _zone.zone.position.x + nx;
            y = _zone.zone.position.y + ny;

            if (_sign != null)
            {
                var jump: Number = 0.1 + 0.125 * (Math.cos(_zone.planet.time * 3) + 1);
                _sign.y = 50 * jump - _sign.height;
            }
        }
        
        public function destroy():void
        {
            _zone.planet.removeEventListener(SpaceBody.UPDATE, handlePlanetUpdate);
            _zone.removeEventListener(Zone.UPDATE, handleUpdate);
            _zone = null;

            _back.removeFromParent(true);
            _back = null;
            
            _animation.removeFromParent(true);
            _animation = null;

            removeFromParent(true);
        }
    }
}
