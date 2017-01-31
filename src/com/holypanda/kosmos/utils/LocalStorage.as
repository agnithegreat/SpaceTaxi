/**
 * Created by agnither on 26.10.16.
 */
package com.holypanda.kosmos.utils
{
    import flash.net.SharedObject;
    import flash.utils.ByteArray;

    public class LocalStorage
    {
        public static const progress: LocalStorage = new LocalStorage("progress");
        public static const platform: LocalStorage = new LocalStorage("platform");
        public static const logging: LocalStorage = new LocalStorage("logging");
        
        public static const auth: LocalStorage = new LocalStorage("auth");
        public static const settings: LocalStorage = new LocalStorage("settings");
        
        private var _sharedObject: SharedObject;
        
        public function LocalStorage(name: String)
        {
            _sharedObject = SharedObject.getLocal(name);
        }
        
        public function write(key: String, value: Object):void
        {
            var ba: ByteArray = new ByteArray();
            ba.writeObject(value);
            _sharedObject.data[key] = ba;
            _sharedObject.flush();
        }

        public function read(key: String):Object
        {
            var ba: ByteArray = _sharedObject.data[key] as ByteArray;
            if (ba == null) return null;
            ba.position = 0;
            return ba.readObject();
        }

        public function hasProperty(key: String):Boolean
        {
            return _sharedObject.data.hasOwnProperty(key);
        }
    }
}
