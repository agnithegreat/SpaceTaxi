/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.logic
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.tasks.abstract.SimpleTask;

    public class StartGameTask extends SimpleTask
    {
        public function StartGameTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            Application.appController.startGame();
            Application.appController.states.gameState();

            complete();
        }
    }
}
