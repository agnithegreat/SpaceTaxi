/**
 * Created by agnither on 22.12.16.
 */
package com.agnither.spacetaxi.view.gui.screens
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.events.TaskEvent;
    import com.agnither.utils.gui.components.Screen;

    import feathers.controls.LayoutGroup;

    import starling.display.Image;
    import starling.display.Sprite;

    import starlingbuilder.engine.util.StageUtil;

    public class PreloaderScreen extends Screen
    {
        public var _root: LayoutGroup;

        public var _logo: Image;
        public var _progress: Image;

        private var _task: SimpleTask;

        private var _baseScale: Number;

        public function PreloaderScreen(task: SimpleTask)
        {
            _task = task;
            super(0, 0);

            var data: Object = Application.assetsManager.getObject("preloader");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            var scale: Number = Math.max(stage.stageWidth / _logo.width, stage.stageHeight / _logo.height);
            _logo.scaleX = scale;
            _logo.scaleY = scale;
            _logo.x = (stage.stageWidth - _logo.width) * 0.5;
            _logo.y = (stage.stageHeight - _logo.height) * 0.5;
            addChildAt(_logo, 0);

            _baseScale = _progress.mask.scaleX;

            StageUtil.fitAll(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }

        override protected function activate():void
        {
            _task.addEventListener(TaskEvent.PROGRESS, handleProgress);
            handleProgress(null);
        }

        override protected function deactivate():void
        {
            _task.removeEventListener(TaskEvent.PROGRESS, handleProgress);
        }

        private function handleProgress(event: TaskEvent):void
        {
            _progress.mask.scaleX = _baseScale * _task.progressValue;
        }
    }
}
