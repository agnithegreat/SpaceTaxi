/**
 * Created by agnither on 13.01.17.
 */
package com.holypanda.kosmos.model.player.vo
{
    public class EpisodeResultVO
    {
        public var episode: int;

        public function toJSON(s:String):*
        {
            return [episode];
        }
    }
}
