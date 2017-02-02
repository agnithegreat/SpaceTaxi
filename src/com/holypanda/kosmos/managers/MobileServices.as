/**
 * Created by agnither on 03.05.14.
 */
package com.holypanda.kosmos.managers
{
    import com.holypanda.kosmos.managers.ads.Ads;
    import com.holypanda.kosmos.managers.iap.IAP;
    import com.holypanda.kosmos.managers.push.PushNotifications;

    public class MobileServices extends Services
    {
        private var _iap: IAP;
        private var _ads: Ads;
        private var _push: PushNotifications;

        public function MobileServices() {
            _iap = new IAP();
            
            _ads = new Ads();
            _push = new PushNotifications();
        }
    
        override public function addPurchaseListener(success: Function, fail: Function, productsReceived: Function):void {
            _iap.addEventListener(IAP.SUCCESS, success);
            _iap.addEventListener(IAP.FAIL, fail);
            _iap.addEventListener(IAP.PRODUCTS_RECEIVED, productsReceived);
        }
        override public function initInAppPurchases(ids: Array):void {
            _iap.init(ids);
        }
        override public function getProduct(id: String):Object {
            return _iap.getProduct(id);
        }
        override public function purchase(id: String):void {
            _iap.purchase(id);
        }
        override public function completePurchase(receipt: String):void {
            _iap.complete(receipt);
        }
        override public function get purchasesEnabled():Boolean
        {
            return _iap.isEnabled;
        }
    
        override public function initAds(rewardCallback: Function):void
        {
            _ads.init(rewardCallback);
        }
        override public function showInterstitial(callback: Function):void {
            _ads.showInterstitial(callback);
        }
        override public function showRewardedVideo(callback: Function):void {
            _ads.showRewardedVideo(callback);
        }
        override public function getReward():void
        {
            _ads.getReward();
        }
    }
}
