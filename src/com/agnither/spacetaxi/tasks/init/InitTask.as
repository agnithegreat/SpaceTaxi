/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.init
{
    import com.agnither.spacetaxi.Config;
    import com.agnither.spacetaxi.tasks.load.LoadBaseTask;
    import com.agnither.spacetaxi.tasks.resources.LoadResourcesTask;
    import com.agnither.tasks.abstract.MultiTask;

    import flash.desktop.NativeApplication;

    public class InitTask extends MultiTask
    {
        public function InitTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            BUILD::standalone
            {
                var xml : XML = NativeApplication.nativeApplication.applicationDescriptor;
                var ns : Namespace = xml.namespace();
                Config.version = xml.ns::versionNumber;
            }

            addTask(new LoadBaseTask());
            addTask(new LoadResourcesTask("preloader"));
            addTask(new InitPreloaderTask());
            addTask(new InitApplicationTask());
            BUILD::debug
            {
                addTask(new InitReplayTask());
            }

            super.execute(token);
        }
    }
}
