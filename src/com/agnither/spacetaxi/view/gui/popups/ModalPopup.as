/**
 * Created by agnither on 21.01.17.
 */
package com.agnither.spacetaxi.view.gui.popups
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.tasks.logic.FeedbackTask;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Popup;

    import feathers.controls.LayoutGroup;

    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class ModalPopup extends Popup
    {
        public var _root: LayoutGroup;

        public var _titleTF: TextField;
        public var _descriptionTF: TextField;
        
        public var _closeButton: ContainerButton;
        public var _firstButton: ContainerButton;
        public var _secondButton: ContainerButton;
        public var _firstTF: TextField;
        public var _secondTF: TextField;

        public function ModalPopup()
        {
            super(0, 1);

            var data: Object = Application.assetsManager.getObject("modal_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _root.pivotX = _root.width * 0.5;
            _root.pivotY = _root.height * 0.5;

            _titleTF.text = Application.uiBuilder.localization.getLocalizedText("Survey");
            _descriptionTF.text = Application.uiBuilder.localization.getLocalizedText("SurveyDescription");
            _firstTF.text = Application.uiBuilder.localization.getLocalizedText("Start");
            _secondTF.text = Application.uiBuilder.localization.getLocalizedText("Later");

            StageUtil.fitPopup(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }

        override protected function activate():void
        {
            _closeButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _firstButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _secondButton.addEventListener(Event.TRIGGERED, handleTriggered);
        }

        override protected function deactivate():void
        {
            _closeButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _firstButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _secondButton.removeEventListener(Event.TRIGGERED, handleTriggered);
        }

        override protected function cancelHandler():void
        {
            WindowManager.closePopup(this, true);
        }

        private function handleTriggered(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            WindowManager.closePopup(this, true);

            switch (event.currentTarget)
            {
                case _closeButton:
                {
                    break;
                }
                case _firstButton:
                {
                    TaskSystem.getInstance().addTask(new FeedbackTask());
                    break;
                }
                case _secondButton:
                {
                    break;
                }
            }
        }
    }
}
