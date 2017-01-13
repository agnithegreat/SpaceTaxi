/**
 * Created by agnither on 17.12.16.
 */
package com.agnither.spacetaxi.vo
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.player.vo.LevelResultVO;

    public class EpisodeVO
    {
        public static function get milkyway():EpisodeVO
        {
            var episode: EpisodeVO = new EpisodeVO();
            episode.id = 1;
            episode.name = "Milky Way";
            episode.skin = "milkyway_episode";
            episode.levels = new <LevelVO>[];
            episode.locked = false;
            return episode;
        }

        public static function get maelstrom():EpisodeVO
        {
            var episode: EpisodeVO = new EpisodeVO();
            episode.id = 2;
            episode.name = "Maelstrom";
            episode.skin = "maelstorm_episode";
            episode.levels = new <LevelVO>[];
            episode.locked = false;
            return episode;
        }

        public static function get soon():EpisodeVO
        {
            var episode: EpisodeVO = new EpisodeVO();
            episode.id = 3;
            episode.name = "Soon";
            episode.skin = "secret_episode";
            episode.levels = new <LevelVO>[];
            episode.locked = true;
            return episode;
        }

        public var id: int;
        public var name: String;
        public var skin: String;
        public var levels: Vector.<LevelVO>;
        public var locked: Boolean;

        public function get stars():int
        {
            var sum: int = 0;
            for (var i:int = 0; i < levels.length; i++)
            {
                var result: LevelResultVO = Application.appController.player.progress.getLevelResult(levels[i].id);
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
    }
}
