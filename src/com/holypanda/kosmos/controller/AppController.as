/**
 * Created by agnither on 14.11.16.
 */
package com.holypanda.kosmos.controller
{
    import com.agnither.tasks.global.TaskSystem;
    import com.holypanda.kosmos.Application;

    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.managers.analytics.GamePlayAnalytics;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.model.Space;
    import com.holypanda.kosmos.model.player.Player;
    import com.holypanda.kosmos.tasks.logic.SaveLevelResultTask;
    import com.holypanda.kosmos.tasks.logic.ShowAdsTask;
    import com.holypanda.kosmos.utils.logger.Logger;
    import com.holypanda.kosmos.view.gui.popups.ContinuePopup;

    import starling.core.Starling;
    import starling.events.Event;

    public class AppController
    {
        private var _stateController: StateController;
        public function get states():StateController
        {
            return _stateController;
        }
        
        private var _levelsController: LevelsController;
        public function get levelsController():LevelsController
        {
            return _levelsController;
        }
        
        private var _player: Player;
        public function get player():Player
        {
            return _player;
        }
        
        private var _space: Space;
        public function get space():Space
        {
            return _space;
        }

        private var _socialController: SocialController;
        public function get social():SocialController
        {
            return _socialController;
        }

        private var _servicesController: ServicesController;
        public function get services():ServicesController
        {
            return _servicesController;
        }
        
        public function AppController()
        {
            _stateController = new StateController();
            _levelsController = new LevelsController();
            _socialController = new SocialController();
            _servicesController = new ServicesController();
            _player = new Player();

            _space = new Space();
        }

        public function init():void
        {
            _stateController.init();
            _levelsController.init();

            _servicesController.init();

            _player.load();
        }

        public function selectEpisode(episode: int):void
        {
            _levelsController.selectEpisode(episode);
        }
        
        public function selectLevel(level: int):void
        {
            _levelsController.selectLevel(level);
        }
        
        public function startGame():void
        {
            _space.init(_levelsController.currentLevel);
            _space.addEventListener(Space.LEVEL_COMPLETE, handleLevelComplete);
            pauseGame(false);
        }

        public function reviveGame(value: Boolean):void
        {
            _space.revive(value);
            pauseGame(false);
        }

        public function restartGame():void
        {
            pauseGame(false);
            _space.restart(_levelsController.currentLevel);
        }
        
        public function pauseGame(value: Boolean):void
        {
            _space.pause(value);
            if (value)
            {
                Starling.juggler.remove(_space);
            } else {
                Starling.juggler.add(_space);
            }
        }

        public function endGame():void
        {
            pauseGame(true);
            _space.removeEventListener(Space.LEVEL_COMPLETE, handleLevelComplete);
            _space.destroy();
        }

        private function handleLevelComplete(event: Event):void
        {
            BUILD::mobile
            {
                if (!_space.win && !_space.revived)
                {
                    if (_player.noAds)
                    {
                        reviveGame(true);
                        return;
                    }

                    WindowManager.showPopup(new ContinuePopup(), true);
                    return;
                }
            }
            
            Starling.juggler.delayCall(checkResults, 1);
        }

        private function checkResults():void
        {
            pauseGame(true);

            if (Config.replay == null)
            {
                Logger.sendReplay(GamePlayAnalytics.exportData());
            }
            
            TaskSystem.getInstance().addTask(new SaveLevelResultTask());
            TaskSystem.getInstance().addTask(new ShowAdsTask());
        }
    }
}
