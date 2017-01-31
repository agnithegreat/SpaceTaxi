/**
 * Created by agnither on 28.09.16.
 */
package com.holypanda.kosmos.tasks.logic
{
    import com.agnither.tasks.abstract.MultiTask;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.managers.windows.LoaderManager;
    import com.holypanda.kosmos.tasks.social.FacebookLoginTask;
    import com.holypanda.kosmos.tasks.social.VkontakteLoginTask;
    import com.holypanda.kosmos.utils.LocalStorage;
    import com.holypanda.kosmos.vo.UserVO;

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
            
            var user: UserVO = new UserVO();

            var userId: String = LocalStorage.settings.read("userId") as String;
            if (userId != null)
            {
                user.id = userId;
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
                    if (user.id != null)
                    {
//                        addTask(new ServerAuthEnterTask(_auth, As2Bert.encBStr(user.id), handleEnter));
                    } else {
//                        addTask(new ServerAuthRegisterTask(handleEnter));
                    }
                    break;
                }
                case AuthMethod.FB:
                {
                    BUILD::mobile
                    {
                        addTask(new FacebookLoginTask(handleEnter));
                    }
                    break;
                }
                case AuthMethod.VK:
                {
                    BUILD::mobile
                    {
                        addTask(new VkontakteLoginTask(handleEnter));
                        // TODO: убрать костыль для ВК
                        LoaderManager.stopLoading(toString());
                    }
                    break;
                }
                case AuthMethod.GP:
                {
                    BUILD::android
                    {
//                        addTask(new GooglePlayLoginTask(handleEnter));
                    }
                    break;
                }
                case AuthMethod.GC:
                {
                    BUILD::ios
                    {
//                        addTask(new GameCenterLoginTask(handleEnter));
                    }
                    break;
                }
            }

            super.execute(token);
        }

        public function handleEnter(success: Boolean):void
        {
            LoaderManager.stopLoading(toString());
            
            if (!success) return;

            Application.appController.social.update();
//            Application.appController.services.initAds();
//            Application.appController.analytics.logCompletedRegistration(_auth.tag);
//            
//            Application.appController.achievements.load();
//            Application.appController.achievements.check();
        }
    }
}
