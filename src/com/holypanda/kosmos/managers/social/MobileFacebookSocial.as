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

    import com.myflashlab.air.extensions.facebook.FB;
    import com.myflashlab.air.extensions.facebook.FBEvent;
    import com.myflashlab.air.extensions.facebook.access.Auth;
    import com.myflashlab.air.extensions.facebook.access.Permissions;

    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    import starling.events.EventDispatcher;

    public class MobileFacebookSocial extends EventDispatcher implements ISocial
    {
        public static const LOGIN: String = "MobileFacebookSocial.LOGIN";
        public static const LOGIN_FAIL: String = "MobileFacebookSocial.LOGIN_FAIL";
        public static const GET_ME: String = "MobileFacebookSocial.GET_ME";
        public static const GET_FRIENDS: String = "MobileFacebookSocial.GET_FRIENDS";
        public static const LOGOUT: String = "MobileFacebookSocial.LOGOUT";
        
        private var _facebook: FB;
        public function get isInitiated():Boolean
        {
            return _facebook != null;
        }
        
        public function get isLogged():Boolean
        {
            return isInitiated && FB.auth.isLogin;
        }
        
        public function get token():String
        {
            return FB.auth.token;
        }
        
        private var _me: Object;
        public function get me():Object
        {
            return _me;
        }

        private var _friends: Array;
        public function get friends():Array
        {
            return _friends;
        }

        public function getPhotoUrl(uid: String):String
        {
            return "http://graph.facebook.com/"+uid+"/picture";
        }

        public function init():void
        {
            _facebook = FB.getInstance(Config.FACEBOOK_APP_ID);

            BUILD::debug
            {
                Logger.log("Facebook Key Hash:", FB.hashKey);
            }
        }

        public function login():void
        {
            FB.auth.addEventListener(FBEvent.LOGIN_DONE, handleLoginDone);
            FB.auth.addEventListener(FBEvent.LOGIN_CANCELED, handleLoginCancelled);
            FB.auth.addEventListener(FBEvent.LOGIN_ERROR, handleLoginError);
            FB.auth.requestPermission(Auth.WITH_READ_PERMISSIONS, Permissions.public_profile, Permissions.user_friends);
        }

        public function logout():void
        {
            FB.auth.logout();
        }

        public function getMe():void
        {
            FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE, handleGetMeSuccess);
            FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE_ERROR, handleGetMeError);
            FB.graph.call("https://graph.facebook.com/v2.8/me", URLRequestMethod.GET, new URLVariables("fields=id,first_name,last_name,installed"));
        }

        public function getFriends():void
        {
            if (isLogged)
            {
                FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE, handleGetFriendsSuccess);
                FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE_ERROR, handleGetFriendsError);
                FB.graph.call("https://graph.facebook.com/v2.8/me/friends", URLRequestMethod.GET, new URLVariables("fields=id,first_name,last_name,installed"));
            }
        }

        public function invite(link: String, imageLink: String, callback: Function):Boolean
        {
            FB.appInvite("https://fb.me/1265077526904299", "https://lh3.googleusercontent.com/CAR3f7Agmcd4rMRiZqIRr9uqk2cYA-6DPKyjCM4brfIKQoXQykVmRx2vN-OFOKrvrbQ=w300-rw", callback);
            return true;
        }

        public function loadPhoto(uid: String, width: int, height: int):PhotoLoader
        {
            return PhotoLoader.loadPhoto(getPhotoUrl(uid) + "?width="+width+"&height="+height);
        }

        protected function handleLoginDone(event: FBEvent):void
        {
            dispatchEventWith(LOGIN);
        }

        protected function handleLoginCancelled(event: FBEvent):void
        {
            dispatchEventWith(LOGIN_FAIL);
        }

        protected function handleLoginError(event: FBEvent):void
        {
            dispatchEventWith(LOGIN_FAIL);
        }

        private function handleGetMeSuccess(event: FBEvent):void
        {
            FB.graph.removeEventListener(FBEvent.GRAPH_RESPONSE, handleGetMeSuccess);
            FB.graph.removeEventListener(FBEvent.GRAPH_RESPONSE_ERROR, handleGetMeError);

            _me = JSON.parse(event.param);
            dispatchEventWith(GET_ME);
        }

        private function handleGetMeError(event:FBEvent):void
        {
            FB.graph.removeEventListener(FBEvent.GRAPH_RESPONSE, handleGetMeSuccess);
            FB.graph.removeEventListener(FBEvent.GRAPH_RESPONSE_ERROR, handleGetMeError);
        }

        private function handleGetFriendsSuccess(event: FBEvent):void
        {
            FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE, handleGetFriendsSuccess);
            FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE_ERROR, handleGetFriendsError);

            _friends = [];
//            JSON.parse(event.param);
            dispatchEventWith(GET_FRIENDS);
        }

        private function handleGetFriendsError(event:FBEvent):void
        {
            FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE, handleGetFriendsSuccess);
            FB.graph.addEventListener(FBEvent.GRAPH_RESPONSE_ERROR, handleGetFriendsError);
        }

        public function join(id:uint, callback:Function):void
        {
        }

        public function inviteFriends(uids:String, text:String, callback:Function):void
        {
        }

        public function achievementUnlock(id:String):void
        {
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
