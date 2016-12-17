/**
 * Created by agnither on 16.12.16.
 */
package com.agnither.spacetaxi.view.gui.screens
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.controller.game.OrderController;
    import com.agnither.spacetaxi.model.Ship;
    import com.agnither.spacetaxi.model.SpaceBody;
    import com.agnither.spacetaxi.view.gui.game.IndicatorView;
    import com.agnither.utils.gui.components.Screen;

    import feathers.controls.LayoutGroup;

    import starling.core.Starling;

    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;

    public class MainScreen extends Screen
    {
        public var _root: LayoutGroup;
        
        public var _settingsButton: Button;

        public var _durabilityIndicator: IndicatorView;
        public var _fuelIndicator: IndicatorView;
        public var _capacityIndicator: IndicatorView;

        public var _moneyTF: TextField;

        private var _money: int;

        public function MainScreen()
        {
            super(0, 0);

            var data: Object = Application.assetsManager.getObject("main_screen");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _moneyTF.wordWrap = false;
            _moneyTF.touchable = false;

            var ship: Ship = Application.appController.space.ship;
            _fuelIndicator.init(IndicatorView.FUEL, ship.fuelMax, 9);
            _durabilityIndicator.init(IndicatorView.DURABILITY, ship.durabilityMax, 9);
            _capacityIndicator.init(IndicatorView.CAPACITY, ship.capacityMax, 5, true);
            
            StageUtil.fitAll(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }
        
        override protected function activate():void
        {
            Application.appController.space.ship.addEventListener(SpaceBody.UPDATE, handleUpdate);
            Application.appController.space.orders.addEventListener(OrderController.UPDATE, handleUpdate);
            handleUpdate(null);
        }

        override protected function deactivate():void
        {
            Application.appController.space.ship.removeEventListener(SpaceBody.UPDATE, handleUpdate);
            Application.appController.space.orders.removeEventListener(OrderController.UPDATE, handleUpdate);
        }

        private function handleUpdate(event: Event):void
        {
            var ship: Ship = Application.appController.space.ship;
            _fuelIndicator.update(ship.fuel);
            _durabilityIndicator.update(ship.durability);
            _capacityIndicator.update(ship.capacity);

            var moneyVal: int = Application.appController.space.orders.money;
            if (_money != moneyVal)
            {
                _money = moneyVal;
                Starling.juggler.tween(this, event != null ? 0.5 : 0, {"money": _money});
            }
        }

        public function set money(value: int):void
        {
            _moneyTF.text = String(value);
            while (_moneyTF.text.length < 5)
            {
                _moneyTF.text = "0" + _moneyTF.text;
            }
        }

        public function get money():int
        {
            return int(_moneyTF.text);
        }
    }
}
