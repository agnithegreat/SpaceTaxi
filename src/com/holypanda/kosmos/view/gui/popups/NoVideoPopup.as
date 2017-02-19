/**
 * Created by agnither on 21.01.17.
 */
package com.holypanda.kosmos.view.gui.popups
{
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Popup;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.Services;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.tasks.logic.PurchaseTask;

    import feathers.controls.LayoutGroup;

    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class NoVideoPopup extends Popup
    {
        public var _root: LayoutGroup;

        public var _titleTF: TextField;
        public var _descriptionTF: TextField;
        
        public var _closeButton: ContainerButton;
        public var _noThanksButton: ContainerButton;
        public var _buyButton: ContainerButton;
        public var _noThanksTF: TextField;
        public var _buyTF: TextField;

        public function NoVideoPopup()
        {
            super(0, 1);

            var data: Object = Application.assetsManager.getObject("no_video_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _root.pivotX = _root.width * 0.5;
            _root.pivotY = _root.height * 0.5;

            _titleTF.text = Application.uiBuilder.localization.getLocalizedText("NoVideoTitle");
            _descriptionTF.text = Application.uiBuilder.localization.getLocalizedText("NoVideoDescription");
            _noThanksTF.text = Application.uiBuilder.localization.getLocalizedText("NoThanks");

            var item: Object = Application.appController.services.services.getProduct(Services.prefix + "noads");
            _buyTF.text = item != null ? item.price : "???";

            StageUtil.fitPopup(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }

        override protected function activate():void
        {
            _closeButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _noThanksButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _buyButton.addEventListener(Event.TRIGGERED, handleTriggered);
        }

        override protected function deactivate():void
        {
            _closeButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _noThanksButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _buyButton.removeEventListener(Event.TRIGGERED, handleTriggered);
        }

        override protected function cancelHandler():void
        {
//            WindowManager.closePopup(this, true);
        }

        private function handleTriggered(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);

            switch (event.currentTarget)
            {
                case _closeButton:
                case _noThanksButton:
                {
                    Application.appController.reviveGame(false);
                    WindowManager.closePopup(this, true);
                    break;
                }
                case _buyButton:
                {
                    TaskSystem.getInstance().addTask(new PurchaseTask(Services.prefix + "noads", handlePurchase));
                    break;
                }
            }
        }

        private function handlePurchase(value: Boolean):void
        {
            // TODO: move this block of code to right place
            if (value)
            {
                Application.appController.player.disableAds();
                Application.appController.player.save();
            }
            Application.appController.reviveGame(value);
            WindowManager.closePopup(this, true);
        }
    }
}
