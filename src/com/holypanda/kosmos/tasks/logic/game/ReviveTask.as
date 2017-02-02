/**
 * Created by agnither on 02.02.17.
 */
package com.holypanda.kosmos.tasks.logic.game
{
    import com.agnither.tasks.abstract.SimpleTask;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.controller.ServicesController;

    import starling.events.Event;

    public class ReviveTask extends SimpleTask
    {
        public function ReviveTask()
        {
            super();
        }

        override public function execute(token: Object):void
        {
            super.execute(token);

            Application.appController.services.showRewardedVideo();
            Application.appController.services.addEventListener(ServicesController.REWARDED_VIDEO, handleRewardedVideo);
        }

        private function handleRewardedVideo(event: Event):void
        {
            Application.appController.services.removeEventListener(ServicesController.REWARDED_VIDEO, handleRewardedVideo);
            
            Application.appController.reviveGame(event.data);

            complete();
        }
    }
}
