/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.load
{
    import com.holypanda.kosmos.Application;
    import com.agnither.tasks.abstract.MultiTask;
    import com.agnither.utils.gui.Resources;

    public class LoadBaseTask extends MultiTask
    {
        public function LoadBaseTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            addTask(new LoadAssetsTask(Application.assetsManager, [
                "config/resources.json"
            ]));
            
            super.execute(token);
        }

        override protected function processComplete():void
        {
            Resources.commonAssets = Application.assetsManager;

            super.processComplete();
        }
    }
}
