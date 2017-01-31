/**
 * Created by agnither on 19.12.16.
 */
package com.holypanda.kosmos.vo
{
    public class FriendVO
    {
        public var uid: String;
        public var name: String;
        public var online: Boolean;
        public var platform: int;
        public var city: String;
        public var avatarUrl: String;
        
        public var invited: Boolean;

        public function get rank():int
        {
            var rank: int = 0;
            switch (platform)
            {
                case 4:
                {
                    rank += 20;
                    break;
                }
                case 2:
                case 3:
                {
                    rank += 10;
                    break;
                }
                default:
                {
                    break;
                }
            }
            if (online)
            {
                rank += 1;
            }
            return rank;
        }
    }
}
