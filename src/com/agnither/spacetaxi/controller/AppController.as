/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.controller
{
    import com.agnither.spacetaxi.model.Space;
    import com.agnither.spacetaxi.model.player.Player;

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
            Starling.juggler.add(_space);
        }

        public function restartGame():void
        {
            _space.restart(_levelsController.currentLevel);
        }

        public function endGame():void
        {
            Starling.juggler.remove(_space);
            _space.removeEventListener(Space.LEVEL_COMPLETE, handleLevelComplete);
            _space.destroy();
        }

        private function handleLevelComplete(event: Event):void
        {
            _player.progress.setLevelResult(_levelsController.currentLevel.id, _space.orders.money, 1);
            _player.progress.save();
        }
    }
}
