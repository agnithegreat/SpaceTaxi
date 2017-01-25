/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.logic.game
{
    import com.agnither.spacetaxi.Application;
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
