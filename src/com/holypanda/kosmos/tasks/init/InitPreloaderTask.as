/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.init
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.tasks.resources.LoadResourcesTask;
    import com.holypanda.kosmos.view.gui.screens.PreloaderScreen;
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
            if (Application.splash != null)
            {
                Application.splash.parent.removeChild(Application.splash);
                Application.splash.bitmapData = null;
                Application.splash = null;
            }

            var task: SimpleTask = new LoadResourcesTask("common");
            WindowManager.showScreen(new PreloaderScreen(task));

            addTask(task);

            super.execute(token);
        }
    }
}
