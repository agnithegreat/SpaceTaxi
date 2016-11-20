/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.init
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.tasks.load.LoadAdditionalTask;
    import com.agnither.spacetaxi.view.SpaceView;
    import com.agnither.tasks.abstract.MultiTask;

    import dragonBones.starling.StarlingFactory;

    public class InitApplicationTask extends MultiTask
    {
        public function InitApplicationTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            addTask(new LoadAdditionalTask());

            super.execute(token);
        }

        override protected function processComplete():void
        {
            StarlingFactory.factory.parseDragonBonesData(
                Application.assetsManager.getObject("ship_skeleton")
            );
            StarlingFactory.factory.parseTextureAtlasData(
                Application.assetsManager.getObject("ship_texture"),
                Application.assetsManager.getTexture("ship_texture")
            );

            Application.appController.init();
            Application.viewport.addChild(new SpaceView(Application.appController.space));

            super.processComplete();
        }
    }
}
