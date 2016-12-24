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
        
        private var _space: Space;
        public function get space():Space
        {
            return _space;
        }
        
        public function AppController()
        {
            _stateController = new StateController();
            
            _space = new Space();
        }
        
        public function init():void
        {
            _stateController.init();
        }
        
        public function startGame():void
        {
            _space.init();
            Starling.juggler.add(_space);
        }

        public function endGame():void
        {
            Starling.juggler.remove(_space);
            _space.destroy();
        }
    }
}
