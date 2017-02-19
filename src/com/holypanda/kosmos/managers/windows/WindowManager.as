/**
 * Created by agnither on 12.01.16.
 */
package com.holypanda.kosmos.managers.windows
{
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.agnither.utils.gui.components.AbstractComponent;
    import com.agnither.utils.gui.components.Popup;
    import com.agnither.utils.gui.components.Screen;

    import flash.geom.Rectangle;
    import flash.system.System;

    import starling.animation.Transitions;
    import starling.core.Starling;
    import starling.display.Canvas;
    import starling.display.Quad;
    import starling.display.Sprite;

    public class WindowManager
    {
        private static var _scene: Sprite;
        private static var _viewport: Rectangle;

        private static var _mask: Canvas;

        private static var _sceneLayer: Layer;
        private static var _screenLayer: Layer;
        private static var _screenHelperLayer: Layer;
        private static var _screenTweenLayer: Layer;
        private static var _popupDarkLayer: Quad;
        private static var _popupLayer: Layer;
        private static var _popupTweenLayer: Layer;
        private static var _loaderDarkLayer: Quad;
        private static var _hintLayer: Layer;

        private static var _popupsQueue: Vector.<Popup>;
        private static var _popupsStack: Vector.<Popup>;

        private static var _currentScreen: Screen;
        private static var _currentPopup: Popup;

        public static function get hasPopup():Boolean
        {
            return _currentPopup != null;
        }

//        private static var _loader: LoaderView;

        public static function init(scene: Sprite, viewport: Rectangle):void
        {
            _scene = scene;
            _viewport = viewport;
            TweenManager.init(_viewport);

            _mask = new Canvas();
            _mask.drawRectangle(0, 0, _viewport.width, _viewport.height);

            _sceneLayer = new Layer();
            _scene.addChild(_sceneLayer);

            _screenLayer = new Layer();
            _scene.addChild(_screenLayer);

            _screenHelperLayer = new Layer();
            _screenHelperLayer.x = _viewport.width;
            _scene.addChild(_screenHelperLayer);

            _screenTweenLayer = new Layer();
            _screenTweenLayer.touchable = false;
            _scene.addChild(_screenTweenLayer);

            _popupDarkLayer = new Quad(_viewport.width, _viewport.height, 0xFF000000);
            _popupDarkLayer.alpha = 0;
            _popupDarkLayer.visible = false;
            _scene.addChild(_popupDarkLayer);

            _popupLayer = new Layer();
            _scene.addChild(_popupLayer);

            _popupTweenLayer = new Layer();
            _scene.addChild(_popupTweenLayer);

            _loaderDarkLayer = new Quad(_viewport.width, _viewport.height, 0xFF000000);
            _loaderDarkLayer.alpha = 0.7;
            _loaderDarkLayer.visible = false;
            _scene.addChild(_loaderDarkLayer);

            _hintLayer = new Layer();
            _scene.addChild(_hintLayer);

//            _loader = new LoaderView();

            _popupsStack = new <Popup>[];
            _popupsQueue = new <Popup>[];
        }
        
        public static function showScene(scene: AbstractComponent):void
        {
            _sceneLayer.removeChildren(0, -1);
            if (scene != null)
            {
                _sceneLayer.addChild(scene);
            }
        }

        public static function showScreen(screen: Screen):void
        {
            _currentScreen = screen;
            _currentScreen.visible = true;
            _screenLayer.removeChildren();
            _screenLayer.addChild(_currentScreen);
            _currentScreen.setup();
            updateScreenFreeze();
        }
        
        public static function showPopup(popup: Popup, tween: Boolean = false):void
        {
            if (tween)
            {
                var index: int = _popupsQueue.indexOf(popup);
                if (index < 0)
                {
                    _popupsQueue.push(popup);
                    if (_popupsQueue.length > 1) return;
                } else if (index > 0) return;

                if (popup.sound)
                {
                    SoundManager.playSound(SoundManager.POPUP_OPEN);
                }

                SoundManager.backgroundMode = true;

                Starling.juggler.removeTweens(_popupDarkLayer);
                _popupDarkLayer.visible = true;
                Starling.juggler.tween(_popupDarkLayer, 0.3, {
                    alpha: 0.7
                });

                popup.x = _viewport.width * (popup.tweenPosition.x + 0.5);
                popup.y = _viewport.height * (popup.tweenPosition.y + 0.5);
                replaceLayerContent(_popupTweenLayer, popup);
                Starling.juggler.tween(popup, 0.3, {
                    x: 0.5 * _viewport.width,
                    y: 0.5 * _viewport.height,
                    transition: Transitions.EASE_IN_OUT,
                    onComplete: showPopup,
                    onCompleteArgs: [popup]
                });
            } else {
                popup.touchable = true;
                popup.setup();

                var id: int = _popupsStack.indexOf(popup);
                if (id >= 0)
                {
                    _popupsStack.splice(id, 1);
                }
                _popupsStack.push(popup);
                rearrangePopups();
            }
        }

        public static function closePopup(popup: Popup = null, tween: Boolean = false):void
        {
            popup = popup || _currentPopup;
            if (!popup) return;

            popup.touchable = false;

            if (tween)
            {
                if (popup.sound)
                {
                    SoundManager.playSound(SoundManager.POPUP_CLOSE);
                }

                if (_popupsQueue.length <= 1)
                {
                    SoundManager.backgroundMode = false;

                    Starling.juggler.removeTweens(_popupDarkLayer);
                    Starling.juggler.tween(_popupDarkLayer, 0.3, {
                        alpha: 0
                    });
                }

                Starling.juggler.tween(popup, 0.3, {
                    x: _viewport.width * (popup.tweenPosition.x + 0.5),
                    y: _viewport.height * (popup.tweenPosition.y + 0.5),
                    transition: Transitions.EASE_IN_OUT,
                    onComplete: closePopup,
                    onCompleteArgs: [popup]
                });
            } else {
                var index: int = _popupsQueue.indexOf(popup);
                if (index >= 0)
                {
                    _popupsQueue.splice(index, 1);
                }

                var id: int = _popupsStack.indexOf(popup);
                if (id >= 0)
                {
                    popup.close();
                    _popupsStack.splice(id, 1);
                    rearrangePopups();
                }
            }
        }
        
        public static function closeAllPopups():void
        {
            while (_currentPopup != null)
            {
                closePopup(_currentPopup);
            }
        }
        
        public static function showLoader():void
        {
            _loaderDarkLayer.visible = true;
//            _hintLayer.addChild(_loader);
        }

        public static function hideLoader():void
        {
            _loaderDarkLayer.visible = false;
//            _hintLayer.removeChild(_loader);
        }

        private static function updateScreenFreeze():void
        {
            if (_currentPopup != null)
            {
                _popupDarkLayer.visible = true;
                _currentScreen.freeze();
            } else {
                _popupDarkLayer.visible = false;
                _currentScreen.unfreeze();
            }
        }
        
        private static function rearrangePopups():void
        {
            var popup: Popup;
            for (var i:int = 0; i < _popupsStack.length-1; i++)
            {
                popup = _popupsStack[i];
                popup.hide();

                _popupLayer.removeChild(popup);
            }

            _currentPopup = _popupsStack.length > 0 ? _popupsStack[_popupsStack.length-1] : null;
            if (_currentPopup != null)
            {
                _currentPopup.show();
                _popupLayer.addChild(_currentPopup);
            } else if (_popupsQueue.length > 0)
            {
                _currentPopup = _popupsQueue[0];
                showPopup(_currentPopup, true);
            }
            updateScreenFreeze();
        }

        private static function replaceLayerContent(layer: Layer, content: Sprite):void
        {
            layer.destroyChildren();
            System.gc();
            layer.addChild(content);
        }
    }
}

import com.agnither.utils.gui.components.AbstractComponent;

class Layer extends AbstractComponent
{
}