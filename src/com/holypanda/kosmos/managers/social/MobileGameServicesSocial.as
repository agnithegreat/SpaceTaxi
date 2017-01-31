/**
 * Created with IntelliJ IDEA.
 * User: agnithegreat
 * Date: 12.06.13
 * Time: 1:34
 * To change this template use File | Settings | File Templates.
 */
package com.holypanda.kosmos.managers.social
{
    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.utils.logger.Logger;

    import com.myflashlab.air.extensions.gameServices.GameServices;
    import com.myflashlab.air.extensions.gameServices.google.events.AuthEvents;
    import com.myflashlab.air.extensions.gameServices.google.player.Player;
    import com.myflashlab.air.extensions.gameServices.google.player.PlayerLevel;
    import com.myflashlab.air.extensions.nativePermissions.PermissionCheck;

    import starling.events.EventDispatcher;

    public class MobileGameServicesSocial extends EventDispatcher implements ISocial
    {
        public static const INIT_SUCCESS: String = "MobileGameServicesSocial.INIT_SUCCESS";
        public static const READY: String = "MobileGameServicesSocial.READY";
        public static const LOGIN: String = "MobileGameServicesSocial.LOGIN";
        public static const LOGIN_FAIL: String = "MobileGameServicesSocial.LOGIN_FAIL";
        public static const LOGOUT: String = "MobileGameServicesSocial.LOGOUT";

        private var _exPermissions: PermissionCheck = new PermissionCheck();
        private var _permissionsGranted: Boolean;

        private var _isInitiated: Boolean;
        public function get isInitiated():Boolean
        {
            return _isInitiated;
        }
        
        private var _ready: Boolean;
        public function get ready():Boolean
        {
            return _ready;
        }
        
        private var _isSilent: Boolean;
        public function get isSilent():Boolean
        {
            return _isSilent;
        }

        public function get isLogged():Boolean
        {
            return isInitiated && GameServices.google.auth.isLogin;
        }

        public function get player():Player
        {
            return GameServices.google.players.currentPlayer;
        }
        
        private var _waitLogin: Boolean;
        public function get waitLogin():Boolean
        {
            return _waitLogin;
        }

        public function init():void
        {
            if (!_permissionsGranted)
            {
                checkPermissions();
                return;
            }

            GameServices.init(!Config.debug);
            GameServices.google.auth.addEventListener(AuthEvents.INIT, handleInit);
        }

        private function checkPermissions():void
        {
            checkForStorage();

            function checkForStorage():void
            {
                var permissionState:int = _exPermissions.check(PermissionCheck.SOURCE_STORAGE);

                if (permissionState == PermissionCheck.PERMISSION_UNKNOWN || permissionState == PermissionCheck.PERMISSION_DENIED)
                {
                    _exPermissions.request(PermissionCheck.SOURCE_STORAGE, onStorageRequestResult);
                } else {
                    checkForContacts();
                }
            }
            function onStorageRequestResult($state:int):void
            {
                if ($state != PermissionCheck.PERMISSION_GRANTED)
                {
                    Logger.log(this, "You did not allow the app the required permissions!");
                } else {
                    checkForContacts();
                }
            }
            function checkForContacts():void
            {
                var permissionState:int = _exPermissions.check(PermissionCheck.SOURCE_CONTACTS);

                if (permissionState == PermissionCheck.PERMISSION_UNKNOWN || permissionState == PermissionCheck.PERMISSION_DENIED)
                {
                    _exPermissions.request(PermissionCheck.SOURCE_CONTACTS, onContactsRequestResult);
                } else {
                    _permissionsGranted = true;
                    init();
                }
            }
            function onContactsRequestResult($state:int):void
            {
                if ($state != PermissionCheck.PERMISSION_GRANTED)
                {
                    Logger.log(this, "You did not allow the app the required permissions!");
                } else {
                    _permissionsGranted = true;
                    init();
                }
            }
        }

        public function login():void
        {
            _waitLogin = true;
            GameServices.google.auth.login();
        }

        public function logout():void
        {
            GameServices.google.auth.logout();
        }
        
        public function invite(link: String, imageLink: String, callback: Function):Boolean
        {
            return false;
        }

        public function achievementUnlock(id: String):void
        {
            GameServices.google.achievements.unlock(id, true);
        }

        private function handleInit(event: AuthEvents):void
        {
            var result:String;

            switch (event.status) // status code indicating whether Game Services can run in your app or not. It can be one of following results:
            {
                case GameServices.SUCCESS:
                {
                    result = "GameServices.SUCCESS";
                    handleSuccessfulInit();
                    break;
                }
                case GameServices.SERVICE_MISSING:
                {
                    result = "GameServices.SERVICE_MISSING";
                    break;
                }
                case GameServices.SERVICE_UPDATING:
                {
                    result = "GameServices.SERVICE_UPDATING";
                    break;
                }
                case GameServices.SERVICE_VERSION_UPDATE_REQUIRED:
                {
                    result = "GameServices.SERVICE_VERSION_UPDATE_REQUIRED";
                    break;
                }
                case GameServices.SERVICE_DISABLED:
                {
                    result = "GameServices.SERVICE_DISABLED";
                    break;
                }
                case GameServices.SERVICE_INVALID:
                {
                    result = "GameServices.SERVICE_INVALID";
                    break;
                }
                default:
                {

                }
            }

            Logger.log("onInit result = " + result);
        }

        private function handleSuccessfulInit():void
        {
            _isInitiated = true;

            GameServices.google.auth.addEventListener(AuthEvents.TRYING_SILENT_LOGIN,       handleSilentTry);
            GameServices.google.auth.addEventListener(AuthEvents.LOGIN,                     handleLoginDone);
            GameServices.google.auth.addEventListener(AuthEvents.LOGOUT,                    handleLogout);
            GameServices.google.auth.addEventListener(AuthEvents.ERROR,                     handleLoginError);
            GameServices.google.auth.addEventListener(AuthEvents.CANCELED,                  handleLoginCancelled);
            GameServices.google.auth.addEventListener(AuthEvents.SETTING_WINDOW_DISMISSED,  handleSettingWindowDismissed);

            dispatchEventWith(INIT_SUCCESS);
        }

        private function handleSilentTry(event: AuthEvents):void
        {
            Logger.log("canDoSilentLogin = ", event.canDoSilentLogin);
            Logger.log("If silent try is \"false\", it means that you have to login the user yourself using the \"GameServices.login();\" method.");
            Logger.log("But if it's \"true\", it means that the user had signed in before and he will be signed in again silently shortly. and you have to wait for the \"AuthEvents.LOGIN\" event.");

            if (event.canDoSilentLogin)
            {
                _isSilent = true;
                Logger.log("connecting to Game Services, please wait...");
            } else {
                _ready = true;
                dispatchEventWith(READY);
            }
        }

        private function handleLoginDone(event: AuthEvents):void
        {
            _waitLogin = false;
            Logger.log("onLoginSuccess");

            // some information about current logged in user.
            Logger.log("displayName = " +                event.player.displayName);
            Logger.log("id = " +                         event.player.id);
            if (event.player.lastLevelUpTimestamp) // it will be null if the player has not leveled up yet!
            {
                Logger.log("lastLevelUpTimestamp = " +   event.player.lastLevelUpTimestamp.toLocaleString());
            }
            Logger.log("title = " +                      event.player.title);
            Logger.log("xp = " +                         event.player.xp);

            var currLevel:PlayerLevel = event.player.currentLevel;
            Logger.log("currLevel.levelNumber = " +      currLevel.levelNumber);
            Logger.log("currLevel.minXp = " +            currLevel.minXp);
            Logger.log("currLevel.maxXp = " +            currLevel.maxXp);

            var nextLevel:PlayerLevel = event.player.nextLevel;
            Logger.log("nextLevel.levelNumber = " +      nextLevel.levelNumber);
            Logger.log("nextLevel.minXp = " +            nextLevel.minXp);
            Logger.log("nextLevel.maxXp = " +            nextLevel.maxXp);

            /*
             When you are logged in, you can use all the other APIs.
             Please refer to the tutorials section to know how you should
             use other features of the Game Services ANE.
             */
            dispatchEventWith(LOGIN);
        }

        private function handleLogout(event: AuthEvents):void
        {
            Logger.log("handleLogout");
            dispatchEventWith(LOGOUT);
        }

        private function handleLoginError(event: AuthEvents):void
        {
            Logger.log("handleLoginError: ", event.msg);
            dispatchEventWith(LOGIN_FAIL);
        }

        private function handleLoginCancelled(event: AuthEvents):void
        {
            Logger.log("handleLoginCancelled: ", event.msg);
            dispatchEventWith(LOGIN_FAIL);
        }

        private function handleSettingWindowDismissed(event: AuthEvents):void
        {
            Logger.log("handleSettingWindowDismissed");
            dispatchEventWith(LOGIN_FAIL);
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
