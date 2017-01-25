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
        
        public static var feedbackLink: String = "https://docs.google.com/forms/d/e/1FAIpQLSf2btrhF_mPoKD9yME0FzPIEbJOSvqKy5tlxIuWx_Q5ciK7NQ/viewform?entry.349077040=%user_id%";
    }
}