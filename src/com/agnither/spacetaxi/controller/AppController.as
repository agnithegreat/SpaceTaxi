/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.controller
{
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.model.Space;
    import com.agnither.spacetaxi.model.player.Player;
    import com.agnither.spacetaxi.view.gui.popups.EpisodeDonePopup;
    import com.agnither.spacetaxi.view.gui.popups.LevelDonePopup;
    import com.agnither.spacetaxi.view.gui.popups.LevelFailPopup;

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
        
        public function AppController()
        {
            _stateController = new StateController();
            _levelsController = new LevelsController();
            _player = new Player();

            _space = new Space();
        }

        public function init():void
        {
            _stateController.init();
            _levelsController.init();
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
            pauseGame(true);

            if (_space.win)
            {
                // TODO: check if episode is done, and is done first time 
                if (false)
                {
                    _player.progress.setEpisodeResult(_levelsController.currentLevel.episode);
                    WindowManager.showPopup(new EpisodeDonePopup(), true);
                }

                _player.progress.setLevelResult(_levelsController.currentLevel.id, _space.orders.money, _levelsController.currentLevel.countStars(_space.moves));
                _player.progress.save();

                // TODO: sequence popups
                WindowManager.showPopup(new LevelDonePopup(), true);
            } else {
                WindowManager.showPopup(new LevelFailPopup(), true);
            }
        }
    }
}
