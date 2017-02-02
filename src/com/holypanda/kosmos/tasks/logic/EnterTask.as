/**
 * Created by agnither on 28.09.16.
 */
package com.holypanda.kosmos.tasks.logic
{
    import com.agnither.tasks.abstract.MultiTask;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.managers.Services;
    import com.holypanda.kosmos.managers.windows.LoaderManager;
    import com.holypanda.kosmos.tasks.server.LoginPlayFabTask;
    import com.holypanda.kosmos.tasks.social.FacebookLoginTask;
    import com.holypanda.kosmos.tasks.social.VkontakteLoginTask;
    import com.holypanda.kosmos.utils.LocalStorage;

    public class EnterTask extends MultiTask
    {
        private var _auth: AuthMethod;

        public function EnterTask(auth: AuthMethod = null)
        {
            _auth = auth;
            
            super();
        }
        
        override public function execute(token: Object):void
        {
            LoaderManager.startLoading(toString());
            
            var userId: String = LocalStorage.settings.read("userId") as String;
            if (userId == null)
            {
                userId = Services.deviceId;
                LocalStorage.auth.write("userId", userId);
            }
            
            if (_auth == null)
            {
                var auth: String = LocalStorage.settings.read("auth") as String;
                _auth = auth != null ? AuthMethod[auth] : AuthMethod.GUEST;
            }

            switch (_auth)
            {
                case AuthMethod.GUEST:
                {
                    addTask(new LoginPlayFabTask(userId, _auth));
                    break;
                }
                case AuthMethod.FB:
                {
                    BUILD::mobile
                    {
                        addTask(new FacebookLoginTask());
                    }
                    break;
                }
                case AuthMethod.VK:
                {
                    BUILD::mobile
                    {
                        addTask(new VkontakteLoginTask());
                    }
                    break;
                }
            }

            super.execute(token);
        }

        override protected function processComplete():void
        {
            LoaderManager.stopLoading(toString());
            
            Application.appController.social.update();
            Application.appController.services.initAds();
//            Application.appController.analytics.logCompletedRegistration(_auth.tag);
//            
//            Application.appController.achievements.load();
//            Application.appController.achievements.check();
        }
    }
}
