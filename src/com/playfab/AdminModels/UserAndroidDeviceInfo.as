
package com.playfab.AdminModels
{
    public class UserAndroidDeviceInfo
    {
        public var AndroidDeviceId:String;

        public function UserAndroidDeviceInfo(data:Object=null)
        {
            if(data == null)
                return;
            AndroidDeviceId = data.AndroidDeviceId;

        }
    }
}
