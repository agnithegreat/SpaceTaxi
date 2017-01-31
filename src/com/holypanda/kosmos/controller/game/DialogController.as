/**
 * Created by agnither on 16.11.16.
 */
package com.holypanda.kosmos.controller.game
{
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.view.gui.popups.DialogPopup;
    import com.holypanda.kosmos.vo.SpeechVO;

    import starling.events.EventDispatcher;

    public class DialogController extends EventDispatcher
    {
        private var _dialog: Vector.<SpeechVO>;

        public function DialogController()
        {
        }
        
        public function init():void
        {
            _dialog = new <SpeechVO>[];
            _dialog.push(new SpeechVO(
                "Hello, challenger! I have a job that suits you perfectly! See this hostile planet dead ahead? " +
                "Those guys have some stuff I would like to buy. Bring it to me, and your effort will be payed off. " +
                "Hurry, I don't like to wait.",
                "characters/01",
                false
            ));
            _dialog.push(new SpeechVO(
                "No problem, pal. I will do it for you. Wait a parsec!",
                "characters/00",
                true
            ));
        }

        public function start():void
        {
            for (var i:int = 0; i < _dialog.length; i++)
            {
                showDialog(_dialog[i]);
            }
        }

        private function showDialog(speech: SpeechVO):void
        {
            var dialog: DialogPopup = new DialogPopup();
            dialog.init(speech);
            WindowManager.showPopup(dialog, true);
        }
    }
}