/**
 * Created by agnither on 02.06.16.
 */
package com.holypanda.kosmos.controller
{
    import com.holypanda.kosmos.managers.Services;
    import com.holypanda.kosmos.managers.ads.RewardedVideoInfo;
    import com.holypanda.kosmos.managers.windows.LoaderManager;

    import starling.core.Starling;
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
//            _services.initInAppPurchases(Application.appController.shop.products);
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
            // TODO: enable ads
//            if (!Application.appController.player.settings.ads) return;

            _count++;
            
            if (_count < 5) return;

            _count = 0;
            
            LoaderManager.startLoading("interstitial");
            _services.showInterstitial(function callback(success: Boolean):void
            {
                LoaderManager.stopLoading("interstitial");
            });
        }

        public function showRewardedVideo():void
        {
            var now: Number = (new Date()).time;
            if (_rewardedVideoInfo.check(now))
            {
                LoaderManager.startLoading("rewardedVideo");
                _services.showRewardedVideo(function callback(success: Boolean):void
                {
                    LoaderManager.stopLoading("rewardedVideo");
                    if (success)
                    {
                        var now: Number = (new Date()).time;
                        _rewardedVideoInfo.cleanUp(now);
                        _rewardedVideoInfo.add(now);
                        _rewardedVideoInfo.save();

                        dispatchEventWith(REWARDED_VIDEO);
                        
                        Starling.juggler.delayCall(_services.getReward, 1.5);
                    }
                });
            }
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
            LoaderManager.stopLoading("rewardedVideo");

            if (amount == 0) return;

//            TaskSystem.getInstance().addTask(new GetVideoBonusTask());
        }
    }
}