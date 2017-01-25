/**
 * Created by agnither on 21.01.17.
 */
package com.agnither.spacetaxi.view.gui.popups
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.controller.StateController;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.model.player.Progress;
    import com.agnither.spacetaxi.model.player.vo.LevelResultVO;
    import com.agnither.spacetaxi.tasks.logic.game.EndGameTask;
    import com.agnither.spacetaxi.tasks.logic.game.RestartGameTask;
    import com.agnither.spacetaxi.tasks.logic.game.StartGameTask;
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Popup;

    import feathers.controls.ButtonState;
    import feathers.controls.LayoutGroup;

    import starling.core.Starling;
    import starling.display.Button;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class LevelStartPopup extends Popup
    {
        public var _root: LayoutGroup;

        public var _glowMC: MovieClip;

        public var _playButton: ContainerButton;
        public var _closeButton: ContainerButton;

        public var _titleTF: TextField;
        public var _descriptionTF: TextField;
        public var _textTF: TextField;
        public var _rewardTF: TextField;

        public var _star1: Button;
        public var _star2: Button;
        public var _star3: Button;

        public function LevelStartPopup()
        {
            super(0, 1);

            var data: Object = Application.assetsManager.getObject("level_start_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            SoundManager.playSound(SoundManager.POPUP_REWARD);

            _star1.touchable = false;
            _star2.touchable = false;
            _star3.touchable = false;

            _glowMC.touchable = false;

            _root.pivotX = _root.width * 0.5;
            _root.pivotY = _root.height * 0.5;

            StageUtil.fitPopup(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }

        override protected function activate():void
        {
            var level: LevelVO = Application.appController.levelsController.currentLevel;

            _closeButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _playButton.addEventListener(Event.TRIGGERED, handleTriggered);

            _titleTF.text = level.title;
            _descriptionTF.text = "Transport every passenger to his destination to complete the level";

            _rewardTF.text = String(level.reward);
            _root.validate();

            var progress: Progress = Application.appController.player.progress;
            var result: LevelResultVO = progress.getLevelResult(level.id);
            _star1.state = result != null && result.stars >= 1 ? ButtonState.DOWN : ButtonState.UP;
            _star2.state = result != null && result.stars >= 2 ? ButtonState.DOWN : ButtonState.UP;
            _star3.state = result != null && result.stars >= 3 ? ButtonState.DOWN : ButtonState.UP;

            Starling.juggler.add(_glowMC);
        }

        override protected function deactivate():void
        {
            _closeButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _playButton.removeEventListener(Event.TRIGGERED, handleTriggered);

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
                case _closeButton:
                {
                    if (Application.appController.states.currentState == StateController.GAME)
                    {
                        TaskSystem.getInstance().addTask(new EndGameTask());
                    }
                    break;
                }
                case _playButton:
                {
                    if (Application.appController.states.currentState == StateController.GAME)
                    {
                        TaskSystem.getInstance().addTask(new RestartGameTask());
                    } else {
                        TaskSystem.getInstance().addTask(new StartGameTask());
                    }
                    break;
                }
            }
            
        }
    }
}
