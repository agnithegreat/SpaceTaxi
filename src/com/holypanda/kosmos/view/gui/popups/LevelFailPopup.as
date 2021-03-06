/**
 * Created by agnither on 21.01.17.
 */
package com.holypanda.kosmos.view.gui.popups
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.tasks.logic.game.EndGameTask;
    import com.holypanda.kosmos.tasks.logic.game.RestartGameTask;
    import com.holypanda.kosmos.utils.StringUtils;
    import com.holypanda.kosmos.view.gui.items.FakeShipView;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Popup;

    import feathers.controls.LayoutGroup;

    import starling.core.Starling;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class LevelFailPopup extends Popup
    {
        public var _root: LayoutGroup;

        public var _ship: Sprite;

        public var _glowMC: MovieClip;

        public var _menuButton: ContainerButton;
        public var _replayButton: ContainerButton;

        public var _titleTF: TextField;

        public var _container: LayoutGroup;
        public var _rewardTF: TextField;

        public function LevelFailPopup()
        {
            super(0, 1);

            var data: Object = Application.assetsManager.getObject("level_fail_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _glowMC.touchable = false;
            
            _root.pivotX = _root.width * 0.5;
            _root.pivotY = _root.height * 0.5;

            StageUtil.fitPopup(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }

        override protected function activate():void
        {
            _ship.addChild(new FakeShipView(1.7, 0, false));

            _menuButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _replayButton.addEventListener(Event.TRIGGERED, handleTriggered);

            if (Application.appController.space.ship.durability == 0)
            {
                _titleTF.text = Application.uiBuilder.localization.getLocalizedText("ShipIsCrashed");
            } else if (Application.appController.space.ship.fuel == 0)
            {
                _titleTF.text = Application.uiBuilder.localization.getLocalizedText("OutOfFuel");
            } else {
                _titleTF.text = Application.uiBuilder.localization.getLocalizedText("ShipIsLost");
            }

            var reward: int = Application.appController.space.orders.money;
            _rewardTF.text = StringUtils.formatNumberDelimeter(reward, " ");
            _container.readjustLayout();
            _container.validate();

            Starling.juggler.add(_glowMC);
        }

        override public function setup():void
        {
            SoundManager.playSound(SoundManager.POPUP_LOSE);
        }

        override protected function deactivate():void
        {
            _menuButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _replayButton.removeEventListener(Event.TRIGGERED, handleTriggered);

            Starling.juggler.remove(_glowMC);
        }

        private function handleTriggered(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            WindowManager.closePopup(this, true);
            
            switch (event.currentTarget)
            {
                case _menuButton:
                {
                    TaskSystem.getInstance().addTask(new EndGameTask());
                    break;
                }
                case _replayButton:
                {
                    TaskSystem.getInstance().addTask(new RestartGameTask());
                    break;
                }
            }
        }
    }
}
