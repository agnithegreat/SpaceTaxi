/**
 * Created by agnither on 10.01.17.
 */
package com.agnither.spacetaxi.view.gui.items
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.model.player.Progress;
    import com.agnither.spacetaxi.model.player.vo.LevelResultVO;
    import com.agnither.spacetaxi.tasks.logic.game.SelectLevelTask;
    import com.agnither.spacetaxi.view.utils.Animator;
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.tasks.global.TaskSystem;
    import com.agnither.utils.gui.components.AbstractComponent;

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

        public var _arrow: Image;

        public var _glow: Image;
        public var _glowCircle: Image;
        public var _planetBtn: ContainerButton;
        public var _planetImage: Image;
        public var _shadowBtn: ContainerButton;
        public var _shadow: Image;

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
            _arrow.touchable = false;

            _planetImage.texture = Application.assetsManager.getTexture("planets/" + (_level.episode+1) + "/" + (_level.id % 12 + 1));

            _levelNameTF.text = _level.title || "Level " + (_level.id+1);

            _planetBtn.addEventListener(Event.TRIGGERED, handleTriggered);
            _shadowBtn.addEventListener(Event.TRIGGERED, handleTriggered);

            var progress: Progress = Application.appController.player.progress;
            var current: Boolean = _level.id == progress.level;
            var locked: Boolean = _level.id > progress.level;
            var result: LevelResultVO = progress.getLevelResult(_level.id);

            _planetBtn.visible = !locked;
            _shadowBtn.visible = locked;
            _glow.visible = current;
            _glowCircle.visible = current;
            _arrow.visible = current;

            if (result != null && result.stars > 0)
            {
                _star1.state = result.stars >= 1 ? ButtonState.UP : ButtonState.DOWN;
                _star2.state = result.stars >= 2 ? ButtonState.UP : ButtonState.DOWN;
                _star3.state = result.stars >= 3 ? ButtonState.UP : ButtonState.DOWN;
            } else {
                _star1.visible = false;
                _star2.visible = false;
                _star3.visible = false;
            }

            if (current)
            {
                Animator.create(2, Math.random() * Math.PI * 2, function (time:Number):void
                {
                    _glow.alpha = 0.75 + Math.cos(time) * 0.25;
                    _glowCircle.rotation = time * 0.25;
                    _arrow.pivotY = _arrow.height * Math.sin(time) * 0.5;
                });
            } else {
                Animator.create(1, Math.random() * Math.PI * 2, function (time: Number):void
                {
                    _shadow.rotation = -time * 0.125;
                });
            }
        }
        
        public function setActive(value: Boolean, animate: Boolean = true):void
        {
            Starling.juggler.tween(this, animate ? 0.3 : 0, {alpha: value ? 1 : 0.3});
            touchable = value;
        }

        private function handleTriggered(event: Event):void
        {
            if (event.currentTarget == _planetBtn)
            {
                SoundManager.playSound(SoundManager.CLICK);
                TaskSystem.getInstance().addTask(new SelectLevelTask(_level.id));
            } else if (event.currentTarget == _shadowBtn)
            {
                SoundManager.playSound(SoundManager.UNAVAILABLE_PLANET);
            }
        }
        
        override public function dispose():void
        {
            _planetBtn.removeEventListener(Event.TRIGGERED, handleTriggered);
            _level = null;
            
            super.dispose();
        }
    }
}
