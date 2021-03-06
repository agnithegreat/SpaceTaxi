/**
 * Created by agnither on 22.12.16.
 */
package com.holypanda.kosmos.view.gui.screens
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.tasks.logic.FreeCoinsTask;
    import com.holypanda.kosmos.tasks.logic.game.SelectLevelTask;
    import com.holypanda.kosmos.utils.StringUtils;
    import com.holypanda.kosmos.view.gui.items.FakeShipView;
    import com.holypanda.kosmos.view.gui.popups.SettingsPopup;
    import com.holypanda.kosmos.view.utils.Animator;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Screen;

    import feathers.controls.LayoutGroup;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class MainScreen extends Screen
    {
        public static var SKINS: Array = ["0", "1/1", "1/2", "1/3", "1/4", "1/5", "1/6", "1/7", "1/8", "1/9", "1/10", "1/11", "1/12", "2/1", "2/2", "2/3", "2/4", "2/5", "2/6", "2/7", "2/8", "2/9", "2/10", "2/11", "2/12"];

        public var _root: LayoutGroup;

        public var _back: Image;
        public var _glow: Sprite;
        public var _planet1: Image;
        public var _planet1Mask: Image;
        public var _planet2: Image;
        public var _planet2Mask: Image;
        public var _shipShadow1: Sprite;
        public var _shipShadow2: Sprite;
        public var _ship: Sprite;
        public var _shipContainer: Sprite;

        public var _achievementsButton: ContainerButton;
        public var _chooseLevelButton: ContainerButton;
        public var _freeCoinsButton: ContainerButton;
        public var _garageButton: ContainerButton;
        public var _playButton: ContainerButton;
        public var _settingsButton: ContainerButton;

        public var _achievementsTF: TextField;
        public var _levelsTF: TextField;
        public var _freeCoinsTF: TextField;
        public var _garageTF: TextField;

        public var _playLabel_ru: Image;
        public var _playLabel_en: Image;
        public var _settingsTF: TextField;

        public function MainScreen()
        {
            super(0, 0);

            var data: Object = Application.assetsManager.getObject("main_screen");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            for (var i:int = 0; i < 36; i++)
            {
                var ray: Image = new Image(Application.assetsManager.getTexture("main_screen/ray"));
                ray.pivotY = ray.height * 0.5;
                ray.rotation = i / 18 * Math.PI;
                _glow.addChild(ray);
            }

            const delta: Number = 0.03;
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _achievementsButton.pivotY = Math.sin(time) * _achievementsButton.height * delta;
            });
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _chooseLevelButton.pivotY = Math.sin(time) * _chooseLevelButton.height * delta;
            });
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _freeCoinsButton.pivotY = Math.sin(time) * _freeCoinsButton.height * delta;
            });
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _garageButton.pivotY = Math.sin(time) * _garageButton.height * delta;
            });
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _playButton.pivotY = Math.sin(time) * _playButton.height * delta;
            });

            var scale: Number = 0.44;
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _planet1.scaleX = scale + Math.cos(time) * delta;
                _planet1Mask.scaleX = scale + Math.cos(time) * delta;
                _planet1.scaleY = scale + Math.cos(time + Math.PI) * delta;
                _planet1Mask.scaleY = scale + Math.cos(time + Math.PI) * delta;
            });
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _planet2.scaleX = scale + Math.cos(time) * delta;
                _planet2Mask.scaleX = scale + Math.cos(time) * delta;
                _planet2.scaleY = scale + Math.cos(time + Math.PI) * delta;
                _planet2Mask.scaleY = scale + Math.cos(time + Math.PI) * delta;
            });
            Animator.create(0.14, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _glow.rotation = -time;
            });
            Animator.create(0.6, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _shipShadow1.rotation = time;
                _shipShadow2.rotation = time;
                _ship.rotation = time;
            });

            _shipShadow1.mask = _planet1Mask;
            _shipShadow2.mask = _planet2Mask;

            _shipContainer.addChild(new FakeShipView(0.35, Math.PI * 0.5, true));

            _achievementsButton.enabled = false;
            _freeCoinsButton.enabled = false;
            _garageButton.enabled = false;

            _playLabel_ru.visible = Config.locale == "ru";
            _playLabel_en.visible = Config.locale == "en";

            _freeCoinsTF.text = StringUtils.format(_freeCoinsTF.text, 1000);

            StageUtil.fitAll(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);

            _back.width = stage.stageWidth;
            _back.height = stage.stageHeight;
        }

        override protected function activate():void
        {
            _achievementsButton.addEventListener(Event.TRIGGERED, handleAchievements);
            _chooseLevelButton.addEventListener(Event.TRIGGERED, handleChooseLevel);
            _freeCoinsButton.addEventListener(Event.TRIGGERED, handleFreeCoins);
            _garageButton.addEventListener(Event.TRIGGERED, handleGarage);
            _playButton.addEventListener(Event.TRIGGERED, handlePlay);
            _settingsButton.addEventListener(Event.TRIGGERED, handleSettings);

            var max: int = Math.min(Application.appController.player.level + 2, SKINS.length);
            var rand1: int = Math.random() * max;
            var rand2: int = rand1;
            while (rand2 == rand1)
            {
                rand2 = Math.random() * max;
            }

            _planet1.texture = Application.assetsManager.getTexture("planets/" + SKINS[rand1]);
            _planet1Mask.texture = _planet1.texture;

            _planet2.texture = Application.assetsManager.getTexture("planets/" + SKINS[rand2]);
            _planet2Mask.texture = _planet2.texture;
        }

        override protected function deactivate():void
        {
            _achievementsButton.removeEventListener(Event.TRIGGERED, handleAchievements);
            _chooseLevelButton.removeEventListener(Event.TRIGGERED, handleChooseLevel);
            _freeCoinsButton.removeEventListener(Event.TRIGGERED, handleFreeCoins);
            _garageButton.removeEventListener(Event.TRIGGERED, handleGarage);
            _playButton.removeEventListener(Event.TRIGGERED, handlePlay);
            _settingsButton.removeEventListener(Event.TRIGGERED, handleSettings);
        }

        private function handleAchievements(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
        }

        private function handleChooseLevel(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            Application.appController.states.episodeState();
        }

        private function handleFreeCoins(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            TaskSystem.getInstance().addTask(new FreeCoinsTask());
        }

        private function handleGarage(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
        }

        private function handlePlay(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            TaskSystem.getInstance().addTask(new SelectLevelTask());
        }

        private function handleSettings(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            WindowManager.showPopup(new SettingsPopup(), true);
        }
    }
}
