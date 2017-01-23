/**
 * Created by agnither on 29.07.16.
 */
package com.agnither.spacetaxi.utils.logger
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.Config;
    import com.agnither.spacetaxi.utils.LocalStorage;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.globalization.DateTimeFormatter;
    import flash.globalization.LocaleID;
    import flash.system.Capabilities;

    public class Logger
    {
        private static var _file: File;
        private static var _stream: FileStream;

        private static var _df: DateTimeFormatter;
        
        public static function init():void
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

        public static function log(...args):void
        {
            var message: String = args.join(" ");

            var d:Date = new Date();
            var ms:Number = d.milliseconds;
            message = _df.format(d)+(ms<10?"00":(ms<100?"0":""))+ms+" "+message+"\n";
            trace(message);

            _stream.open(_file, FileMode.APPEND);
            _stream.writeUTFBytes(message);
            _stream.close();
        }

        public static function send():void
        {
            _stream.open(_file, FileMode.READ);
            var contents: String = _stream.readUTFBytes(_stream.bytesAvailable);
            _stream.close();
            SimpleFTP.putFile("ftp.drivehq.com", "agnither", "Z01Q02bn5feh", "Kosmos/logs", Config.platform + "_" + Config.version + "_" + Config.userId + "_" + _file.name, contents);
        }
    }
}
