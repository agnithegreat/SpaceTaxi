package com.holypanda.kosmos.controller
{
    import com.holypanda.kosmos.managers.social.ISocial;
    import com.holypanda.kosmos.enums.AuthMethod;

    import flash.utils.Dictionary;

    import starling.events.EventDispatcher;

    public class SocialController extends EventDispatcher
    {
        public static const UPDATE: String = "SocialController.UPDATE";
        
        private var _social: Dictionary;
        public function getSocial(auth: AuthMethod):ISocial
        {
            return _social[auth];
        }

        public function isLogged(auth: AuthMethod):Boolean
        {
            var social: ISocial = getSocial(auth);
            return social && social.isLogged;
        }

        public function canLogin(auth: AuthMethod):Boolean
        {
            var social: ISocial = getSocial(auth);
            return social && !social.isLogged;
        }
        
        public function get loggedTo():AuthMethod
        {
            for (var auth: AuthMethod in _social)
            {
                if (isLogged(auth)) return auth;
            }
            return null;
        }
        
        public function SocialController()
        {
            _social = new Dictionary();
        }
        
        public function addSocial(auth: AuthMethod, social: ISocial):void
        {
            _social[auth] = social;
            social.init();
        }
        
        public function update():void
        {
            dispatchEventWith(UPDATE);
        }
    }
}
