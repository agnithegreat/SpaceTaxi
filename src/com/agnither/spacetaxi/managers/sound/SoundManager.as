/**
 * Created by agnither on 08.06.16.
 */
package com.agnither.spacetaxi.managers.sound
{
    import by.blooddy.crypto.MD5;

    import flash.desktop.NativeApplication;
    import flash.media.AudioPlaybackMode;
    import flash.media.Sound;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    import starling.events.Event;

    public class SoundManager
    {
        public static const MENU: String = "sound.Menu";
        public static const GAMEPLAY: String = "sound.Gameplay";

        public static const CHECK_GREEN: String = "sound.CheckGreen";
        public static const COINS_LOOP: String = "sound.CoinsLoop";
        public static const EARTHING_OTHER: String = "sound.EarthingOther";
        public static const EARTHING: String = "sound.Earthing";
        public static const EXPLOSION: String = "sound.Explosion";
        public static const FLY: String = "sound.Fly";
        public static const JUMP_PLANET: String = "sound.JumpPlanet";
        public static const LEGS: String = "sound.Legs";
        public static const OPEN_CLOSE: String = "sound.OpenClose";
        public static const START: String = "sound.Start";

        public static const FUEL_LOAD: String = "sound.FuelLoad";
        public static const LOW_FUEL: String = "sound.LowFuel";
        public static const CRASH: String = "sound.Crash";
        public static const CLICK: String = "sound.Click";
        public static const BOX_TAKE: String = "sound.BoxTake";

        private static var playing: Dictionary = new Dictionary(true);

        public static function getSound(name: String):Sound
        {
//            var sound: Sound = Application.assetsManager.getSound(name);
            var SoundClass: Class = getDefinitionByName(name) as Class;
            return SoundClass != null ? new SoundClass() : null;
        }

//        public static function get volume():Volume
//        {
//            return ApplicationModel.volume;
//        }

        public static function init():void
        {
            SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
//            volume.addEventListener(Volume.UPDATE, handleUpdate);

            NativeApplication.nativeApplication.addEventListener("activate", handleActivate);
            NativeApplication.nativeApplication.addEventListener("deactivate", handleDeactivate);
        }

        public static function playMusic(name: String):void
        {
            if (playing[name]) return;

            var sound: Sound = getSound(name);
            var container: SoundContainer = new SoundContainer(sound, true);
            container.play();
//            container.volume = container.music ? volume.music : volume.sound;

            playing[name] = container;
        }

        public static function stopMusic(name: String):void
        {
            if (!playing[name]) return;

            var container: SoundContainer = playing[name];
            if (container != null)
            {
                container.stop();
                container.destroy();
                delete playing[name];
            }
        }

        public static function playSound(name: String, loop: Boolean = false):String
        {
            var sound: Sound = getSound(name);
            var container: SoundContainer = new SoundContainer(sound, loop);
            container.play();
//            container.volume = container.music ? volume.music : volume.sound;
            
            var key: String = name + "." + MD5.hash(String(Math.random()));
            playing[key] = container;
            return key;
        }
        
        public static function stopSound(uniqueName: String):void
        {
            var container: SoundContainer = playing[uniqueName];
            if (container != null)
            {
                container.stop();
                container.destroy();
                delete playing[uniqueName];
            }
        }

        private static function handleUpdate(event: Event):void
        {
            for (var key:String in playing)
            {
                var container: SoundContainer = playing[key];
                if (container.alive)
                {
//                    container.volume = container.music ? volume.music : volume.sound;
                } else {
                    delete playing[key];
                }
            }
        }

        private static function handleActivate(event: Object):void
        {
            SoundMixer.soundTransform = new SoundTransform(1);
        }

        private static function handleDeactivate(event: Object):void
        {
            SoundMixer.soundTransform = new SoundTransform(0);
        }
    }
}

import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;

class SoundContainer
{
    private var _sound: Sound;
    private var _soundChannel: SoundChannel;
    private var _loop: Boolean;
    
    public function get alive():Boolean
    {
        return _sound != null;
    }

    public function SoundContainer(sound: Sound, loop: Boolean)
    {
        _sound = sound;
        _loop = loop;
    }

    public function play():void
    {
        _soundChannel = _sound.play(0, _loop ? int.MAX_VALUE : 0);
        if (_soundChannel != null)
        {
            _soundChannel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
        }
    }
    
    public function stop():void
    {
        if (_soundChannel != null)
        {
            _soundChannel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
            _soundChannel.stop();
            _soundChannel = null;
        }
    }

    public function set volume(value: int):void
    {
        if (_soundChannel != null)
        {
            _soundChannel.soundTransform = new SoundTransform(value * 0.01);
        }
    }

    private function handleSoundComplete(event: Event):void
    {
        stop();
        
        if (_loop)
        {
            play()
        } else {
            destroy();
        }
    }
    
    public function destroy():void
    {
        stop();
        
        _sound = null;
    }
}