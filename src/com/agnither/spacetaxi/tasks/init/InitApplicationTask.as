/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.init
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.tasks.load.LoadAdditionalTask;
    import com.agnither.spacetaxi.view.scenes.game.SpaceView;
    import com.agnither.spacetaxi.view.gui.screens.MainScreen;
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
            WindowManager.showScene(new SpaceView(Application.appController.space));
            WindowManager.showScreen(new MainScreen());

            super.processComplete();
        }
    }
}
