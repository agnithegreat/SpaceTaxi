package com.holypanda.kosmos.utils {
    import flash.net.URLRequest;
    import flash.net.navigateToURL;
    import flash.utils.ByteArray;

public class Utils {

    // include both min and max
    static public function rand(min : int, max : int) : int {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    static public function randItem(arr : Array) : * {
        return arr[Utils.rand(0, arr.length - 1)];
    }

    static public function randBool() : Boolean {
        return Math.random() > 0.5;
    }

    static public function ba2s(data : ByteArray) : String {
        data.position = 0;
        return data.readUTFBytes(data.length);
    }

    static public function arrExists(item : *, arr : Array) : Boolean {
        for(var i : int = 0; i < arr.length; i++) {
            if(arr[i] == item) return true;
        }
        return false;
    }

    static public function arrRemove(item : *, arr : Array) : Boolean {
        for(var i : int = 0; i < arr.length; i++) {
            if(arr[i] == item) {
                arr.splice(i, 1);
                return true;
            }
        }
        return false;

    }

    static public function formatChips(amount : int) : String {
        if(amount >= 10000000 || amount <= -10000000000)
            return formatNum(Math.round(amount / 1000000)) + "M";

        if(amount >= 100000 || amount <= -100000)
            return formatNum(Math.round(amount / 1000)) + "k";

        return formatNum(amount);
    }

    static public function formatNum(num : int) : String {
        var arr : Array = Math.abs(num).toString().split("").reverse();
        var res : String = "";
        while(arr.length > 3) {
            var sub : Array = arr.slice(0, 3);
            arr = arr.slice(3);
            res = "," + sub.reverse().join("") + res;
        }
        res = arr.reverse().join("") + res;
        if(num < 0) return "-" + res;
        return res;
    }

    static public function traceObj(obj : Object, depth : String = "") : void {
        for (var i : String in obj) {
            if(typeof(obj[i]) == "object") {
                trace(depth, i, ": Object");
                traceObj(obj[i], depth + "----");
            }
            else {
                trace(depth, i, ":", obj[i]);
            }
        }
    }
    
    static public function sendEmail(email: String, subject: String = "", body: String = ""):void
    {
        subject = escape(subject);
        body = escape(body);
        var url:String = "mailto:" + email + "?subject=" + subject + "&body=" + body;
        trace(url);
        navigateToURL(new URLRequest(url.replace("+","%20")));
    }
}
}
