/**
 * Created by agnither on 10.01.17.
 */
package com.holypanda.kosmos.view.gui.popups
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.vo.SpeechVO;
    import com.agnither.utils.gui.components.Popup;

    import feathers.controls.LayoutGroup;
    import feathers.layout.AnchorLayoutData;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;

    public class DialogPopup extends Popup
    {
        public var _root: LayoutGroup;
        
        public var _container: LayoutGroup;
        
        public var _bubble: Image;
        public var _textTF: TextField;
        public var _character: Image;
        
        private var _speech: SpeechVO;

        private var _started: Boolean;
        private var _count: int;
        private var _skip: Boolean;

        public function DialogPopup()
        {
            super(0, 1, false);

            var data: Object = Application.assetsManager.getObject("dialog_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }
        
        public function init(speech: SpeechVO):void
        {
            _speech = speech;
            _textTF.text = "";
            _count = 0;
            _started = false;
            _skip = false;
        }

        override protected function initialize():void
        {
            StageUtil.fitAll(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);

            _root.pivotX = _root.width * 0.5;
            _root.pivotY = _root.height * 0.5;

            _character.texture = Application.assetsManager.getTexture(_speech.character);
            _container.setChildIndex(_character, _speech.left ? 0 : 1);
            _bubble.scaleX = _speech.left ? -1 : 1;

            (_container.layoutData as AnchorLayoutData).left = _speech.left ? 0 : NaN;
            (_container.layoutData as AnchorLayoutData).right = _speech.left ? NaN : 0;
        }
        
        override protected function activate():void
        {
            Starling.juggler.delayCall(nextSound, 0);
            Starling.juggler.delayCall(nextLetter, 0);

            addEventListener(TouchEvent.TOUCH, handleTouch);
        }

        override protected function deactivate():void
        {
            removeEventListener(TouchEvent.TOUCH, handleTouch);
        }

        private function nextSound():void
        {
            var sounds: Array = [SoundManager.DIALOG_MORSE_1, SoundManager.DIALOG_MORSE_2, SoundManager.DIALOG_MORSE_3];
            var delays: Array = [0.5, 0.6, 0.9];
            var rand: int = sounds.length * Math.random();
            SoundManager.playSound(sounds[rand]);
            Starling.juggler.delayCall(nextSound, delays[rand]);
        }

        private function nextLetter():void
        {
            _started = true;
            _count++;
            _textTF.text = _speech.text.substr(0, _count);

            if (_speech.text.length <= _count)
            {
                free();
            } else {
                var char: String = _speech.text.charAt(_count-1);
                if (_skip)
                {
                    Starling.juggler.delayCall(nextLetter, 0);
                } else if (["!", "?", "."].indexOf(char) >= 0)
                {
                    Starling.juggler.delayCall(nextLetter, 0.4);
                } else if ([",", ";"].indexOf(char) >= 0)
                {
                    Starling.juggler.delayCall(nextLetter, 0.2);
                } else if (char == " ")
                {
                    Starling.juggler.delayCall(nextLetter, 0.1);
                } else {
                    Starling.juggler.delayCall(nextLetter, 0);
                }
            }
        }
        
        private function free():void
        {
            Starling.juggler.removeDelayedCalls(nextSound);
            Starling.juggler.delayCall(closeFn, 3);
        }

        private function closeFn():void
        {
            Starling.juggler.removeDelayedCalls(nextSound);
            Starling.juggler.removeDelayedCalls(nextLetter);
            Starling.juggler.removeDelayedCalls(closeFn);

            WindowManager.closePopup(this, true);
        }

        override protected function cancelHandler():void
        {
            if (_skip || _count > _speech.text.length)
            {
                closeFn();
            } else
            {
                _skip = true;
            }
        }

        private function handleTouch(event: TouchEvent):void
        {
            var touch: Touch = event.getTouch(this, TouchPhase.BEGAN);
            if (touch != null)
            {
                cancelHandler();
            }
        }
    }
}
