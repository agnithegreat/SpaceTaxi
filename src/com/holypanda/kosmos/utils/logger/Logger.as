/**
 * Created by agnither on 29.07.16.
 */
package com.holypanda.kosmos.utils.logger
{
    import by.blooddy.crypto.MD5;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.utils.LocalStorage;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.globalization.DateTimeFormatter;
    import flash.globalization.LocaleID;
    import flash.system.Capabilities;
    import flash.utils.ByteArray;

    public class Logger
    {
        BUILD::standalone
        {
            private static var _file: File;
            private static var _stream: FileStream;

        }

        private static var _df: DateTimeFormatter;

        public static function init():void
        {
            BUILD::standalone
            {
                _df = new DateTimeFormatter(LocaleID.DEFAULT);
                _df.setDateTimePattern("yyyyMMdd");

                var date: String = _df.format(new Date());
                var path: String = File.documentsDirectory.resolvePath("logs/" + date + ".log").nativePath;
                _file = new File(path);
                _stream = new FileStream();

                if (path != LocalStorage.logging.read("path"))
                {
                    LocalStorage.logging.write("latest", path);

                    log("[DeviceInfo]");
                    log("language: " + Capabilities.language);
                    log("manufacturer: " + Capabilities.manufacturer);
                    log("os: " + Capabilities.os);
                    log("pixelAspectRatio: " + Capabilities.pixelAspectRatio);
                    log("screenDPI: " + Capabilities.screenDPI);
                    log("screenResolutionX: " + Capabilities.screenResolutionX);
                    log("screenResolutionY: " + Capabilities.screenResolutionY);
                    log("touchscreenType: " + Capabilities.touchscreenType);
                    log("cpuArchitecture: " + Capabilities.cpuArchitecture);
                    log("languages: " + Capabilities.languages);
                    log("version: " + Capabilities.version);
                    log("\n");

                    log("[ScreenInfo]");
                    log(Application.viewport);
                    log("\n");
                }

                _df.setDateTimePattern("HH:mm:ss:");
            }
        }

        public static function log(...args):void
        {
            var message: String = args.join(" ");

            var d:Date = new Date();
            var ms:Number = d.milliseconds;
            message = _df.format(d)+(ms<10?"00":(ms<100?"0":""))+ms+" "+message+"\n";
            trace(message);

            BUILD::standalone
            {
                _stream.open(_file, FileMode.APPEND);
                _stream.writeUTFBytes(message);
                _stream.close();
            }
        }

        public static function sendLog():void
        {
            BUILD::standalone
            {
                _stream.open(_file, FileMode.READ);
                var contents:ByteArray = new ByteArray();
                _stream.readBytes(contents);
                _stream.close();
                var filename:String = Config.platform + "_" + Config.version + "_" + Config.userId + "_" + _file.name;
                sendFile(contents, "Kosmos/logs", filename);
            }
        }

        public static function sendReplay(replay: ByteArray):void
        {
            BUILD::standalone
            {
                var hash:String = MD5.hashBytes(replay);

                var contents:ByteArray = new ByteArray();
                replay.readBytes(contents);
                var filename:String = Config.platform + "_" + Config.version + "_" + Config.userId + "_" + hash + ".replay";
                sendFile(contents, "Kosmos/replays", filename);
            }
        }
        
        public static function sendFile(contents: ByteArray, path: String, filename: String):void
        {
            BUILD::standalone
            {
                SimpleFTP.putFile("ftp.drivehq.com", "agnither", "Z01Q02bn5feh", path, filename, contents);
            }
        }
    }
}
