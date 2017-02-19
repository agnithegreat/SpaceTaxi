/**
 * Created by agnither on 16.12.16.
 */
package com.holypanda.kosmos.view.gui.screens
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.model.Space;
    import com.holypanda.kosmos.view.gui.popups.PausePopup;

    import com.agnither.utils.gui.components.Screen;

    import feathers.controls.LayoutGroup;

    import starling.display.Button;
    import starling.display.Sprite;
    import starling.events.Event;

    import starlingbuilder.engine.util.StageUtil;

    public class GameScreen extends Screen
    {
        public var _root: LayoutGroup;
        
        public var _pauseButton: Button;

        private var _space: Space;

        public function GameScreen()
        {
            super(0, 0);

            var data: Object = Application.assetsManager.getObject("game_screen");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            StageUtil.fitAll(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }
        
        override protected function activate():void
        {
            _space = Application.appController.space;
            _space.addEventListener(Space.RESTART, handleRestart);

            _pauseButton.addEventListener(Event.TRIGGERED, handlePause);
        }

        override protected function deactivate():void
        {
            _space.removeEventListener(Space.RESTART, handleRestart);
            _space = null;

            _pauseButton.removeEventListener(Event.TRIGGERED, handlePause);
        }
        
        override public function tryClose():Boolean
        {
            // TODO: notify user
            return true;
        }

        private function handleRestart(event: Event):void
        {
            deactivate();
            activate();
        }

        private function handlePause(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            WindowManager.showPopup(new PausePopup(), true);
        }
    }
}
