/**
 * Created by agnither on 16.12.16.
 */
package com.holypanda.kosmos.view.gui.screens
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.controller.game.OrderController;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.model.Ship;
    import com.holypanda.kosmos.model.Space;
    import com.holypanda.kosmos.model.SpaceBody;
    import com.holypanda.kosmos.view.gui.game.IndicatorView;
    import com.holypanda.kosmos.view.gui.popups.PausePopup;
    import com.agnither.utils.gui.components.Screen;

    import feathers.controls.LayoutGroup;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;

    public class GameScreen extends Screen
    {
        public var _root: LayoutGroup;
        
        public var _pauseButton: Button;

        public var _durabilityIndicator: IndicatorView;
        public var _fuelIndicator: IndicatorView;

        public var _moneyTF: TextField;
        public var _addTF: TextField;

        private var _space: Space;

        private var _moneyVal: int = -1;

        public function GameScreen()
        {
            super(0, 0);

            var data: Object = Application.assetsManager.getObject("game_screen");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _moneyTF.wordWrap = false;
            _moneyTF.touchable = false;

            var ship: Ship = Application.appController.space.ship;
            _fuelIndicator.init(IndicatorView.FUEL, ship.fuelMax, 9);
            _durabilityIndicator.init(IndicatorView.DURABILITY, ship.durabilityMax, 9);

            StageUtil.fitAll(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }
        
        override protected function activate():void
        {
            _space = Application.appController.space;
            _space.addEventListener(Space.RESTART, handleRestart);
            _space.ship.addEventListener(SpaceBody.UPDATE, handleUpdate);
            _space.orders.addEventListener(OrderController.UPDATE, handleUpdate);
            handleUpdate(null);

            _pauseButton.addEventListener(Event.TRIGGERED, handlePause);

            _addTF.alpha = 0;

            Starling.juggler.delayCall(showDialog, 0);
        }

        override protected function deactivate():void
        {
            _space.removeEventListener(Space.RESTART, handleRestart);
            _space.ship.removeEventListener(SpaceBody.UPDATE, handleUpdate);
            _space.orders.removeEventListener(OrderController.UPDATE, handleUpdate);
            _space = null;

            Starling.juggler.removeTweens(this);
            _moneyVal = -1;

            _pauseButton.removeEventListener(Event.TRIGGERED, handlePause);
        }
        
        override public function tryClose():Boolean
        {
            // TODO: notify user
            return true;
        }

        private function showDialog():void
        {
            // TODO: make a dialog system

            
        }

        private function handleRestart(event: Event):void
        {
            deactivate();
            activate();
        }

        private function handleUpdate(event: Event):void
        {
            var ship: Ship = Application.appController.space.ship;
            _fuelIndicator.update(ship.fuel, event != null);
            _durabilityIndicator.update(ship.durability, event != null);

            var moneyVal: int = Application.appController.space.orders.money;
            if (_moneyVal != moneyVal)
            {
                if (event != null)
                {
                    _addTF.text = "+" + (moneyVal - _moneyVal);
                    _addTF.alpha = 1;
                    Starling.juggler.tween(_addTF, 1, {"alpha": 0});
                }

                _moneyVal = moneyVal;
                Starling.juggler.tween(this, event != null ? 0.5 : 0, {"money": _moneyVal});
            }
        }

        private function handlePause(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            WindowManager.showPopup(new PausePopup(), true);
        }

        public function set money(value: int):void
        {
            _moneyTF.text = String(value) + " ";
        }

        public function get money():int
        {
            return int(_moneyTF.text);
        }
    }
}
