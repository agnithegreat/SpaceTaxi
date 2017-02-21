/**
 * Created by agnither on 26.01.17.
 */
package com.holypanda.kosmos.vo
{
    public class SpeechVO
    {
        public var text: String;
        public var character: String;
        public var left: Boolean;
        public var trigger: String;

        public function SpeechVO(text: String, character: String, left: Boolean, trigger: String)
        {
            this.text = text;
            this.character = character;
            this.left = left;
            this.trigger = trigger;
        }
    }
}
