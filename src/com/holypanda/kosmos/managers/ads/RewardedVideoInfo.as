package com.holypanda.kosmos.managers.ads
{
    import com.holypanda.kosmos.utils.LocalStorage;

    public class RewardedVideoInfo
    {
        private static var rewardedVideoLimit: int = 5;
        private static var rewardedVideoRecovery: int = 3600; // 1 hour
        
        public static function setup(data: Object):void
        {
            rewardedVideoLimit = data["rewardedVideoLimit"] || 5;
            rewardedVideoRecovery = data["rewardedVideoRecovery"] || 3600;
        }
    
        private var _timestamps: Array;
    
        public function get recoveryTime():Number
        {
            return _timestamps.length > 0 ? _timestamps[_timestamps.length-1] + rewardedVideoRecovery * 1000.0 : -1;
        }
    
        public function check(now: Number):Boolean
        {
            cleanUp(now);
            return _timestamps.length < rewardedVideoLimit;
        }
    
        public function add(now: Number):void
        {
            _timestamps.push(now);
        }
    
        public function cleanUp(now: Number):void
        {
            while (_timestamps.length > 0 && now - _timestamps[0] > rewardedVideoRecovery * 1000.0)
            {
                _timestamps.shift();
            }
        }
    
        public function save():void
        {
            LocalStorage.settings.write("rewardedVideoInfo", _timestamps);
        }
    
        public function load():void
        {
            _timestamps = LocalStorage.settings.read("rewardedVideoInfo") as Array || [];
        }
    }
}
