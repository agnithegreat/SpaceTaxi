/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.controller
{
    import com.agnither.spacetaxi.model.Space;

    import starling.core.Starling;

    public class AppController
    {
        private var _space: Space;
        public function get space():Space
        {
            return _space;
        }
        
        public function AppController()
        {
        }
        
        public function init():void
        {
            _space = new Space();
            _space.init();

            Starling.juggler.add(_space);
        }
    }
}
