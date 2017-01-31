/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.init
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.managers.analytics.GamePlayAnalytics;
    import com.holypanda.kosmos.tasks.logic.game.StartGameTask;
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.global.TaskSystem;

    public class InitReplayTask extends SimpleTask
    {
        public function InitReplayTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            if (Config.replay != null)
            {
                GamePlayAnalytics.importData(Config.replay);
                Application.appController.selectLevel(GamePlayAnalytics.level);
                TaskSystem.getInstance().addTask(new StartGameTask());
                GamePlayAnalytics.replay(Application.appController.space);
            }

            complete();
        }
    }
}
