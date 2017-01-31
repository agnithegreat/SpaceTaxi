/**
 * Created by agnither on 10.10.16.
 */
package com.holypanda.kosmos.tasks.social
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.global.TaskSystem;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.managers.social.MobileVkontakteSocial;
    import com.holypanda.kosmos.tasks.server.LinkPlayFabTask;

    import starling.events.Event;

    public class VkontakteLoginTask extends SimpleTask
    {
        private var _callback: Function;

        private var _social: MobileVkontakteSocial;
        
        public function VkontakteLoginTask(callback: Function)
        {
            _callback = callback;
            
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            _social = Application.appController.social.getSocial(AuthMethod.VK) as MobileVkontakteSocial;
            _social.addEventListener(MobileVkontakteSocial.LOGIN, handleLogin);
            _social.addEventListener(MobileVkontakteSocial.GET_ME, handleGetMe);

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
            TaskSystem.getInstance().addTask(new LinkPlayFabTask(_social.token, AuthMethod.VK), handleLink);
        }

        private function handleLink():void
        {
            _callback(true);
            complete();
        }
    }
}
