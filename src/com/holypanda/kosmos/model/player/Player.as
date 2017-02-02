/**
 * Created by agnither on 13.01.17.
 */
package com.holypanda.kosmos.model.player
{
    import com.holypanda.kosmos.model.player.vo.EpisodeResultVO;
    import com.holypanda.kosmos.model.player.vo.LevelResultVO;
    import com.holypanda.kosmos.tasks.server.vo.UserDataVO;
    import com.holypanda.kosmos.utils.LocalStorage;

    import flash.net.registerClassAlias;

    import starling.events.EventDispatcher;

    public class Player extends EventDispatcher
    {
        private var _money: int;
        public function get money():int
        {
            return _money;
        }
        
        private var _noAds: Boolean;
        public function get noAds():Boolean
        {
            return _noAds;
        }

        private var _levels: Object;
        public function get levels():Object
        {
            return _levels;
        }

        private var _episodes: Object;
        public function get episodes():Object
        {
            return _episodes;
        }

        private var _level: int;
        public function get level():int
        {
            return _level;
        }

        
        public function Player()
        {
            _levels = {};
            _episodes = {};

            registerClassAlias("LevelResultVO", LevelResultVO);
            registerClassAlias("EpisodeResultVO", EpisodeResultVO);
        }
        
        public function init(userData: UserDataVO):void
        {
            _money = Math.max(int(userData.money), _money);
            _noAds = _noAds || userData.noAds == "true";
            for each (var levelResult: Array in userData.levels)
            {
                setLevelResult(levelResult[0], levelResult[1], levelResult[2]);
            }
            for each (var episodeResult: Array in userData.episodes)
            {
                setEpisodeResult(episodeResult[0]);
            }
            save();
        }

        public function addMoney(value: int):void
        {
            _money += value;
        }

        public function getLevelResult(id: int):LevelResultVO
        {
            return _levels[id];
        }

        public function getEpisodeResult(id: int):EpisodeResultVO
        {
            return _episodes[id];
        }

        public function setLevelResult(id: int, money: int, stars: int):void
        {
            var progress: LevelResultVO = _levels[id] is LevelResultVO ? _levels[id] : new LevelResultVO();
            progress.level = id;
            if (progress.money < money)
            {
                progress.money = money;
            }
            if (progress.stars < stars)
            {
                progress.stars = stars;
            }
            _levels[id] = progress;

            if (_level < id+1)
            {
                _level = id+1;
            }
        }

        public function setEpisodeResult(id: int):void
        {
            var progress: EpisodeResultVO = _episodes[id] is EpisodeResultVO ? _episodes[id] : new EpisodeResultVO();
            progress.episode = id;
            _episodes[id] = progress;
        }

        public function save():void
        {
            LocalStorage.progress.write("money", _money);
            LocalStorage.progress.write("noAds", _noAds);
            LocalStorage.progress.write("levels", _levels);
            LocalStorage.progress.write("episodes", _episodes);
            LocalStorage.progress.write("current", _level);
        }

        public function load():void
        {
            _money = LocalStorage.progress.read("money") as int || 0;
            _noAds = LocalStorage.progress.read("noAds") as Boolean || false;
            _levels = LocalStorage.progress.read("levels") || {};
            _episodes = LocalStorage.progress.read("episodes") || {};
            _level = LocalStorage.progress.read("current") as int || 0;
        }
    }
}
