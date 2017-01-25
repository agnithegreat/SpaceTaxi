/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.init
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.tasks.resources.LoadResourcesTask;
    import com.agnither.spacetaxi.view.gui.screens.PreloaderScreen;
    import com.agnither.tasks.abstract.MultiTask;
    import com.agnither.tasks.abstract.SimpleTask;

    public class InitPreloaderTask extends MultiTask
    {
        public function InitPreloaderTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            Application.splash.parent.removeChild(Application.splash);
            Application.splash.bitmapData = null;
            Application.splash = null;

            var task: SimpleTask = new LoadResourcesTask("common");
            WindowManager.showScreen(new PreloaderScreen(task));

            addTask(task);

            super.execute(token);
        }
    }
}
