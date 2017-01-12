/**
 * Created by agnither on 10.01.17.
 */
package com.agnither.spacetaxi.view.gui.items
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.tasks.logic.StartGameTask;
    import com.agnither.spacetaxi.view.utils.Animator;
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.AbstractComponent;

    import feathers.controls.LayoutGroup;

    import starling.core.Starling;

    import starling.display.Button;
    import starling.display.ButtonState;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class LevelView extends AbstractComponent
    {
        private var _level: LevelVO;
        
        public var _back: Image;

        public var _star1: Button;
        public var _star2: Button;
        public var _star3: Button;

        public var _glow: Image;
        public var _planetBtn: ContainerButton;
        public var _planetImage: Image;

        public var _levelNameTF: TextField;

        public function LevelView(level: LevelVO)
        {
            _level = level;
            
            super();

            var data: Object = Application.assetsManager.getObject("level");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _star1.touchable = false;
            _star2.touchable = false;
            _star3.touchable = false;

            _planetImage.texture = Application.assetsManager.getTexture("planets/" + _level.planets[0].skin);

            _levelNameTF.text = "Level " + (_level.id+1);

            _planetBtn.addEventListener(Event.TRIGGERED, handleTriggered);
            
            if (_level.stars > 0)
            {
                _star1.state = _level.stars >= 1 ? ButtonState.UP : ButtonState.DOWN;
                _star2.state = _level.stars >= 2 ? ButtonState.UP : ButtonState.DOWN;
                _star3.state = _level.stars >= 3 ? ButtonState.UP : ButtonState.DOWN;
            } else {
                _star1.visible = false;
                _star2.visible = false;
                _star3.visible = false;
            }

            if (_level.current)
            {
                Animator.create(2, Math.random() * Math.PI * 2, function (time: Number):void
                {
                    _glow.alpha = 0.75 + Math.cos(time) * 0.25;
                });
            } else {
                _glow.visible = false;
                _planetBtn.scaleX = 0.8;
                _planetBtn.scaleY = 0.8;
            }
        }
        
        public function setActive(value: Boolean, animate: Boolean = true):void
        {
            Starling.juggler.tween(this, animate ? 0.3 : 0, {alpha: value ? 1 : 0.3});
            touchable = value;
        }

        private function handleTriggered(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            Application.appController.selectLevel(_level.id);
            TaskSystem.getInstance().addTask(new StartGameTask());
        }
    }
}
