/**
 * Created by agnither on 02.02.17.
 */
package com.holypanda.kosmos.tasks.logic
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.global.TaskSystem;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.model.Space;
    import com.holypanda.kosmos.model.player.Player;
    import com.holypanda.kosmos.model.player.vo.EpisodeResultVO;
    import com.holypanda.kosmos.tasks.server.SaveUserDataPlayFabTask;
    import com.holypanda.kosmos.tasks.server.vo.UserDataVO;
    import com.holypanda.kosmos.view.gui.popups.EpisodeDonePopup;
    import com.holypanda.kosmos.view.gui.popups.LevelDonePopup;
    import com.holypanda.kosmos.view.gui.popups.LevelFailPopup;
    import com.holypanda.kosmos.view.gui.popups.SurveyPopup;
    import com.holypanda.kosmos.vo.EpisodeVO;
    import com.holypanda.kosmos.vo.LevelVO;

    public class SaveLevelResultTask extends SimpleTask
    {
        public function SaveLevelResultTask()
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            var space: Space = Application.appController.space;
            if (space.win)
            {
                var level: LevelVO = Application.appController.levelsController.currentLevel;
                var episode: EpisodeVO = Application.appController.levelsController.currentEpisode;
                var player: Player = Application.appController.player;
                
                var lastLevelInEpisode: Boolean = level == episode.lastLevel;
                var result: EpisodeResultVO = player.getEpisodeResult(episode.id);
                if (lastLevelInEpisode && result == null)
                {
                    player.addMoney(episode.reward);
                    player.setEpisodeResult(level.episode);
                    WindowManager.showPopup(new EpisodeDonePopup(), true);
    
                    WindowManager.showPopup(new SurveyPopup(), true);
                }

                player.setLevelResult(level.id, 0, level.countStars(space.moves));
                player.save();
    
                var userData: UserDataVO = new UserDataVO();
                userData.money = String(player.money);
                userData.noAds = String(player.noAds);
                userData.levels = player.levels;
                userData.episodes = player.episodes;
                TaskSystem.getInstance().addTask(new SaveUserDataPlayFabTask(userData), complete);

                WindowManager.showPopup(new LevelDonePopup(), true);
            } else {
                WindowManager.showPopup(new LevelFailPopup(), true);
                
                complete();
            }
        }
    }
}
