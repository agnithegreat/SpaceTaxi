/**
 * Created by agnither on 08.06.16.
 */
package com.holypanda.kosmos.model.player
{
    import com.holypanda.kosmos.utils.LocalStorage;

    import starling.events.EventDispatcher;

    public class Volume extends EventDispatcher
    {
        public static const UPDATE: String = "Volume.UPDATE";
        
        private var _sound: int;
        public function get sound():int
        {
            return _sound;
        }

        private var _music: int;
        public function get music():int
        {
            return _music;
        }
        
        public function Volume()
        {
            load();
        }

        public function setSound(enabled: Boolean):void
        {
            _sound = enabled ? 100 : 0;
            update();
        }

        public function setMusic(enabled: Boolean):void
        {
            _music = enabled ? 100 : 0;
            update();
        }
        
        public function switchMusic():void
        {
            setMusic(_music == 0);
            save();
        }

        public function switchSound():void
        {
            setSound(_sound == 0);
            save();
        }
        
        public function save():void
        {
            LocalStorage.settings.write("sound", _sound);
            LocalStorage.settings.write("music", _music);
        }

        public function load():void
        {
            _sound = LocalStorage.settings.hasProperty("sound") ? LocalStorage.settings.read("sound") as int : 100;
            _music = LocalStorage.settings.hasProperty("music") ? LocalStorage.settings.read("music") as int : 100;
        }

        private function update():void
        {
            dispatchEventWith(Volume.UPDATE);
        }
    }
}
