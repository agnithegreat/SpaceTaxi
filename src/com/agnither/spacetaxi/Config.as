/**
 * Created by agnither on 20.04.16.
 */
package com.agnither.spacetaxi
{
    import com.agnither.spacetaxi.managers.Services;
    import com.agnither.spacetaxi.model.player.Volume;

    import flash.utils.ByteArray;

    public class Config
    {
        public static const FACEBOOK_APP_ID: String = "630268433718548";
        
        public static const debug: Boolean = BUILD::debug;
        public static const platform: String = BUILD::ios ? "ios" : (BUILD::android ? "android" : "desktop");

        public static var version: String = ""; // set from InitTask

        public static var userId: String = Services.deviceId;
        
        public static var volume: Volume = new Volume();
        
        public static var replay: ByteArray;
        public static var ai: Boolean = false;
        
        public static var support: String = "support@dieselpuppet.com";
        public static var subject: String = "Player ID %s, Russian Lotto, GP, version %s";
    }
}