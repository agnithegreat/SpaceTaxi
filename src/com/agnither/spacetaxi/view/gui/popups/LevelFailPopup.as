/**
 * Created by agnither on 21.01.17.
 */
package com.agnither.spacetaxi.view.gui.popups
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.controller.StateController;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.tasks.logic.game.EndGameTask;
    import com.agnither.spacetaxi.tasks.logic.game.RestartGameTask;
    import com.agnither.spacetaxi.view.gui.items.FakeShipView;
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
        public var _textTF: TextField;
        public var _rewardTF: TextField;

        public function LevelFailPopup()
        {
            super(0, 1);

            var data: Object = Application.assetsManager.getObject("level_fail_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            SoundManager.playSound(SoundManager.POPUP_LOSE);
            
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
                _titleTF.text = "SHIP IS CRASHED";
            } else if (Application.appController.space.ship.fuel == 0)
            {
                _titleTF.text = "OUT OF FUEL";
            } else {
                _titleTF.text = "SHIP IS LOST";
            }

            var reward: int = Application.appController.space.orders.money;
            _rewardTF.text = String(reward);
            _root.validate();

            Starling.juggler.add(_glowMC);
        }

        override protected function deactivate():void
        {
            _menuButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _replayButton.removeEventListener(Event.TRIGGERED, handleTriggered);

            Starling.juggler.remove(_glowMC);
        }

        override protected function cancelHandler():void
        {
            WindowManager.closePopup(this, true);

            if (Application.appController.states.currentState == StateController.GAME)
            {
                TaskSystem.getInstance().addTask(new EndGameTask());
            }
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
