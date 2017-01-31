/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.logic.game
{
    import com.holypanda.kosmos.Application;
    import com.agnither.tasks.abstract.SimpleTask;

    public class EndGameTask extends SimpleTask
    {
        public function EndGameTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            Application.appController.states.goBack();
            Application.appController.endGame();

            complete();
        }
    }
}
