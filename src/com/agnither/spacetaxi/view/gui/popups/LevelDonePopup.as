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
    import com.agnither.spacetaxi.tasks.logic.game.SelectLevelTask;
    import com.agnither.spacetaxi.view.gui.items.FakeShipView;
    import com.agnither.spacetaxi.view.utils.Animator;
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Popup;

    import feathers.controls.ButtonState;
    import feathers.controls.LayoutGroup;

    import starling.core.Starling;

    import starling.display.Button;
    import starling.display.Image;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class LevelDonePopup extends Popup
    {
        public var _root: LayoutGroup;

        public var _ship: Sprite;
        
        public var _glow: Image;
        public var _glowMC: MovieClip;

        public var _replayButton: ContainerButton;
        public var _nextButton: ContainerButton;

        public var _textTF: TextField;
        public var _rewardTF: TextField;

        public var _star1: Button;
        public var _star2: Button;
        public var _star3: Button;
        
        private var _level: LevelVO;

        public function LevelDonePopup()
        {
            super(0, 1);

            var data: Object = Application.assetsManager.getObject("level_done_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            SoundManager.playSound(SoundManager.POPUP_WIN_LEVEL);
            
            _star1.touchable = false;
            _star2.touchable = false;
            _star3.touchable = false;

            _glowMC.touchable = false;

            _root.pivotX = _root.width * 0.5;
            _root.pivotY = _root.height * 0.5;

            StageUtil.fitPopup(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);

            Animator.create(0.125, 0, function (time: Number):void
            {
                _glow.rotation = time;
            });
        }

        override protected function activate():void
        {
            _level = Application.appController.levelsController.currentLevel;

            _replayButton.addEventListener(Event.TRIGGERED, handleTriggered);
            _nextButton.addEventListener(Event.TRIGGERED, handleTriggered);

            _ship.addChild(new FakeShipView(1.7, 0, false));

            var progress: Progress = Application.appController.player.progress;
            var result: LevelResultVO = progress.getLevelResult(_level.id);
            _star1.state = result != null && result.stars >= 1 ? ButtonState.DOWN : ButtonState.UP;
            _star2.state = result != null && result.stars >= 2 ? ButtonState.DOWN : ButtonState.UP;
            _star3.state = result != null && result.stars >= 3 ? ButtonState.DOWN : ButtonState.UP;
            
            _rewardTF.text = String(result.money);
            _root.validate();

            Starling.juggler.add(_glowMC);
        }

        override protected function deactivate():void
        {
            _replayButton.removeEventListener(Event.TRIGGERED, handleTriggered);
            _nextButton.removeEventListener(Event.TRIGGERED, handleTriggered);

            _level = null;
            
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
                case _replayButton:
                {
                    TaskSystem.getInstance().addTask(new RestartGameTask());
                    break;
                }
                case _nextButton:
                {
                    TaskSystem.getInstance().addTask(new SelectLevelTask(_level.id+1));
                    break;
                }
            }
        }
    }
}
