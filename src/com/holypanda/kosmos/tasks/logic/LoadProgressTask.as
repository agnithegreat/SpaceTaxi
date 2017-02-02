/**
 * Created by agnither on 02.02.17.
 */
package com.holypanda.kosmos.tasks.logic
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.global.TaskSystem;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.model.player.Player;
    import com.holypanda.kosmos.tasks.server.LoadUserDataPlayFabTask;
    import com.holypanda.kosmos.tasks.server.vo.UserDataVO;

    public class LoadProgressTask extends SimpleTask
    {
        public function LoadProgressTask()
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            var task: LoadUserDataPlayFabTask = new LoadUserDataPlayFabTask();
            TaskSystem.getInstance().addTask(task, function onComplete():void
            {
                var player: Player = Application.appController.player;
                player.init(task.result as UserDataVO);

                complete();
            });
        }
    }
}
