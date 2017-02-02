/**
 * Created by agnither on 21.01.17.
 */
package com.holypanda.kosmos.view.gui.popups
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.controller.SocialController;
    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.model.player.Volume;
    import com.holypanda.kosmos.tasks.logic.EnterTask;
    import com.holypanda.kosmos.tasks.logic.FeedbackTask;

    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Popup;
    import com.holypanda.kosmos.tasks.logic.UnlinkTask;

    import feathers.controls.LayoutGroup;

    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class SettingsPopup extends Popup
    {
        public var _root: LayoutGroup;

        public var _loginTF: TextField;
        public var _soundTF: TextField;

        public var _closeButton: ContainerButton;

        public var _buttons: LayoutGroup;
        public var _fbButton: Button;
        public var _vkButton: Button;

        public var _logoutButton: ContainerButton;
        public var _icon_vk: Image;
        public var _icon_fb: Image;
        public var _logoutTF: TextField;

        public var _musicOnBtn: Button;
        public var _musicOffBtn: Button;
        public var _soundOnBtn: Button;
        public var _soundOffBtn: Button;

        public var _feedbackButton: ContainerButton;
        public var _feedbackTF: TextField;

        public function SettingsPopup()
        {
            super(0, 1);

            var data: Object = Application.assetsManager.getObject("settings_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _loginTF.text = Application.uiBuilder.localization.getLocalizedText("LogIn");
            _soundTF.text = Application.uiBuilder.localization.getLocalizedText("Sound");
            _feedbackTF.text = Application.uiBuilder.localization.getLocalizedText("Support");

            _root.pivotX = _root.width * 0.5;
            _root.pivotY = _root.height * 0.5;

            StageUtil.fitPopup(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }

        override protected function activate():void
        {
            _closeButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _fbButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _vkButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _logoutButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _musicOnBtn.addEventListener(Event.TRIGGERED, handleTriggered);
            _musicOffBtn.addEventListener(Event.TRIGGERED, handleTriggered);
            _soundOnBtn.addEventListener(Event.TRIGGERED, handleTriggered);
            _soundOffBtn.addEventListener(Event.TRIGGERED, handleTriggered);
            _feedbackButton.addEventListener(Event.TRIGGERED, handleTriggered);
            
            Config.volume.addEventListener(Volume.UPDATE, handleVolumeUpdate);
            handleVolumeUpdate(null);

            Application.appController.social.addEventListener(SocialController.UPDATE, handleSocialUpdate);
            handleSocialUpdate(null);
        }

        override protected function deactivate():void
        {
            _closeButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _fbButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _vkButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _logoutButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _musicOnBtn.removeEventListener(Event.TRIGGERED, handleTriggered);
            _musicOffBtn.removeEventListener(Event.TRIGGERED, handleTriggered);
            _soundOnBtn.removeEventListener(Event.TRIGGERED, handleTriggered);
            _soundOffBtn.removeEventListener(Event.TRIGGERED, handleTriggered);
            _feedbackButton.removeEventListener(Event.TRIGGERED, handleTriggered);

            Config.volume.removeEventListener(Volume.UPDATE, handleVolumeUpdate);
            Application.appController.social.removeEventListener(SocialController.UPDATE, handleSocialUpdate);
        }

        private function handleVolumeUpdate(event: Event):void
        {
            _musicOnBtn.visible = Config.volume.music > 0;
            _musicOffBtn.visible = Config.volume.music == 0;
            _soundOnBtn.visible = Config.volume.sound > 0;
            _soundOffBtn.visible = Config.volume.sound == 0;
        }

        private function handleSocialUpdate(event: Event):void
        {
            var loggedTo: AuthMethod = Application.appController.social.loggedTo;
            _buttons.visible = loggedTo == null;
            _logoutButton.visible = loggedTo != null;
            _icon_vk.visible = loggedTo == AuthMethod.VK;
            _icon_fb.visible = loggedTo == AuthMethod.FB;
        }

        override protected function cancelHandler():void
        {
            WindowManager.closePopup(this, true);
        }

        private function handleTriggered(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);

            switch (event.currentTarget)
            {
                case _closeButton:
                {
                    WindowManager.closePopup(this, true);
                    break;
                }
                    
                case _fbButton:
                {
                    TaskSystem.getInstance().addTask(new EnterTask(AuthMethod.FB));
                    break;
                }
                case _vkButton:
                {
                    TaskSystem.getInstance().addTask(new EnterTask(AuthMethod.VK));
                    break;
                }
                case _logoutButton:
                {
                    TaskSystem.getInstance().addTask(new UnlinkTask());
                    break;
                }

                case _musicOnBtn:
                {
                    Config.volume.setMusic(false);
                    Config.volume.save();
                    break;
                }
                case _musicOffBtn:
                {
                    Config.volume.setMusic(true);
                    Config.volume.save();
                    break;
                }
                case _soundOnBtn:
                {
                    Config.volume.setSound(false);
                    Config.volume.save();
                    break;
                }
                case _soundOffBtn:
                {
                    Config.volume.setSound(true);
                    Config.volume.save();
                    break;
                }
                    
                case _feedbackButton:
                {
//                    WindowManager.showPopup(new ModalPopup(), true);
                    TaskSystem.getInstance().addTask(new FeedbackTask());
                    break;
                }
            }
        }
    }
}
