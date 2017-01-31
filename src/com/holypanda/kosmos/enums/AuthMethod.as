/**
 * Created by agnither on 28.09.16.
 */
package com.holypanda.kosmos.enums
{
    public class AuthMethod
    {
        public static const GUEST: AuthMethod = new AuthMethod("GUEST");
        public static const FB: AuthMethod = new AuthMethod("FB");
        public static const VK: AuthMethod = new AuthMethod("VK");
        public static const GC: AuthMethod = new AuthMethod("GC");
        public static const GP: AuthMethod = new AuthMethod("GP");
        
        private var _tag: String;
        public function get tag():String
        {
            return _tag;
        }

        public function AuthMethod(tag: String)
        {
            _tag = tag;
        }
    }
}
