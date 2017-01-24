/**
 * Created by agnither on 10.01.17.
 */
package com.agnither.spacetaxi.view.gui.items
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.utils.gui.components.AbstractComponent;

    import feathers.controls.LayoutGroup;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;

    public class DialogView extends AbstractComponent
    {
        public var _root: LayoutGroup;
        
        public var _bubble: Image;
        public var _textTF: TextField;
        public var _character: Image;
        
        private var _text: String;
        private var _close: Function;

        private var _started: Boolean;
        private var _count: int;
        private var _skip: Boolean;

        public function DialogView()
        {
            super();

            var data: Object = Application.assetsManager.getObject("dialog");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }
        
        public function init(text: String, character: String, left: Boolean, close: Function):void
        {
            _character.texture = Application.assetsManager.getTexture(character);
            _root.setChildIndex(_character, left ? 0 : 1);
            _bubble.scaleX = left ? -1 : 1;
            
            _text = text;
            _textTF.text = "";
            _close = close;
            _count = 0;
            _started = false;
            _skip = false;

            Starling.juggler.delayCall(nextLetter, 0);
        }

        override protected function initialize():void
        {
            _text = "";
        }
        
        override protected function activate():void
        {
            stage.addEventListener(TouchEvent.TOUCH, handleTouch);
        }

        override protected function deactivate():void
        {
            stage.removeEventListener(TouchEvent.TOUCH, handleTouch);
        }

        private function nextLetter():void
        {
            _started = true;
            _count++;
            _textTF.text = _text.substr(0, _count);

            if (_text.length <= _count)
            {
                free();
            } else {
                var char: String = _text.charAt(_count-1);
                if (_skip)
                {
                    Starling.juggler.delayCall(nextLetter, 0);
                } else if (["!", "?", "."].indexOf(char) >= 0)
                {
                    Starling.juggler.delayCall(nextLetter, 0.4);
                } else if ([",", ";"].indexOf(char) >= 0)
                {
                    Starling.juggler.delayCall(nextLetter, 0.2);
                } else if (char == " ") {
                    Starling.juggler.delayCall(nextLetter, 0.1);
                } else {
                    Starling.juggler.delayCall(nextLetter, 0);
                }
            }
        }
        
        private function free():void
        {
            Starling.juggler.delayCall(close, 3);
        }
        
        private function close():void
        {
            var fn: Function = _close;
            _close = null;
            fn();
            
            Starling.juggler.removeDelayedCalls(close);
        }

        private function handleTouch(event: TouchEvent):void
        {
            if (!_started) return;

            var touch: Touch = event.getTouch(stage, TouchPhase.ENDED);
            if (touch != null)
            {
                if (_skip || _count > _text.length)
                {
                    close();
                } else
                {
                    _skip = true;
                }
            }
        }
    }
}
