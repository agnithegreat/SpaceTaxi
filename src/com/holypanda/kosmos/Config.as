/**
 * Created by agnither on 20.04.16.
 */
package com.holypanda.kosmos
{
    import com.holypanda.kosmos.model.player.Volume;

    import flash.utils.ByteArray;

    public class Config
    {
        public static const FACEBOOK_APP_ID: String = "1848488828760224";
        
        public static const debug: Boolean = BUILD::debug;
        public static const platform: String = BUILD::ios ? "ios" : (BUILD::android ? "android" : "desktop");

        public static var version: String = ""; // set from InitTask

        public static var userId: String;
        
        public static var volume: Volume = new Volume();
        
        public static var replay: ByteArray;
        public static var ai: Boolean = false;
        
        public static var locale: String = "en";
        public static const localization_map: Object = {
            "ru": "ru_RU",
            "en": "en_US",
//            "de": "de_DE",
//            "fr": "fr_FR",
//            "ja": "ja_JP",
            "uk": "ru_RU",
            "be": "ru_RU",
            "kz": "ru_RU"
        };
    }
}