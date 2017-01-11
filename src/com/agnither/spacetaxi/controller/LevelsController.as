package com.agnither.spacetaxi.controller
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.utils.LevelParser;
    import com.agnither.spacetaxi.vo.EpisodeVO;
    import com.agnither.spacetaxi.vo.LevelVO;

    public class LevelsController
    {
        private var _episodes: Vector.<EpisodeVO>;
        public function get episodes():Vector.<EpisodeVO>
        {
            return _episodes;
        }
        
        public function get levels():Vector.<LevelVO> 
        {
            return currentEpisode.levels;
        }

        private var _currentEpisode: int;
        public function get currentEpisode():EpisodeVO
        {
            return _episodes[_currentEpisode];
        }
        
        private var _currentLevel: int;
        public function get currentLevel():LevelVO
        {
            return levels[_currentLevel];
        }
        
        public function LevelsController()
        {
            _episodes = new <EpisodeVO>[];
        }

        public function init():void
        {
            // TODO: remove any hardcode!!!
            
            _episodes.push(EpisodeVO.milkyway);
            _episodes.push(EpisodeVO.maelstrom);
            _episodes.push(EpisodeVO.soon);

            for (var i: int = 0; i < 100; i++)
            {
                var data: Object = Application.assetsManager.getObject("level" + (i+1));
                if (data != null)
                {
                    var ep: int = int(i / 12);
                    var episode: EpisodeVO = _episodes[ep];
                    var level: LevelVO = LevelParser.parse(i % 12, ep, data);
                    episode.levels.push(level);
                }
            }
        }

        public function selectEpisode(episode: int):void
        {
            _currentEpisode = episode;
        }
        
        public function selectLevel(level: int):void
        {
            _currentLevel = level;
        }
    }
}