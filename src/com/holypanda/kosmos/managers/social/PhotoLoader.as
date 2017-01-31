/**
 * Created by agnither on 09.06.16.
 */
package com.holypanda.kosmos.managers.social
{
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.net.URLRequest;
    import flash.utils.Dictionary;

    public class PhotoLoader extends EventDispatcher
    {
        private static var _storage: Dictionary = new Dictionary();
        
        public static function loadPhoto(url: String):PhotoLoader
        {
            if (_storage[url] == null)
            {
                var loader: PhotoLoader = new PhotoLoader(url);
                _storage[url] = loader;
            }
            return _storage[url];
        }

        public var texture: BitmapData;

        private var _loader: Loader;

        public function PhotoLoader(url: String)
        {
            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handlePhotoLoaded);
            _loader.load(new URLRequest(url));
        }

        private function handlePhotoLoaded(event: Event):void
        {
            texture = Bitmap(_loader.content).bitmapData;

            _loader.unloadAndStop();
            _loader = null;

            dispatchEvent(event);
        }
    }
}