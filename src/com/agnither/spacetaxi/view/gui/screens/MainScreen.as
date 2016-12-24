/**
 * Created by agnither on 22.12.16.
 */
package com.agnither.spacetaxi.view.gui.screens
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.tasks.logic.StartGameTask;
    import com.agnither.spacetaxi.view.gui.items.FakeShipView;
    import com.agnither.spacetaxi.view.utils.Animator;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.Screen;

    import feathers.controls.LayoutGroup;

    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.extensions.TextureMaskStyle;

    import starlingbuilder.engine.util.StageUtil;

    public class MainScreen extends Screen
    {
        public static var SKINS: Array = ["1", "2", "3", "5", "6", "7", "8", "9", "10", "12"];

        public var _root: LayoutGroup;

        public var _back: Image;
        public var _glow: Image;
        public var _planet1: Image;
        public var _planet1Mask: Image;
        public var _planet2: Image;
        public var _planet2Mask: Image;
        public var _shipShadow1: Sprite;
        public var _shipShadow2: Sprite;
        public var _ship: Sprite;
        public var _shipContainer: Sprite;

        public var _achievementsButton: Button;
        public var _achievementsLabel: Image;

        public var _chooseLevelButton: Button;
        public var _chooseLevelLabel: Image;

        public var _freeCoinsButton: Button;
        public var _freeCoinsLabel: Image;

        public var _garageButton: Button;
        public var _garageLabel: Image;

        public var _playButton: Button;
        public var _playLabel: Image;

        public function MainScreen()
        {
            super(0, 0);

            var data: Object = Application.assetsManager.getObject("main_screen");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _achievementsLabel.touchable = false;
            _chooseLevelLabel.touchable = false;
            _freeCoinsLabel.touchable = false;
            _garageLabel.touchable = false;
            _playLabel.touchable = false;

            const delta: Number = 0.03;
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _achievementsButton.pivotY = Math.sin(time) * _achievementsButton.height * delta;
                _achievementsLabel.pivotY = Math.sin(time) * _achievementsButton.height * delta;
            });
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _chooseLevelButton.pivotY = Math.sin(time) * _chooseLevelButton.height * delta;
                _chooseLevelLabel.pivotY = Math.sin(time) * _chooseLevelButton.height * delta;
            });
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _freeCoinsButton.pivotY = Math.sin(time) * _freeCoinsButton.height * delta;
                _freeCoinsLabel.pivotY = Math.sin(time) * _freeCoinsButton.height * delta;
            });
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _garageButton.pivotY = Math.sin(time) * _garageButton.height * delta;
                _garageLabel.pivotY = Math.sin(time) * _garageButton.height * delta;
            });
            Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _playButton.pivotY = Math.sin(time) * _playButton.height * delta;
                _playLabel.pivotY = Math.sin(time) * _playButton.height * delta;
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
            Animator.create(0.2, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _glow.rotation = -time;
            });
            Animator.create(0.6, Math.random() * Math.PI * 2, function (time: Number):void
            {
                _shipShadow1.rotation = time;
                _shipShadow2.rotation = time;
                _ship.rotation = time;
            });

            var rand1: int = Math.random() * SKINS.length;
            var rand2: int = rand1;
            while (rand2 == rand1)
            {
                rand2 = Math.random() * SKINS.length;
            }

            _planet1.texture = Application.assetsManager.getTexture("planets/" + SKINS[rand1]);
            _planet1Mask.texture = Application.assetsManager.getTexture("planets/" + SKINS[rand1]);
            _planet2.texture = Application.assetsManager.getTexture("planets/" + SKINS[rand2]);
            _planet2Mask.texture = Application.assetsManager.getTexture("planets/" + SKINS[rand2]);

            _planet1Mask.style = new TextureMaskStyle();
            _shipShadow1.mask = _planet1Mask;

            _planet2Mask.style = new TextureMaskStyle();
            _shipShadow2.mask = _planet2Mask;

            _shipContainer.addChild(new FakeShipView());

            _playButton.addEventListener(Event.TRIGGERED, handlePlay);

            StageUtil.fitAll(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);

            _back.width = stage.stageWidth;
            _back.height = stage.stageHeight;
        }

        private function handlePlay(event: Event):void
        {
            TaskSystem.getInstance().addTask(new StartGameTask());
        }
    }
}
