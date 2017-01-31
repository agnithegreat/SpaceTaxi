/**
 * Created by agnither on 12.10.16.
 */
package com.holypanda.kosmos.managers.social
{
    public interface ISocial
    {
        function init():void;
        function login():void;
        function logout():void;
        
        function join(id: uint, callback: Function):void;
        function inviteFriends(uids: String, text: String, callback: Function):void;
        function invite(link: String, image: String, callback: Function):Boolean;
        function achievementUnlock(id: String):void;

        function get friends():Array;
        function get friendsInApp():int;
        function get friendsTotal():int;
        function get isLogged():Boolean;
        
        function get inviteList():Boolean;
        function get inviteMultiMode():Boolean;
    }
}
