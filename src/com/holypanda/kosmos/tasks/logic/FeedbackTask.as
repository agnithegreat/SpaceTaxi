/**
 * Created by agnither on 25.01.17.
 */
package com.holypanda.kosmos.tasks.logic
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.utils.StringUtils;
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

            var url: String = Application.uiBuilder.localization.getLocalizedText("SurveyLink");
            url = StringUtils.format(url, Config.userId);
            navigateToURL(new URLRequest(url));

            complete();
        }
    }
}
