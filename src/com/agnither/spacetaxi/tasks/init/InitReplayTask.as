/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.init
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.Config;
    import com.agnither.spacetaxi.managers.analytics.GamePlayAnalytics;
    import com.agnither.spacetaxi.tasks.logic.StartGameTask;
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
