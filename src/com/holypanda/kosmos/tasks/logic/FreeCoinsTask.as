/**
 * Created by agnither on 02.02.17.
 */
package com.holypanda.kosmos.tasks.logic
{
    import com.agnither.tasks.abstract.SimpleTask;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.controller.ServicesController;

    import starling.events.Event;

    public class FreeCoinsTask extends SimpleTask
    {
        public function FreeCoinsTask()
        {
            super();
        }

        override public function execute(token: Object):void
        {
            super.execute(token);

            var now: Number = (new Date()).time;
            if (Application.appController.services.rewardedVideoInfo.check(now))
            {
                Application.appController.services.showRewardedVideo();
                Application.appController.services.addEventListener(ServicesController.REWARDED_VIDEO, handleRewardedVideo);
            }
        }

        private function handleRewardedVideo(event: Event):void
        {
            Application.appController.services.removeEventListener(ServicesController.REWARDED_VIDEO, handleRewardedVideo);
            
            if (event.data)
            {
                // TODO: customize it
                Application.appController.player.addMoney(1000);
                Application.appController.player.save();
                
                var now: Number = (new Date()).time;
                Application.appController.services.rewardedVideoInfo.cleanUp(now);
                Application.appController.services.rewardedVideoInfo.add(now);
                Application.appController.services.rewardedVideoInfo.save();
            }
            
            complete();
        }
    }
}
