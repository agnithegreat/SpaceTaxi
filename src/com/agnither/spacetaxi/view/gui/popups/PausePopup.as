/**
 * Created by agnither on 21.01.17.
 */
package com.agnither.spacetaxi.view.gui.popups
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.Config;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.model.player.Volume;
    import com.agnither.spacetaxi.tasks.logic.EndGameTask;
    import com.agnither.spacetaxi.tasks.logic.RestartGameTask;
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Popup;

    import feathers.controls.LayoutGroup;

    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class PausePopup extends Popup
    {
        public var _root: LayoutGroup;

        public var _menuButton: ContainerButton;
        public var _replayButton: ContainerButton;
        public var _resumeButton: ContainerButton;

        public var _musicOnBtn: Button;
        public var _musicOffBtn: Button;
        public var _soundOnBtn: Button;
        public var _soundOffBtn: Button;

        public var _levelTF: TextField;
        public var _titleTF: TextField;
        public var _descriptionTF: TextField;

        public function PausePopup()
        {
            super(0, 1);

            var data: Object = Application.assetsManager.getObject("pause_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _root.pivotX = _root.width * 0.5;
            _root.pivotY = _root.height * 0.5;

            StageUtil.fitPopup(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }

        override protected function activate():void
        {
            var level: LevelVO = Application.appController.levelsController.currentLevel;

            _menuButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _replayButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _resumeButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _musicOnBtn.addEventListener(Event.TRIGGERED, handleTriggered);
            _musicOffBtn.addEventListener(Event.TRIGGERED, handleTriggered);
            _soundOnBtn.addEventListener(Event.TRIGGERED, handleTriggered);
            _soundOffBtn.addEventListener(Event.TRIGGERED, handleTriggered);
            
            Config.volume.addEventListener(Volume.UPDATE, handleUpdate);
            handleUpdate(null);

            _levelTF.text = "Level " + (level.id + 1);
            _titleTF.text = level.title;
//            _descriptionTF.text = level.title;
        }

        override protected function deactivate():void
        {
            _menuButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _replayButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _resumeButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _musicOnBtn.removeEventListener(Event.TRIGGERED, handleTriggered);
            _musicOffBtn.removeEventListener(Event.TRIGGERED, handleTriggered);
            _soundOnBtn.removeEventListener(Event.TRIGGERED, handleTriggered);
            _soundOffBtn.removeEventListener(Event.TRIGGERED, handleTriggered);
        }

        private function handleUpdate(event: Event):void
        {
            _musicOnBtn.visible = Config.volume.music > 0;
            _musicOffBtn.visible = Config.volume.music == 0;
            _soundOnBtn.visible = Config.volume.sound > 0;
            _soundOffBtn.visible = Config.volume.sound == 0;
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
                case _menuButton:
                {
                    WindowManager.closePopup(this, true);
                    TaskSystem.getInstance().addTask(new EndGameTask());
                    break;
                }
                case _replayButton:
                {
                    WindowManager.closePopup(this, true);
                    TaskSystem.getInstance().addTask(new RestartGameTask());
                    break;
                }
                case _resumeButton:
                {
                    WindowManager.closePopup(this, true);
                    break;
                }
                    
                case _musicOnBtn:
                {
                    Config.volume.setMusic(false);
                    break;
                }
                case _musicOffBtn:
                {
                    Config.volume.setMusic(true);
                    break;
                }
                case _soundOnBtn:
                {
                    Config.volume.setSound(false);
                    break;
                }
                case _soundOffBtn:
                {
                    Config.volume.setSound(true);
                    break;
                }
            }
        }
    }
}
