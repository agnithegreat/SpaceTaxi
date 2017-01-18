/**
 * Created by agnither on 13.01.17.
 */
package com.agnither.spacetaxi.model.player
{
    import com.agnither.spacetaxi.model.player.vo.LevelResultVO;
    import com.agnither.spacetaxi.utils.LocalStorage;

    import flash.net.registerClassAlias;

    import starling.events.EventDispatcher;

    public class Progress extends EventDispatcher
    {
        private var _levels: Object;

        private var _level: int;
        public function get level():int
        {
            return _level;
        }

        public function Progress()
        {
            _levels = {};

            registerClassAlias("LevelResultVO", LevelResultVO);
        }

        public function getLevelResult(id: int):LevelResultVO
        {
            return _levels[id];
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

        public function save():void
        {
            LocalStorage.progress.write("levels", _levels);
            LocalStorage.progress.write("current", _level);
        }

        public function load():void
        {
            _levels = LocalStorage.progress.read("levels") || {};
            _level = LocalStorage.progress.read("current") as int || 0;
        }
    }
}