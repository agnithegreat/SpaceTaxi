/**
 * Created by agnither on 03.05.14.
 */
package com.holypanda.kosmos.managers
{
    import by.blooddy.crypto.MD5;

    import com.holypanda.kosmos.utils.LocalStorage;

    import starling.events.Event;

    public class Services
    {
        public static function getServices():Services
        {
            BUILD::mobile
            {
                return new MobileServices();
            }
            return new Services();
        }

        public static function get prefix():String
        {
            BUILD::ios
            {
                return "com.holypanda.kosmos.";
            }
            BUILD::android
            {
                return "com.holypanda.kosmos.";
            }
            return "";
        }
        
        public static function get products():Array
        {
            return [prefix + "noads"];
        }

        public static function get deviceId():String
        {
            var id: String = LocalStorage.platform.read("deviceId") as String;
            if (id == null)
            {
                id = MD5.hash(String(Math.random()));
                LocalStorage.platform.write("deviceId", id);
            }
            return id;
        }

        private var _success: Function;
        
        public function Services()
        {
        }
    
        public function init():void
        {
        }
    
        // IAP
        public function initInAppPurchases(ids: Array):void {
    
        }
        public function getProduct(id: String):Object {
            return null;
        }
        public function purchase(id: String):void {
            _success(new Event(null, false, {}));
        }
        public function completePurchase(receipt: String):void {
    
        }
        public function addPurchaseListener(success: Function, fail: Function, productsReceived: Function):void {
            _success = success;
        }
        public function get purchasesEnabled():Boolean
        {
            return false;
        }

        public function initAds(rewardCallback: Function):void
        {
        }
        public function showInterstitial(callback: Function):void {
            if (callback != null)
            {
                callback(false);
            }
        }
        public function showRewardedVideo(callback: Function):void {
            if (callback != null)
            {
                callback(false);
            }
        }
        public function getReward():void
        {
            
        }
    }
}
