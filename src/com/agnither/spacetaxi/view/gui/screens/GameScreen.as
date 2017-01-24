/**
 * Created by agnither on 16.12.16.
 */
package com.agnither.spacetaxi.view.gui.screens
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.controller.game.OrderController;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.model.Ship;
    import com.agnither.spacetaxi.model.Space;
    import com.agnither.spacetaxi.model.SpaceBody;
    import com.agnither.spacetaxi.tasks.logic.EndGameTask;
    import com.agnither.spacetaxi.view.gui.game.IndicatorView;
    import com.agnither.spacetaxi.view.gui.items.DialogView;
    import com.agnither.spacetaxi.view.gui.popups.PausePopup;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Screen;

    import feathers.controls.LayoutGroup;

    import starling.core.Starling;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;

    public class GameScreen extends Screen
    {
        public var _root: LayoutGroup;
        
        public var _settingsButton: Button;

        public var _durabilityIndicator: IndicatorView;
        public var _fuelIndicator: IndicatorView;

        public var _moneyTF: TextField;
        public var _addTF: TextField;

        public var _hide: Quad;
        public var _dialog: DialogView;
        public var _dialogContainer: LayoutGroup;

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

            _hide.width = stage.stageWidth;
            _hide.height = stage.stageHeight;
        }
        
        override protected function activate():void
        {
            _space = Application.appController.space;
            _space.addEventListener(Space.RESTART, handleRestart);
            _space.ship.addEventListener(SpaceBody.UPDATE, handleUpdate);
            _space.orders.addEventListener(OrderController.UPDATE, handleUpdate);
            handleUpdate(null);

            _settingsButton.addEventListener(Event.TRIGGERED, handleSettings);

            _addTF.alpha = 0;

            Starling.juggler.delayCall(showDialog, 0);
        }

        override protected function deactivate():void
        {
            _space.removeEventListener(Space.RESTART, handleRestart);
            _space.ship.removeEventListener(SpaceBody.UPDATE, handleUpdate);
            _space.orders.removeEventListener(OrderController.UPDATE, handleUpdate);
            _space = null;

            if (_dialog != null)
            {
                _dialog.removeFromParent(true);
                _dialog = null;
            }

            Starling.juggler.removeTweens(this);
            _moneyVal = -1;
            
            _settingsButton.removeEventListener(Event.TRIGGERED, handleSettings);
        }
        
        override public function tryClose():Boolean
        {
            // TODO: notify user
            return true;
        }

        private function showDialog():void
        {
            _hide.visible = true;
            _dialog = new DialogView();
            _dialogContainer.addChild(_dialog);

            _dialog.init(
                "Hello, challenger! I have a job that suits perfectly! See this hostile planet dead ahead? Those guys have some stuff I would like to buy. Bring it to me, and your effort will be payed off. Hurry, I don't like to wait.",
                "characters/01",
                false,
                trace,
                nextDialog
            );
            _dialog.visible = true;
        }

        private function nextDialog():void
        {
            _dialog.init(
                "No problem, pal. I will do it for you. Wait a parsec!",
                "characters/00",
                true,
                trace,
                hideDialog
            );
        }

        private function hideDialog():void
        {
            _hide.visible = false;

            if (_dialog != null)
            {
                _dialog.removeFromParent(true);
                _dialog = null;
            }
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

        private function handleSettings(event: Event):void
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
