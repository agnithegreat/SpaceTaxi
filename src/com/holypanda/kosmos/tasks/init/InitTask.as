/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.init
{
    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.tasks.load.LoadBaseTask;
    import com.holypanda.kosmos.tasks.logic.EnterTask;
    import com.holypanda.kosmos.tasks.resources.LoadResourcesTask;
    import com.holypanda.kosmos.tasks.server.InitPlayFabTask;

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
            addTask(new InitSocialTask());
            addTask(new InitPlayFabTask());
            addTask(new EnterTask());
            
            BUILD::debug
            {
                addTask(new InitReplayTask());
            }

            super.execute(token);
        }
    }
}
