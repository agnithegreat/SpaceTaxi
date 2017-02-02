/**
 * Created by agnither on 10.07.15.
 */
package com.holypanda.kosmos.managers.ads
{
    import com.fyber.FyberSdk;
    import com.fyber.air.events.ExceptionEvent;
    import com.fyber.air.events.InterstitialEvent;
    import com.fyber.air.events.RewardedVideoEvent;
    import com.fyber.air.events.VCSEvent;

    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.utils.logger.Logger;

    public class Ads
    {
        private var _waitInterstitial: Boolean;
        private var _readyInterstitial: Boolean;

        private var _waitRewardedVideo: Boolean;
        private var _readyRewardedVideo: Boolean;
        private var _callback: Function;
        
        private var _rewardCallback: Function;

        public function Ads()
        {
        }
        
        public function init(rewardCallback: Function):void
        {
            _rewardCallback = rewardCallback;

            BUILD::android
            {
                FyberSdk.instance.start("90235", "3829fc1f82c181707c51a783c185387e", Config.userId);
            }
            BUILD::ios
            {
                FyberSdk.instance.start("90234", "aac68868ace46220be854066809a30df", Config.userId);
            }
            FyberSdk.instance.addEventListener(InterstitialEvent.STATUS, handleFyberInterstitialEvent);
            FyberSdk.instance.addEventListener(RewardedVideoEvent.STATUS, handleFyberRewardedVideoEvent);
            FyberSdk.instance.addEventListener(VCSEvent.STATUS, handleFyberVCSEvent);
            FyberSdk.instance.addEventListener(ExceptionEvent.STATUS, handleFyberExceptionEvent);
        }

        public function showInterstitial(callback: Function = null):void
        {
            _callback = callback;
            if (_readyInterstitial)
            {
                FyberSdk.instance.showInterstitialAds();
            } else if (!_waitInterstitial)
            {
                _waitInterstitial = true;
                FyberSdk.instance.requestInterstitialAds();
            }
        }

        public function showRewardedVideo(callback: Function = null):void
        {
            _callback = callback;
            if (_readyRewardedVideo)
            {
                FyberSdk.instance.showRewardedVideoAd();
            } else if (!_waitRewardedVideo)
            {
                _waitRewardedVideo = true;
//                FyberSdk.instance.requestRewardedVideoAds(null, null, true);
                FyberSdk.instance.requestRewardedVideoAds();
            }
        }
        
        public function getReward():void
        {
            FyberSdk.instance.requestNewCoins();
        }

        private function handleFyberInterstitialEvent(event: InterstitialEvent):void
        {
            Logger.log("handleFyberInterstitialEvent:", event.status, event.message);
            switch (event.status)
            {
                case InterstitialEvent.DISMISS_REASON_UNKNOWN:
                {
                    if (_callback != null)
                    {
                        _callback(false);
                    }
                    _waitRewardedVideo = false;
                    _readyInterstitial = false;
                    break;
                }
                case InterstitialEvent.DISMISS_REASON_USER_CLICKED_AD:
                {
                    if (_callback != null)
                    {
                        _callback(true);
                    }
                    _waitRewardedVideo = false;
                    _readyInterstitial = false;
                    break;
                }
                case InterstitialEvent.DISMISS_REASON_USER_CLOSED_AD:
                {
                    if (_callback != null)
                    {
                        _callback(false);
                    }
                    _waitRewardedVideo = false;
                    _readyInterstitial = false;
                    break;
                }
                case InterstitialEvent.ERROR:
                {
                    if (_callback != null)
                    {
                        _callback(false);
                    }
                    _waitRewardedVideo = false;
                    _readyInterstitial = false;
                    break;
                }
                case InterstitialEvent.AVAILABLE:
                {
                    if (_waitInterstitial)
                    {
                        _waitInterstitial = false;
                        FyberSdk.instance.showInterstitialAds();
                    } else {
                        _readyInterstitial = true;
                    }
                    break;
                }
                case InterstitialEvent.UNAVAILABLE:
                {
                    if (_callback != null)
                    {
                        _callback(false);
                    }
                    _waitRewardedVideo = false;
                    _readyInterstitial = false;
                    break;
                }
            }
        }

        private function handleFyberRewardedVideoEvent(event: RewardedVideoEvent):void
        {
            Logger.log("handleFyberRewardedVideoEvent:", event.status, event.message);
            switch (event.status)
            {
                case RewardedVideoEvent.STARTED:
                {
                    SoundManager.tweenVolume(0, 0.3);
                    _waitRewardedVideo = false;
                    _readyRewardedVideo = false;
                    break;
                }
                case RewardedVideoEvent.CLOSE_FINISHED:
                {
                    SoundManager.tweenVolume(100, 0.3);
                    if (_callback != null)
                    {
                        _callback(true);
                    }
                    _waitRewardedVideo = false;
                    _readyRewardedVideo = false;
                    break;
                }
                case RewardedVideoEvent.CLOSE_ABORTED:
                {
                    SoundManager.tweenVolume(100, 0.3);
                    if (_callback != null)
                    {
                        _callback(false);
                    }
                    _waitRewardedVideo = false;
                    _readyRewardedVideo = false;
                    break;
                }
                case RewardedVideoEvent.AVAILABLE:
                {
                    if (_waitRewardedVideo)
                    {
                        _waitRewardedVideo = false;
                        FyberSdk.instance.showRewardedVideoAd();
                    } else {
                        _readyRewardedVideo = true;
                    }
                    break;
                }
                case RewardedVideoEvent.UNAVAILABLE:
                {
                    _waitRewardedVideo = false;
                    _readyRewardedVideo = false;
                    if (_callback != null)
                    {
                        _callback(false);
                    }
                    break;
                }
                case RewardedVideoEvent.ERROR:
                {
                    _waitRewardedVideo = false;
                    _readyRewardedVideo = false;
                    if (_callback != null)
                    {
                        _callback(false);
                    }
                    break;
                }
            }
        }

        private function handleFyberVCSEvent(event: VCSEvent):void
        {
            switch (event.status)
            {
                case VCSEvent.SUCCESS:
                {
                    _rewardCallback(event.deltaOfCoins);
                    
                    Logger.log("currencyName", event.currencyName);
                    Logger.log("currencyId", event.currencyId);
                    Logger.log("deltaOfCoins", event.deltaOfCoins);
                    Logger.log("transactionId", event.transactionId);
                    // e.currencyName = Name of the currency awarded
                    // e.currencyId = ID of the currency awarded (as specified in the Fyber Dashboard)
                    // e.deltaOfCoins = Amount of coins to be given to the user
                    // e.transactionId = The latest transaction ID
                    break;
                }
                case VCSEvent.ERROR:
                {
                    Logger.log("errorMessage", event.errorMessage);
                    Logger.log("errorType", event.errorType);
                    Logger.log("errorCode", event.errorCode);
                    // e.errorMessage = A description of the error
                    // e.errorType = A detail of what kind of error
                    // e.errorCode = An error code
                    break;
                }
            }
        }

        private function handleFyberExceptionEvent(event: ExceptionEvent):void
        {
            Logger.log("handleFyberExceptionEvent:", event.message);
        }
    }
}
