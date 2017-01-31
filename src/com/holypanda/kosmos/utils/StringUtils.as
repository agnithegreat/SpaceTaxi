/**
 * Created by agnither on 17.09.15.
 */
package com.holypanda.kosmos.utils
{
    public class StringUtils
    {
        public static function format(format:String, ...args):String {
            const re:RegExp = /%(?:(\d+)(?:\.(\d+))?)?(.)/;

            var match:Object;

            while((match = re.exec(format)) != null) {
                var index:int       = match.index;
                var length:int      = match[0].length;

                var indentation:int = match[1] != undefined ? parseInt(match[1]) :  0;
                var precision:int   = match[2] != undefined ? parseInt(match[2]) : -1;
                var flag:String     = match[3];

                var argument:String;

                switch(flag) {
                    case "d":
                        argument = formatInt(int(args.shift()), precision);
                        break;

                    case "h":
                        argument = formatInt(int(args.shift()), precision, 16);
                        break;

                    case "f":
                        argument = formatFloat(Number(args.shift()), precision < 0 ? 3 : precision);
                        break;

                    case "e":
                        argument = formatFloat(Number(args.shift()), precision < 0 ? 3 : precision, 0, true);
                        break;

                    case "s":
                        argument = String(args.shift());
                        break;

                    default:
                        argument = match[0].slice(1);
                        break;
                }

                format = format.slice(0, index) + indent(argument, indentation) + format.slice(index + length);
                re.lastIndex = 0;
            }

            return format;
        }

        public static function isEqual(string1:String, string2:String, ignoreCase:Boolean = false):Boolean {
            return ignoreCase ? string1.toLowerCase() == string2.toLowerCase() : string1 == string2
        }

        public static function formatInt(value:int, leading:int = 0, radix:int = 10):String {
            var out:String;

            out = value.toString(radix);
            while(out.length < leading)
                out = "0" + out;

            return out;
        }

        public static function formatFloat(value:Number, precision:int = 3, leading:int = 0, exponential:Boolean = false):String {
            var out:String;

            out = exponential ? value.toExponential(precision) : value.toFixed(precision);
            while(out.length < leading)
                out = "0" + out;

            return out;
        }

        public static function indent(string:String, length:int):String {
            while(string.length < length)
                string = " " + string;
            return string;
        }

        public static function trim(string:String):String {
            return string.replace(/(^\s*)|(\s*$)/g, "");
        }

        public static function condenceWhitespaces(string:String):String {
            return trim(string).replace(/((\s)+)/g, "$2");
        }

        public static function formatNumberDelimeter(number:Number, delimeter: String = "."):String
        {
            var numString:String = number.toString();
            var result:String = '';

            while (numString.length > 3)
            {
                var chunk:String = numString.substr(-3);
                numString = numString.substr(0, numString.length - 3);
                result = delimeter + chunk + result;
            }

            if (numString.length > 0)
            {
                result = numString + result;
            }

            return result;
        }

        public static function timeToString(totalSeconds: int):String
        {
            var string: String = "";
            var hours: int = totalSeconds / 3600;
            if (hours > 0) string += "" + (hours >= 10 ? hours : "0" + hours) + ":";
            var minutes: int = (totalSeconds % 3600) / 60;
            string += "" + (minutes >= 10 ? minutes : "0" + minutes) + ":";
            var seconds: int = (totalSeconds % 60);
            string += "" + (seconds >= 10 ? seconds : "0" + seconds);
            return string;
        }
    }
}
