/**
 * Created by agnither on 10.10.16.
 */
package com.holypanda.kosmos.tasks.social
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.global.TaskSystem;

    import com.dieselpuppet.lotto.Application;
    import com.dieselpuppet.lotto.as2bert.As2Bert;
    import com.dieselpuppet.lotto.managers.social.MobileGameServicesSocial;
    import com.dieselpuppet.lotto.model.ApplicationModel;
    import com.dieselpuppet.lotto.server.AuthMethod;
    import com.dieselpuppet.lotto.tasks.server.auth.ServerAuthEnterTask;
    import com.dieselpuppet.lotto.vo.User;

    import starling.events.Event;

    public class GooglePlayLoginTask extends SimpleTask
    {
        private var _user: User;
        private var _callback: Function;

        private var _social: MobileGameServicesSocial;
        
        public function GooglePlayLoginTask(user: User, callback: Function)
        {
            _user = user;
            _callback = callback;
            
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            _social = Application.appController.social.getSocial(AuthMethod.GP) as MobileGameServicesSocial;
            _social.addEventListener(MobileGameServicesSocial.READY, handleReady);
            _social.addEventListener(MobileGameServicesSocial.LOGIN, handleLogin);

            if (_social.ready)
            {
                handleReady(null);
            }
        }
        
        private function handleReady(event: Event):void
        {
            if (!_social.isLogged)
            {
                _social.login();
            } else {
                handleLogin(null);
            }
        }

        private function handleLogin(event: Event):void
        {
            _social.addEventListener(MobileGameServicesSocial.GET_AUTH, handleGetAuth);
            _social.getAuth();
        }

        private function handleGetAuth(event: Event):void
        {
            _user.id = _social.player.id;
            _user.name = _social.player.displayName;
            _user.avatarUrl = _social.avatar;

            TaskSystem.getInstance().addTask(new ServerAuthEnterTask(AuthMethod.GP, _user.encode(), _callback));
            complete();
        }
    }
}
