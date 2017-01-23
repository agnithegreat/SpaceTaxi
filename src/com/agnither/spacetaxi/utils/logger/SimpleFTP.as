/**
 * Created by agnither on 19.01.17.
 */
package com.agnither.spacetaxi.utils.logger
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;

    public class SimpleFTP {

        public static function putFile(host:String, user:String, pass:String, path:String, fileName: String, contents: String):void
        {
            var s:SimpleFTP = new SimpleFTP(host, user, pass);
            s.putFile(path, fileName, contents);
        }

        private var host:String,user:String,pass:String;
        private var ctrlSocket:Socket = new Socket();
        private var dataSocket:Socket = new Socket();
        private var dataIP:String;
        private var dataPort:int;
        private var path:Array;
        private var fileName:String;
        private var contents: String;
        private var step:int;
        private var sa:Array;

        public function SimpleFTP(host:String, user:String, pass:String) {
            this.host = host;
            this.user = user;
            this.pass = pass;
            ctrlSocket.addEventListener(IOErrorEvent.IO_ERROR, error);
            ctrlSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, error);
        }

        private function putFile(path:String, fileName: String, contents: String):void {
            this.path = path.split("/");
            this.fileName = fileName;
            this.contents = contents;
            step = 0;
            ctrlSocket.addEventListener(ProgressEvent.SOCKET_DATA, session);
            ctrlSocket.connect(host, 21);
        }

        private function write(mes:String):void {
            ctrlSocket.writeUTFBytes(mes + "\r\n");
            ctrlSocket.flush();
        }

        private function response(res:String, contents:String = null):void {
            step = 13;
            write("QUIT");
        }

        private function error(event: Event):void {
        }

        private function session(event:ProgressEvent):void {
            var res:String = ctrlSocket.readUTFBytes(ctrlSocket.bytesAvailable);
            var st:String = res.substr(0, 3);
            trace(res);

            switch (step) {
                case 0:
                    if (st == "220") {
                        step++;
                        write("USER " + user);
                    } else
                        response(res);
                    break;
                case 1:
                    if (st == "331") {
                        step++;
                        write("PASS " + pass);
                    } else
                        response(res);
                    break;
                case 2:
                    if (st == "230") {
                        step++;
                        write("TYPE I");
                    } else
                        response(res);
                    break;
                case 3:
                    if (st == "200" || st == "250") {
                        step++;
                        if (path.length > 0)
                        {
                            write("MKD " + path[0]);
                        } else {
                            step++;
                        }
                    } else {
                        response(res);
                    }
                    break;
                case 4:
                    if (st == "257" || st == "550") {
                        if (path.length > 1)
                        {
                            step--;
                        } else {
                            step++;
                        }
                        write("CWD " + path.shift());
                    } else {
                        response(res);
                    }
                    break;
                case 5:
                    if (st == "250") {
                        write("DELE " + fileName);
                        step++;
                    } else
                        response(res);
                    break;
                case 6:
                    write("PASV");
                    step++;
                    break;
                case 7:
                    if (st == "227") {
                        step++;
                        sa = res.substring(res.indexOf("(") + 1, res.indexOf(")")).split(",");
                        dataIP = sa[0] + "." + sa[1] + "." + sa[2] + "." + sa[3];
                        dataPort = parseInt(sa[4]) * 256 + parseInt(sa[5]);
                        write("STOR " + fileName);
                        dataSocket.connect(dataIP, dataPort);
                    } else
                        response(res);
                    break;
                case 8:
                    if (st == "125" || st == "150") {
                        step++;
                        dataSocket.writeUTFBytes(contents);
                        dataSocket.flush();
                        dataSocket.close();
                    } else {
                        dataSocket.close();
                        response(res);
                    }
                    break;
                case 9:
                    response(res); // regardless if the res is "226" or not.
                    break;
                case 10:
                    if (st == "227") {
                        step++;
                        sa = res.substring(res.indexOf("(") + 1, res.indexOf(")")).split(",");
                        dataIP = sa[0] + "." + sa[1] + "." + sa[2] + "." + sa[3];
                        dataPort = parseInt(sa[4]) * 256 + parseInt(sa[5]);
                        contents = "";
                        dataSocket.addEventListener(ProgressEvent.SOCKET_DATA,
                                function (event:ProgressEvent):void {
                                    contents += dataSocket.readUTFBytes(dataSocket.bytesAvailable);
                                });
                        dataSocket.connect(dataIP, dataPort);
                        write("RETR " + path);
                    } else
                        response(res);
                    break;
                case 11:
                    if (st == "125")
                        step++;
                    else {
                        dataSocket.close();
                        response(res);
                    }
                    break;
                case 12:
                    if (st == "226") // succeeded
                        response(res, contents);
                    else
                        response(res);
                    break;
                case 13:
                    ctrlSocket.close();
                    break;
            }
        }
    }
}