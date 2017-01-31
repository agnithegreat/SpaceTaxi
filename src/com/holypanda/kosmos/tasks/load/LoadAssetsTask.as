/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.load
{
    import com.agnither.tasks.abstract.SimpleTask;

    import starling.utils.AssetManager;

    public class LoadAssetsTask extends SimpleTask
    {
        private var _manager: AssetManager;
        private var _files: Array;
        
        public function LoadAssetsTask(manager: AssetManager, files: Array)
        {
            _manager = manager;
            _files = files;
            
            super(null, true);
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);
            
            for (var i:int = 0; i < _files.length; i++)
            {
                _manager.enqueue(_files[i]);
            }
            _manager.loadQueue(progress);
        }
    }
}
