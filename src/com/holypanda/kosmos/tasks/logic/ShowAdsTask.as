/**
 * Created by agnither on 02.02.17.
 */
package com.holypanda.kosmos.tasks.logic
{
    import com.agnither.tasks.abstract.SimpleTask;

    import com.holypanda.kosmos.Application;

    public class ShowAdsTask extends SimpleTask
    {
        public function ShowAdsTask()
        {
            super();
        }

        override public function execute(token: Object):void
        {
            super.execute(token);

            if (Application.appController.player.noAds)
            {
                complete();
                return;
            }

            Application.appController.services.count++;

            if (Application.appController.services.count < 5 || !Application.appController.space.win)
            {
                complete();
                return;
            }

            Application.appController.services.count = 0;

            Application.appController.services.showInterstitial();
            
            complete();
        }
    }
}
