/**
 * Created by agnither on 26.10.16.
 */
package com.agnither.spacetaxi.utils
{
    import flash.net.SharedObject;

    public class LocalStorage
    {
        public static const platform: LocalStorage = new LocalStorage("platform");
        public static const auth: LocalStorage = new LocalStorage("auth");
        public static const settings: LocalStorage = new LocalStorage("settings");
        
        private var _sharedObject: SharedObject;
        
        public function LocalStorage(name: String)
        {
            _sharedObject = SharedObject.getLocal(name);
        }
        
        public function write(key: String, value: Object):void
        {
            _sharedObject.data[key] = value;
            _sharedObject.flush();
        }

        public function read(key: String):Object
        {
            return _sharedObject.data[key];
        }

        public function hasProperty(key: String):Boolean
        {
            return _sharedObject.data.hasOwnProperty(key);
        }
    }
}
