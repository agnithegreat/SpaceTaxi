/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 12.06.13
 * Time: 1:34
 * To change this template use File | Settings | File Templates.
 */
package com.holypanda.kosmos.managers.social
{
    import com.holypanda.kosmos.utils.logger.Logger;

    import starling.events.EventDispatcher;

    public class MobileGameCenterSocial extends EventDispatcher implements ISocial
    {
        public static const INIT_SUCCESS: String = "MobileGameCenterSocial.INIT_SUCCESS";
        public static const READY: String = "MobileGameCenterSocial.READY";
        public static const LOGIN: String = "MobileGameCenterSocial.LOGIN";
        public static const LOGIN_FAIL: String = "MobileGameCenterSocial.LOGIN_FAIL";
        public static const LOGOUT: String = "MobileGameCenterSocial.LOGOUT";
        
        private var _gameCenter: GameCenterController;

        private var _logged: Boolean;

        public function get isInitiated():Boolean
        {
            return _gameCenter != null;
        }

        public function get isLogged():Boolean
        {
            return _logged && isInitiated && _gameCenter.authenticated;
        }

        public function get player():GameCenterPlayer
        {
            return _gameCenter.localPlayer;
        }
        
        public function init():void
        {
            _gameCenter = new GameCenterController();
            _gameCenter.addEventListener(GameCenterAuthenticationEvent.PLAYER_AUTHENTICATED, handleLogin);
        }

        public function login():void
        {
            Logger.log("[Game Center] " + "autenticated = " + _gameCenter.authenticated);
            if (_gameCenter.authenticated)
            {
                handleLogin(null);
            } else {
                _gameCenter.authenticate();
            }
        }

        public function logout():void
        {
            _logged = false;
        }
        
        public function invite(link: String, imageLink: String, callback: Function):Boolean
        {
            return false;
        }

        public function achievementUnlock(id: String):void
        {
            _gameCenter.submitAchievement(id, 100);
        }

        private function handleLogin(event: GameCenterAuthenticationEvent):void
        {
            Logger.log("[Game Center] " + "logged");
            _logged = true;
            dispatchEventWith(LOGIN);
        }

        public function join(id: uint, callback:Function):void
        {
        }

        public function inviteFriends(uids:String, text:String, callback:Function):void
        {
        }

        public function get friends():Array
        {
            return null;
        }

        public function get friendsInApp():int
        {
            return 0;
        }

        public function get friendsTotal():int
        {
            return 0;
        }

        public function get inviteList():Boolean
        {
            return false;
        }

        public function get inviteMultiMode():Boolean
        {
            return false;
        }
    }
}
