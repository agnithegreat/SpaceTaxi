/**
 * Created by agnither on 13.01.17.
 */
package com.agnither.spacetaxi.model.player
{
    import starling.events.EventDispatcher;

    public class Player extends EventDispatcher
    {
        private var _progress: Progress;
        public function get progress():Progress
        {
            return _progress;
        }
        
        public function Player()
        {
            _progress = new Progress();
        }
        
        public function init():void
        {
            _progress.load();
        }
    }
}
