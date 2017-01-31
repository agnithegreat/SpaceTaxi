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
    import com.holypanda.kosmos.vo.FriendVO;

    import com.marpies.ane.vk.VK;
    import com.marpies.ane.vk.VKPermissions;
    import com.marpies.ane.vk.VKRequest;

    import starling.events.EventDispatcher;

    public class MobileVkontakteSocial extends EventDispatcher implements ISocial
    {
        public static const LOGIN: String = "MobileVkontakteSocial.LOGIN";
        public static const LOGIN_FAIL: String = "MobileVkontakteSocial.LOGIN_FAIL";
        public static const GET_ME: String = "MobileVkontakteSocial.GET_ME";
        public static const GET_FRIENDS: String = "MobileVkontakteSocial.GET_FRIENDS";
        public static const GET_APP_FRIENDS: String = "MobileVkontakteSocial.GET_APP_FRIENDS";
        public static const LOGOUT: String = "MobileVkontakteSocial.LOGOUT";
        
        public function get isInitiated():Boolean
        {
            return true;
        }

        private var _isLogged: Boolean;
        public function get isLogged():Boolean
        {
            return isInitiated && VK.isLoggedIn;
        }
        
        public function get token():String
        {
            return VK.accessToken.accessToken;
        }
        
        private var _me: Object;
        public function get me():Object
        {
            return _me;
        }

        private var _friendsInApp: int;
        public function get friendsInApp():int
        {
            return _friendsInApp;
        }

        private var _friendsTotal: int;
        public function get friendsTotal():int
        {
            return _friendsTotal;
        }

        private var _friends: Array;
        public function get friends():Array
        {
            return _friends;
        }

        public function init():void
        {
            VK.addAccessTokenUpdateCallback(onAccessTokenUpdated);
            VK.init("5848274", true);

            function onAccessTokenUpdated():void
            {
                var logged: Boolean = _isLogged;
                _isLogged = VK.accessToken != null;

                if (!logged && _isLogged)
                {
                    handleLoginResult(null);
                }
            }
        }

        public function login():void
        {
            VK.authorize(new <String>[VKPermissions.FRIENDS, VKPermissions.GROUPS], handleLoginResult);
        }

        public function logout():void
        {
            VK.logout();
        }

        public function getMe():void
        {
            VK.request
                    .setMethod("users.get")
                    .setParameters({
                        fields  : "photo_max"
                    })
                    .setResponseCallback(handleGetMeSuccess)
                    .setErrorCallback(handleGetMeError)
                    .send();
        }

        public function getFriends():void
        {
            VK.request
                    .setMethod("friends.get")
                    .setParameters({
                    })
                    .setResponseCallback(handleGetFriendsSuccess)
                    .setErrorCallback(handleGetFriendsError)
                    .send();
        }

        public function getAppFriends():void
        {
            VK.request
                    .setMethod("friends.getAppUsers")
                    .setParameters({
                    })
                    .setResponseCallback(handleGetAppFriendsSuccess)
                    .setErrorCallback(handleGetAppFriendsError)
                    .send();
        }

        public function invite(link: String, image: String, callback: Function):Boolean
        {
            return false;
        }

        public function getFriendsList(callback: Function):void
        {
            VK.request
                    .setMethod("apps.getFriendsList")
                    .setParameters({
                        fields  : "city,last_seen,crop_photo,online",
                        type    : "invite",
                        count   : 100,
                        extended: 1
                    })
                    .setResponseCallback(function (response: Object, originalRequest: VKRequest):void
                    {
                        _friends = [];
                        for (var i:int = 0; i < response.items.length; i++)
                        {
                            var item: Object = response.items[i];
                            var friend: FriendVO = new FriendVO();
                            friend.avatarUrl = item.crop_photo != null ? item.crop_photo.photo.photo_130 : null;
                            friend.city = item.city != null ? item.city.title : null;
                            friend.name = item.first_name + " " + item.last_name;
                            friend.online = item.online == 1;
                            friend.platform = item.last_seen != null ? item.last_seen.platform : 0;
                            friend.uid = item.id;
                            _friends.push(friend);
                        }
                        _friends.sortOn("rank", Array.NUMERIC);

                        callback(true);
                    })
                    .setErrorCallback(function (error: String):void
                    {
                        callback(false);
                    })
                    .send();
        }

        public function inviteFriends(userId: String, text: String, callback: Function):void
        {
            VK.request
                    .setMethod("apps.sendRequest")
                    .setParameters({
                        "user_id": userId,
                        "text": text,
                        "key": "invite",
                        "type": "invite"
                    })
                    .setResponseCallback(function (response: Object, originalRequest: VKRequest):void
                    {
                        callback(true);
                    })
                    .setErrorCallback(function (error: String):void
                    {
                        callback(false);
                    })
                    .send();
        }

        public function join(id: uint, callback: Function):void
        {
            VK.request
                    .setMethod("groups.join")
                    .setParameters({
                        "group_id": id
                    })
                    .setResponseCallback(function (response: Object, originalRequest: VKRequest):void
                    {
                        callback(true);
                    })
                    .setErrorCallback(function (error: String):void
                    {
                        callback(false);
                    })
                    .send();
        }

        protected function handleLoginResult(errorMessage: String):void
        {
            Logger.log("handleLoginResult");
            if (errorMessage != null)
            {
                Logger.log("login error:", errorMessage);
                dispatchEventWith(LOGIN_FAIL);
            } else {
                dispatchEventWith(LOGIN);
            }
        }

        private function handleGetMeSuccess(response: Object, originalRequest: VKRequest):void
        {
            Logger.log("handleGetMeSuccess");
            _me = response[0];
            dispatchEventWith(GET_ME);
        }

        private function handleGetMeError(error: String):void
        {
            Logger.log("get me error:", error);
        }

        private function handleGetFriendsSuccess(response: Object, originalRequest: VKRequest):void
        {
            Logger.log("handleGetFriendsSuccess");
            _friendsTotal = response.items.length;
            dispatchEventWith(GET_FRIENDS);
        }

        private function handleGetFriendsError(error: String):void
        {
            Logger.log("get friends error:", error);
        }

        private function handleGetAppFriendsSuccess(response: Object, originalRequest: VKRequest):void
        {
            Logger.log("handleGetAppFriendsSuccess");
            _friendsInApp = response.length;
            dispatchEventWith(GET_APP_FRIENDS);
        }

        private function handleGetAppFriendsError(error: String):void
        {
            Logger.log("get app friends error:", error);
        }

        public function achievementUnlock(id:String):void
        {
        }

        public function get inviteList():Boolean
        {
            return true;
        }

        public function get inviteMultiMode():Boolean
        {
            return false;
        }
    }
}
