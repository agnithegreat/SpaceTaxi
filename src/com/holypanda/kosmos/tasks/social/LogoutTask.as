/**
 * Created by agnither on 10.10.16.
 */
package com.holypanda.kosmos.tasks.social
{
    import com.agnither.tasks.abstract.SimpleTask;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.social.ISocial;
    import com.holypanda.kosmos.utils.LocalStorage;

    public class LogoutTask extends SimpleTask
    {
        public function LogoutTask()
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            if (Application.appController.social.loggedTo == null) return;
            
            super.execute(token);

            var social: ISocial = Application.appController.social.getSocial(Application.appController.social.loggedTo);
            social.logout();

            LocalStorage.settings.write("userId", null);
            LocalStorage.settings.write("auth", null);

            complete();
        }
    }
}
