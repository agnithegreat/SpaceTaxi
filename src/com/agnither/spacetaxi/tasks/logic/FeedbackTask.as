/**
 * Created by agnither on 25.01.17.
 */
package com.agnither.spacetaxi.tasks.logic
{
    import com.agnither.spacetaxi.Config;
    import com.agnither.tasks.abstract.SimpleTask;

    import flash.net.URLRequest;
    import flash.net.navigateToURL;

    public class FeedbackTask extends SimpleTask
    {
        public function FeedbackTask():void
        {
            super();
        }

        override public function execute(token: Object):void
        {
            super.execute(token);

            var url: String = Config.feedbackLink.replace("%user_id%", Config.userId);
            navigateToURL(new URLRequest(url));

            complete();
        }
    }
}
