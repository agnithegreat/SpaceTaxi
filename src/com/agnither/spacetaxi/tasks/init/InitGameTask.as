/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.init
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.view.scenes.game.SpaceView;
    import com.agnither.spacetaxi.view.gui.screens.GameScreen;
    import com.agnither.tasks.abstract.SimpleTask;

    public class InitGameTask extends SimpleTask
    {
        public function InitGameTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            Application.appController.init();
            WindowManager.showScene(new SpaceView(Application.appController.space));
            WindowManager.showScreen(new GameScreen());

            complete();
        }
    }
}
