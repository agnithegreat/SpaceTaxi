/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.load
{
    import com.agnither.spacetaxi.tasks.resources.LoadMultipleResourcesTask;
    import com.agnither.tasks.abstract.MultiTask;

    public class LoadAdditionalTask extends MultiTask
    {
        public function LoadAdditionalTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            addTask(new LoadMultipleResourcesTask(["sounds"]));
            
            addTask(new LoadSwfTask("sounds/sound"));

            super.execute(token);
        }

        override public function get text():String
        {
            return "Loading assets...";
        }
    }
}
