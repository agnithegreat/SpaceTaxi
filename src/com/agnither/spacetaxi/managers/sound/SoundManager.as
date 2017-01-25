/**
 * Created by agnither on 08.06.16.
 */
package com.agnither.spacetaxi.managers.sound
{
    import by.blooddy.crypto.MD5;

    import com.agnither.spacetaxi.Config;
    import com.agnither.spacetaxi.model.player.Volume;

    import flash.desktop.NativeApplication;
    import flash.media.AudioPlaybackMode;
    import flash.media.Sound;
    import flash.media.SoundMixer;
    import flash.media.SoundTransform;
    import flash.utils.Dictionary;
    import flash.utils.getDefinitionByName;

    import starling.core.Starling;
    import starling.events.Event;

    public class SoundManager
    {
        public static const MENU: String = "menu";
        public static const GAMEPLAY: String = "gameplay";

        public static const CHECK_GREEN: String = "check_green";
        public static const COINS_LOOP: String = "coins_loop";
        public static const EARTHING_OTHER: String = "earthing_other";
        public static const EARTHING: String = "earthing";
        public static const EXPLOSION: String = "explosion";
        public static const FLY: String = "fly";
        public static const JUMP_PLANET: String = "jump_planet";
        public static const LEGS: String = "legs";
        public static const OPEN_CLOSE: String = "open_close";
        public static const START: String = "start";

        public static const FUEL_LOAD: String = "fuel_load";
        public static const LOW_FUEL: String = "low_fuel";
        public static const CRASH: String = "crash";
        public static const CLICK: String = "click";
        public static const BOX_TAKE: String = "box_take";

        public static const BUY: String = "buy";
        public static const DIALOG_MORSE_1: String = "dialog_morse_1";
        public static const DIALOG_MORSE_2: String = "dialog_morse_2";
        public static const DIALOG_MORSE_3: String = "dialog_morse_3";
        public static const POPUP_CLOSE: String = "pop_up_close";
        public static const POPUP_LOSE: String = "pop_up_lose";
        public static const POPUP_OPEN: String = "pop_up_open";
        public static const POPUP_REWARD: String = "pop_up_reward";
        public static const POPUP_WIN_EPISODE: String = "pop_up_win_episode";
        public static const POPUP_WIN_LEVEL: String = "pop_up_win_level";
        public static const SWISH: String = "swish";
        public static const UNAVAILABLE_PLANET: String = "unavalible_planet";

        private static var playing: Dictionary = new Dictionary(true);
        private static var currentMusic: SoundContainer;

        public static function getSound(name: String):Sound
        {
            var SoundClass: Class = getDefinitionByName(name) as Class;
            return SoundClass != null ? new SoundClass() : null;
        }

        public static function init():void
        {
            SoundMixer.audioPlaybackMode = AudioPlaybackMode.AMBIENT;
            Config.volume.addEventListener(Volume.UPDATE, handleUpdate);

            NativeApplication.nativeApplication.addEventListener("activate", handleActivate);
            NativeApplication.nativeApplication.addEventListener("deactivate", handleDeactivate);
        }

        public static function playMusic(name: String):void
        {
            if (playing[name]) return;

            var sound: Sound = getSound(name);
            var container: SoundContainer = new SoundContainer(sound, true, true);
            container.play();
            container.volume = Config.volume.music;

            playing[name] = container;
            currentMusic = container;
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
            var container: SoundContainer = new SoundContainer(sound, loop, false);
            container.play();
            container.volume = Config.volume.sound;
            
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

        public static function tweenMusicVolume(value: int, time: Number):void
        {
            if (currentMusic != null)
            {
                Starling.juggler.removeTweens(currentMusic);
                Starling.juggler.tween(currentMusic, time, {volume: value * Config.volume.music * 0.01});
            }
        }

        public static function tweenVolume(value: int, time: Number):void
        {
            Starling.juggler.removeTweens(SoundManager);
            Starling.juggler.tween(SoundManager, time, {volume: value});
        }
        
        public static function set volume(value: int):void
        {
            SoundMixer.soundTransform = new SoundTransform(value * 0.01);
        }

        public static function get volume():int
        {
            return SoundMixer.soundTransform.volume * 100;
        }

        private static function handleUpdate(event: Event):void
        {
            for (var key:String in playing)
            {
                var container: SoundContainer = playing[key];
                if (container.alive)
                {
                    container.volume = container.music ? Config.volume.music : Config.volume.sound;
                } else {
                    delete playing[key];
                }
            }
        }

        private static function handleActivate(event: Object):void
        {
            tweenVolume(100, 0.3);
        }

        private static function handleDeactivate(event: Object):void
        {
            tweenVolume(0, 0.3);
        }
    }
}

import flash.events.Event;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundMixer;
import flash.media.SoundTransform;

class SoundContainer
{
    private var _sound: Sound;
    private var _soundChannel: SoundChannel;
    private var _loop: Boolean;
    private var _music: Boolean;
    
    public function get alive():Boolean
    {
        return _sound != null;
    }
    
    public function get music():Boolean
    {
        return _music;
    }

    public function SoundContainer(sound: Sound, loop: Boolean, music: Boolean)
    {
        _sound = sound;
        _loop = loop;
        _music = music;
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

    public function get volume():int
    {
        return _soundChannel != null ? _soundChannel.soundTransform.volume * 100 : 0;
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