/**
 * Created by agnither on 16.12.16.
 */
package com.agnither.spacetaxi.view.gui.screens
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.controller.game.OrderController;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.model.Ship;
    import com.agnither.spacetaxi.model.Space;
    import com.agnither.spacetaxi.model.SpaceBody;
    import com.agnither.spacetaxi.tasks.logic.EndGameTask;
    import com.agnither.spacetaxi.view.gui.game.IndicatorView;
    import com.agnither.tasks.global.TaskSystem;
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
        
        public var _settingsButton: Button;

        public var _durabilityIndicator: IndicatorView;
        public var _fuelIndicator: IndicatorView;

        public var _moneyTF: TextField;

        private var _space: Space;

        private var _money: int = -1;

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

            _settingsButton.addEventListener(Event.TRIGGERED, handleSettings);
        }

        override protected function deactivate():void
        {
            _space.removeEventListener(Space.RESTART, handleRestart);
            _space.ship.removeEventListener(SpaceBody.UPDATE, handleUpdate);
            _space.orders.removeEventListener(OrderController.UPDATE, handleUpdate);
            _space = null;
            
            _settingsButton.removeEventListener(Event.TRIGGERED, handleSettings);
        }
        
        override public function tryClose():Boolean
        {
            // TODO: notify user
            return true;
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
            if (_money != moneyVal)
            {
                _money = moneyVal;
                Starling.juggler.tween(this, event != null ? 0.5 : 0, {"money": _money});
            }
        }

        private function handleSettings(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            TaskSystem.getInstance().addTask(new EndGameTask());
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
