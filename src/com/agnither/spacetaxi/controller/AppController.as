/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.controller
{
    import com.agnither.spacetaxi.model.Space;

    import starling.core.Starling;

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
        
        private var _space: Space;
        public function get space():Space
        {
            return _space;
        }
        
        public function AppController()
        {
            _stateController = new StateController();
            _levelsController = new LevelsController();
            
            _space = new Space();
        }
        
        public function init():void
        {
            _stateController.init();
            _levelsController.init();
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
            Starling.juggler.add(_space);
        }

        public function restartGame():void
        {
            _space.restart(_levelsController.currentLevel);
        }

        public function endGame():void
        {
            Starling.juggler.remove(_space);
            _space.destroy();
        }
    }
}
