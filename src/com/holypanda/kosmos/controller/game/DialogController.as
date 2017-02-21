/**
 * Created by agnither on 16.11.16.
 */
package com.holypanda.kosmos.controller.game
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.view.gui.popups.DialogPopup;
    import com.holypanda.kosmos.vo.SpeechVO;

    import starling.events.EventDispatcher;

    public class DialogController extends EventDispatcher
    {
        public static const UPDATE: String = "DialogController.UPDATE";
        
        private var _dialog: Vector.<SpeechVO>;
        
        private var _shown: int = 0;
        public function get idle():Boolean
        {
            return _shown == 0;
        }
        
        public function DialogController()
        {
        }
        
        public function init(level: int):void
        {
            _dialog = new <SpeechVO>[];
            
            var data: Array = Application.assetsManager.getObject("dialogs")[level];
            if (data == null) return;
            for (var i:int = 0; i < data.length; i++)
            {
                var dialog: Object = data[i];
                var text: String = Application.uiBuilder.localization.getLocalizedText(dialog.id);
                var char: String = "characters/" + dialog.char;
                var left: Boolean = dialog.position == "left";
                var trigger: String = dialog.trigger;
                _dialog.push(new SpeechVO(text, char, left, trigger));
            }
        }
        
        public function triggerEvent(type: String = null):void
        {
            var stop:Boolean = false;
            while (!stop && _dialog.length > 0)
            {
                var dialog: SpeechVO = _dialog[0];
                if (dialog.trigger == type || dialog.trigger == "")
                {
                    showDialog(_dialog.shift());
                } else {
                    stop = true;
                }
            }
        }
        
        public function closeDialog(speech: SpeechVO):void
        {
            _shown--;
            
            dispatchEventWith(UPDATE);
        }

        private function showDialog(speech: SpeechVO):void
        {
            var dialog: DialogPopup = new DialogPopup();
            dialog.init(speech);
            WindowManager.showPopup(dialog, true);
            
            _shown++;
            dispatchEventWith(UPDATE);
        }
    }
}