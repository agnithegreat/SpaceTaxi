/**
 * Created by agnither on 13.01.17.
 */
package com.holypanda.kosmos.model.player.vo
{
    public class LevelResultVO
    {
        public var level: int;
        public var money: int;
        public var stars: int;

        public function toJSON(s:String):*
        {
            return [level, money, stars];
        }
    }
}
