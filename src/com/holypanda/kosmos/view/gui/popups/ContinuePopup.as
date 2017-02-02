/**
 * Created by agnither on 21.01.17.
 */
package com.holypanda.kosmos.view.gui.popups
{
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Popup;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.tasks.logic.game.ReviveTask;

    import feathers.controls.LayoutGroup;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class ContinuePopup extends Popup
    {
        public var _root: LayoutGroup;

        public var _titleTF: TextField;

        public var _icon_fuel: Image;
        public var _icon_repair: Image;

        public var _closeButton: ContainerButton;
        public var _noVideoButton: ContainerButton;
        public var _watchButton: ContainerButton;
        public var _noVideoTF: TextField;
        public var _watchTF: TextField;
        
        public function ContinuePopup()
        {
            super(0, 1);
            
            var data: Object = Application.assetsManager.getObject("continue_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _root.pivotX = _root.width * 0.5;
            _root.pivotY = _root.height * 0.5;

            var repair: Boolean = Application.appController.space.ship.durability == 0;
            
            _icon_repair.visible = repair;
            _icon_fuel.visible = !repair;

            _titleTF.text = Application.uiBuilder.localization.getLocalizedText(repair ? "Repair" : "FuelUp");
            _noVideoTF.text = Application.uiBuilder.localization.getLocalizedText("NoVideo");
            _watchTF.text = Application.uiBuilder.localization.getLocalizedText("Watch");

            StageUtil.fitPopup(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }

        override protected function activate():void
        {
            _closeButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _noVideoButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _watchButton.addEventListener(Event.TRIGGERED, handleTriggered);
        }

        override protected function deactivate():void
        {
            _closeButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _noVideoButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _watchButton.removeEventListener(Event.TRIGGERED, handleTriggered);
        }

        override protected function cancelHandler():void
        {
//            WindowManager.closePopup(this, true);
        }

        private function handleTriggered(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            WindowManager.closePopup(this, true);

            switch (event.currentTarget)
            {
                case _closeButton:
                {
                    Application.appController.reviveGame(false);
                    break;
                }
                case _noVideoButton:
                {
                    WindowManager.showPopup(new NoVideoPopup(), true);
                    break;
                }
                case _watchButton:
                {
                    TaskSystem.getInstance().addTask(new ReviveTask());
                    break;
                }
            }
        }
    }
}
