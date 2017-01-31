/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.resources
{
    import com.agnither.tasks.abstract.MultiTask;
    import com.agnither.utils.gui.assets.ResourceManager;

    public class LoadMultipleResourcesTask extends MultiTask
    {
        private var _resourceManager: ResourceManager;
        public function get resourceManager():ResourceManager
        {
            return _resourceManager;
        }
        
        private var _resources: Array;
        
        public function LoadMultipleResourcesTask(resources: Array, resourceManager: ResourceManager = null):void
        {
            _resources = resources;
            _resourceManager = resourceManager || new ResourceManager();
            
            super();
        }
        
        override public function execute(token: Object):void
        {
            for (var i:int = 0; i < _resources.length; i++)
            {
                var task: LoadResourcesTask = new LoadResourcesTask(_resources[i]);
                _resourceManager.addController(task.controller);
                addTask(task);
            }

            super.execute(token);
        }
        
        override protected function dispose():void
        {
            _resourceManager = null;
            
            super.dispose();
        }
    }
}
