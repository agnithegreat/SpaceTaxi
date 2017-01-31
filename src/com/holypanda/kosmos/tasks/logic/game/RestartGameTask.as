/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.logic.game
{
    import com.holypanda.kosmos.Application;
    import com.agnither.tasks.abstract.SimpleTask;

    public class RestartGameTask extends SimpleTask
    {
        public function RestartGameTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            Application.appController.restartGame();
            
            complete()
        }
    }
}
