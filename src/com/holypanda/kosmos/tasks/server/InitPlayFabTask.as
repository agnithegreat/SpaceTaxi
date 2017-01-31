/**
 * Created by agnither on 30.01.17.
 */
package com.holypanda.kosmos.tasks.server
{
    import com.agnither.tasks.abstract.SimpleTask;

    import com.playfab.PlayFabSettings;

    public class InitPlayFabTask extends SimpleTask
    {
        public function InitPlayFabTask()
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            PlayFabSettings.TitleId = "C5B9";
            
            complete();
        }
    }
}
