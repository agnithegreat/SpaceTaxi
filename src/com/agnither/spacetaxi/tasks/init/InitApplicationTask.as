/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.init
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.Config;
    import com.agnither.spacetaxi.tasks.load.LoadAdditionalTask;
    import com.agnither.tasks.abstract.MultiTask;

    import dragonBones.starling.StarlingFactory;

    import flash.system.Capabilities;

    import starlingbuilder.engine.localization.DefaultLocalization;

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
            
            var locale: String = Config.localization_map[Capabilities.language];
            Application.uiBuilder.localization = new DefaultLocalization(Application.assetsManager.getObject("strings"), locale);
            
            Application.appController.init();
            Application.appController.states.mainState();

            super.processComplete();
        }
    }
}
