/**
 * Created by agnither on 02.06.16.
 */
package com.holypanda.kosmos.controller
{
    import com.holypanda.kosmos.managers.Services;
    import com.holypanda.kosmos.managers.ads.RewardedVideoInfo;
    import com.holypanda.kosmos.managers.windows.LoaderManager;

    import starling.events.Event;
    import starling.events.EventDispatcher;

    public class ServicesController extends EventDispatcher
    {
        public static const INIT: String = "ServicesController.INIT";
        public static const REWARDED_VIDEO: String = "ServicesController.REWARDED_VIDEO";
        public static const PURCHASE_SUCCESS: String = "ServicesController.PURCHASE_SUCCESS";
        public static const PURCHASE_FAIL: String = "ServicesController.PURCHASE_FAIL";

        private var _services: Services;
        public function get services():Services
        {
            return _services;
        }
        
        private var _count: int;
        public function get count():int
        {
            return _count;
        }
        public function set count(value: int):void
        {
            _count = value;
        }

        private var _rewardedVideoInfo: RewardedVideoInfo;
        public function get rewardedVideoInfo():RewardedVideoInfo
        {
            return _rewardedVideoInfo;
        }
        
        public function ServicesController()
        {
            _services = Services.getServices();
        }

        public function init():void
        {
            _services.init();
            
            _services.addPurchaseListener(handleIAPSuccess, handleIAPFail, handleIAPProductsReceived);
            _services.initInAppPurchases(Services.products);
        }
        
        public function initAds():void
        {
            _services.initAds(handleAdsReward);

            _count = 0;

            _rewardedVideoInfo = new RewardedVideoInfo();
            _rewardedVideoInfo.load();
            
            dispatchEventWith(INIT);
        }

        public function showInterstitial():void
        {
            LoaderManager.startLoading("interstitial");
            _services.showInterstitial(function callback(success: Boolean):void
            {
                LoaderManager.stopLoading("interstitial");
            });
        }

        public function showRewardedVideo():void
        {
            LoaderManager.startLoading("rewardedVideo");
            _services.showRewardedVideo(function callback(success: Boolean):void
            {
                LoaderManager.stopLoading("rewardedVideo");
                dispatchEventWith(REWARDED_VIDEO, false, success);
            });
        }

        public function makePurchase(id: String):void
        {
            _services.purchase(id);
        }

        public function completePurchase(receipt: String):void
        {
            _services.completePurchase(receipt);
        }

        private function handleIAPSuccess(event: Event):void
        {
            dispatchEventWith(PURCHASE_SUCCESS, false, event.data);
        }

        private function handleIAPFail(event: Event):void
        {
            dispatchEventWith(PURCHASE_FAIL, false, event.data);
        }

        private function handleIAPProductsReceived(event: Event):void
        {
//            var list: Vector.<ShopItem> = Application.appController.shop.list;
//            for (var i:int = 0; i < list.length; i++)
//            {
//                var item: ShopItem = list[i];
//                var product: Object = _services.getProduct(Services.prefix + item.itemId);
//                if (product != null)
//                {
//                    item.name = product["title"];
//                    item.price = product["price"];
//                    item.product = product;
//                }
//            }
        }

        private function handleAdsReward(amount: int):void
        {
        }
    }
}