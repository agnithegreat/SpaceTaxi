/**
 * Created by agnither on 14.11.16.
 */
package com.holypanda.kosmos.controller
{
    import com.agnither.tasks.global.TaskSystem;

    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.managers.analytics.GamePlayAnalytics;
    import com.holypanda.kosmos.model.Space;
    import com.holypanda.kosmos.model.player.Player;
    import com.holypanda.kosmos.tasks.logic.SaveLevelResultTask;
    import com.holypanda.kosmos.utils.logger.Logger;

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

            _player.init();
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
                Starling.juggler.remove(_space)
            } else {
                Starling.juggler.add(_space)
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
            if (Config.replay == null)
            {
                Logger.sendReplay(GamePlayAnalytics.exportData());
            }

            pauseGame(true);

            Starling.juggler.delayCall(checkResults, 1);
        }

        private function checkResults():void
        {
            TaskSystem.getInstance().addTask(new SaveLevelResultTask());

            _servicesController.showInterstitial();
        }
    }
}
