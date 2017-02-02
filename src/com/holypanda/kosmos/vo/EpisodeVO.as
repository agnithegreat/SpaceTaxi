/**
 * Created by agnither on 17.12.16.
 */
package com.holypanda.kosmos.vo
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.model.player.vo.LevelResultVO;

    public class EpisodeVO
    {
        public static function get milkyway():EpisodeVO
        {
            var episode: EpisodeVO = new EpisodeVO();
            episode.id = 1;
            episode.skin = "milkyway_episode";
            episode.levels = new <LevelVO>[];
            episode.reward = 1000;
            episode.locked = false;
            return episode;
        }

        public static function get maelstrom():EpisodeVO
        {
            var episode: EpisodeVO = new EpisodeVO();
            episode.id = 2;
            episode.skin = "maelstorm_episode";
            episode.levels = new <LevelVO>[];
            episode.reward = 2000;
            episode.locked = false;
            return episode;
        }

        public static function get soon():EpisodeVO
        {
            var episode: EpisodeVO = new EpisodeVO();
            episode.id = 3;
            episode.skin = "secret_episode";
            episode.levels = new <LevelVO>[];
            episode.reward = 3000;
            episode.locked = true;
            return episode;
        }

        public var id: int;
        public var skin: String;
        public var levels: Vector.<LevelVO>;
        public var reward: int;
        public var locked: Boolean;

        public function get stars():int
        {
            var sum: int = 0;
            for (var i:int = 0; i < levels.length; i++)
            {
                var result: LevelResultVO = Application.appController.player.getLevelResult(levels[i].id);
                if (result != null)
                {
                    sum += result.stars;
                }
            }
            return sum;
        }

        public function get starsTotal():int
        {
            return levels.length * 3;
        }
        
        public function get lastLevel():LevelVO
        {
            return levels[levels.length-1];
        }
    }
}
