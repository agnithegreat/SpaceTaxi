/**
 * Created by agnither on 10.10.16.
 */
package com.holypanda.kosmos.tasks.social
{
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.tasks.abstract.SimpleTask;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.managers.social.MobileFacebookSocial;
    import com.holypanda.kosmos.tasks.server.LinkPlayFabTask;
    import com.holypanda.kosmos.tasks.server.LoginPlayFabTask;
    import com.holypanda.kosmos.utils.LocalStorage;

    import starling.events.Event;

    public class FacebookLoginTask extends SimpleTask
    {
        private var _social: MobileFacebookSocial;
        
        public function FacebookLoginTask()
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            _social = Application.appController.social.getSocial(AuthMethod.FB) as MobileFacebookSocial;
            _social.addEventListener(MobileFacebookSocial.LOGIN, handleLogin);
            _social.addEventListener(MobileFacebookSocial.GET_ME, handleGetMe);

            if (!_social.isLogged)
            {
                _social.login();
            } else {
                handleLogin(null);
            }
        }

        private function handleLogin(event: Event):void
        {
            _social.getMe();
        }
        
        private function handleGetMe(event: Event):void
        {
            var userId: String = LocalStorage.auth.read("userId") as String;
            if (userId == _social.me.id)
            {
                TaskSystem.getInstance().addTask(new LoginPlayFabTask(_social.me.id, AuthMethod.FB), complete);
            } else {
                TaskSystem.getInstance().addTask(new LinkPlayFabTask(_social.me.id, AuthMethod.FB), complete);
            }
        }
    }
}