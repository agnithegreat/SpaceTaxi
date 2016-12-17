/**
 * Created by agnither on 06.12.16.
 */
package com.agnither.spacetaxi.managers.windows
{
    import flash.utils.Dictionary;

    public class LoaderManager
    {
        private static var loading: Dictionary = new Dictionary();
        
        public static function startLoading(id: String):void
        {
            loading[id] = true;
            update();
        }

        public static function stopLoading(id: String):void
        {
            delete loading[id];
            update();
        }
        
        private static function update():void
        {
            var show: Boolean;
            for (var id: String in loading)
            {
                show = true;
            }
            if (show)
            {
                WindowManager.showLoader();
            } else {
                WindowManager.hideLoader();
            }
        }
    }
}
