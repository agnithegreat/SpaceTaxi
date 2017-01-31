/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.resources
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.tasks.ResourcesVO;
    import com.holypanda.kosmos.tasks.load.LoadAssetsTask;
    import com.agnither.tasks.abstract.MultiTask;
    import com.agnither.utils.gui.assets.ResourceController;
    import com.agnither.utils.gui.assets.AssetsDestructor;

    import starling.events.Event;

    public class LoadResourcesTask extends MultiTask
    {
        private var _controller : ResourceController;
        public function get controller():ResourceController
        {
            return _controller;
        }
        
        private var _group: String;

        public function LoadResourcesTask(group: String)
        {
            _group = group;
            _controller = new ResourceController(group);
            
            super();
        }

        private function addAsset(event: Event):void
        {
            _controller.addAssets(event.data as AssetsDestructor);
        }

        private function removeAsset(event: Event):void
        {
            _controller.removeAssets(event.data as String);
        }
        
        override public function execute(token: Object):void
        {
//            Application.assetsManager.addEventListener(AssetManager.ASSETS_ADDED, addAsset);
//            Application.assetsManager.addEventListener(AssetManager.ASSETS_REMOVED, removeAsset);

            loadNode(ResourcesVO.create(_group));

            super.execute(token);
        }
        
        private function loadNode(resources: ResourcesVO):void
        {
            var root: String = resources.cache ? "./upload/ios" : ".";
            var directory: String = resources.folder != "" ? root + "/" + resources.folder : root;

            if (resources.assets.length > 0)
            {
                var assets: Array = [];
                for (var i:int = 0; i < resources.assets.length; i++)
                {
                    assets.push(directory + "/" + resources.assets[i]);
                }
                trace(assets);
                addTask(new LoadAssetsTask(Application.assetsManager, assets));
            }
        }
        
        override protected function processComplete():void
        {
            _controller.setLoaded();
            
            super.processComplete();
        }
        
        override protected function dispose():void
        {
//            Application.assetsManager.removeEventListener(AssetManager.ASSETS_ADDED, addAsset);
//            Application.assetsManager.removeEventListener(AssetManager.ASSETS_REMOVED, removeAsset);

            _controller = null;
            
            super.dispose();
        }
    }
}
