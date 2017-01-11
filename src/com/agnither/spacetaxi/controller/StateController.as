package com.agnither.spacetaxi.controller
{
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.view.gui.screens.EpisodeScreen;
    import com.agnither.spacetaxi.view.gui.screens.GameScreen;
    import com.agnither.spacetaxi.view.gui.screens.LevelScreen;
    import com.agnither.spacetaxi.view.gui.screens.MainScreen;
    import com.agnither.spacetaxi.view.scenes.game.SpaceView;
    import com.agnither.utils.gui.components.Screen;

    import flash.utils.Dictionary;

    public class StateController
    {
        public static const MAIN: String = "StateController.MAIN";
        public static const EPISODE: String = "StateController.EPISODE";
        public static const LEVEL: String = "StateController.LEVEL";
        public static const GAME: String = "StateController.GAME";
        
        private var _statesStack: Array;
        public function get currentState():String 
        {
            return _statesStack != null ? _statesStack[_statesStack.length-1] : null;
        }

        public function get currentScreen():Screen
        {
            return _screens[currentState];
        }
        
        public function get isStart():Boolean
        {
            return _statesStack.length == 1;
        }
        
        private var _screens: Dictionary;
        private var _scenes: Dictionary;

        public function StateController()
        {
        }

        public function init():void
        {
            _screens = new Dictionary();
            _screens[MAIN] = new MainScreen();
            _screens[EPISODE] = new EpisodeScreen();
            _screens[LEVEL] = new LevelScreen();
            _screens[GAME] = new GameScreen();

            _scenes = new Dictionary();
            _scenes[GAME] = new SpaceView();

            _statesStack = [];
        }

        public function mainState():void
        {
            setState(MAIN);
        }
        
        public function episodeState():void
        {
            setState(EPISODE);
        }

        public function levelState():void
        {
            setState(LEVEL);
        }

        public function gameState():void
        {
            setState(GAME);
        }

        public function goBack(force: Boolean = false):void
        {
            if (force || currentScreen.tryClose())
            {
                removeState();
                updateState();
            }
        }

        public function goStart():void
        {
            while (_statesStack.length > 1)
            {
                removeState();
            }
            updateState();
        }

        public function removeState(state: String = null):void
        {
            if (state != null)
            {
                var index: int = _statesStack.indexOf(state);
                if (index < 0) return;
                _statesStack.splice(index, 1);
            } else {
                state = _statesStack.pop();
            }

            switch (state)
            {
                case MAIN:
                {
                    break;
                }
                case GAME:
                {
                    SoundManager.stopMusic(SoundManager.GAMEPLAY);
                    SoundManager.playMusic(SoundManager.MENU);
                    break;
                }
            }
        }

        private function setState(state: String):void
        {
            if (_statesStack.indexOf(state) >= 0) return;

            _statesStack.push(state);
            updateState();
        }

        private function updateState():void
        {
            switch (currentState)
            {
                case MAIN:
                {
//                    Application.appController.services.checkAds();
                    SoundManager.stopMusic(SoundManager.GAMEPLAY);
                    SoundManager.playMusic(SoundManager.MENU);
                    break;
                }
                case GAME:
                {
                    SoundManager.stopMusic(SoundManager.MENU);
                    SoundManager.playMusic(SoundManager.GAMEPLAY);
                    break;
                }
            }

            WindowManager.showScene(_scenes[currentState]);
            WindowManager.showScreen(_screens[currentState]);
        }
    }
}
