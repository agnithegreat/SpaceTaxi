/**
 * Created by agnither on 22.12.16.
 */
package com.agnither.spacetaxi.view.gui.screens
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.view.gui.items.LevelView;
    import com.agnither.spacetaxi.vo.EpisodeVO;
    import com.agnither.spacetaxi.vo.LevelVO;
    import com.agnither.utils.gui.components.Screen;

    import feathers.controls.LayoutGroup;
    import feathers.controls.PageIndicator;
    import feathers.controls.PageIndicatorInteractionMode;
    import feathers.controls.ScrollContainer;

    import starling.display.Button;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class LevelScreen extends Screen
    {
        public var _root: LayoutGroup;

        public var _back: Image;

        public var _backBtn: ContainerButton;
        public var _backTF: TextField;

        public var _starsTF: TextField;

        public var _episodeNameTF: TextField;

        public var _levels: ScrollContainer;

        public var _leftButton: Button;
        public var _rightButton: Button;

        public var _pageIndicator: PageIndicator;

        private var _page: int;

        public function LevelScreen()
        {
            super(0, 0);

            var data: Object = Application.assetsManager.getObject("level_screen");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _rightButton.scaleX *= -1;

            StageUtil.fitAll(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);

            _pageIndicator.gap = 10;
            _pageIndicator.scaleX = 1.5;
            _pageIndicator.scaleY = 1.5;
            _pageIndicator.interactionMode = PageIndicatorInteractionMode.PRECISE;
            _pageIndicator.normalSymbolFactory = function():DisplayObject
            {
                return new Image(Application.assetsManager.getTexture("level_screen/bar_empty"));
            };
            _pageIndicator.selectedSymbolFactory = function():DisplayObject
            {
                return new Image(Application.assetsManager.getTexture("level_screen/bar_active"));
            };

            _back.width = stage.stageWidth;
            _back.height = stage.stageHeight;

            _levels.snapScrollPositionsToPixels = true;
            _levels.snapToPages = true;
            _levels.clipContent = false;

            _page = 0;
        }

        override protected function activate():void
        {
            var episode: EpisodeVO = Application.appController.levelsController.currentEpisode;
            _episodeNameTF.text = episode.name;
            _starsTF.text = "" + episode.stars + "/" + episode.starsTotal;

            var levels: Vector.<LevelVO> = Application.appController.levelsController.levels;
            for (var i:int = 0; i < levels.length; i++)
            {
                _levels.addChild(new LevelView(levels[i]));
            }

            _pageIndicator.validate();
            _levels.validate();
            _pageIndicator.pageCount = _levels.horizontalPageCount;

            // TODO: show page with last unlocked level
            showPage(_page, false);

            _backBtn.addEventListener(Event.TRIGGERED, handleBack);
            _leftButton.addEventListener(Event.TRIGGERED, handleLeft);
            _rightButton.addEventListener(Event.TRIGGERED, handleRight);

            _pageIndicator.addEventListener(Event.CHANGE, handleChangePage);
            _levels.addEventListener(Event.SCROLL, handleScrollLevels);
        }

        override protected function deactivate():void
        {
            _backBtn.removeEventListener(Event.TRIGGERED, handleBack);
            _leftButton.removeEventListener(Event.TRIGGERED, handleLeft);
            _rightButton.removeEventListener(Event.TRIGGERED, handleRight);

            _pageIndicator.removeEventListener(Event.CHANGE, handleChangePage);
            _levels.removeEventListener(Event.SCROLL, handleScrollLevels);

            _levels.removeChildren(0, -1, true);
        }

        private function showPage(index: int, animate: Boolean = true):void
        {
            _page = index;

            _levels.scrollToPageIndex(index, 0);
            _leftButton.visible = index > 0;
            _rightButton.visible = index < _levels.horizontalPageCount-1;

            var amount: int = Math.ceil(_levels.numChildren / _levels.horizontalPageCount);
            for (var i:int = 0; i < _levels.numChildren; i++)
            {
                var level: LevelView = _levels.getChildAt(i) as LevelView;
                level.setActive(int(i / amount) == _levels.horizontalPageIndex, animate);
            }
        }

        private function handleBack(event: Event):void
        {
            _page = 0;

            SoundManager.playSound(SoundManager.CLICK);
            Application.appController.states.goBack();
        }

        private function handleLeft(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);

            _pageIndicator.selectedIndex--;
        }

        private function handleRight(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);

            _pageIndicator.selectedIndex++;
        }

        private function handleChangePage( event:Event ):void
        {
            showPage(_pageIndicator.selectedIndex);
        }

        private function handleScrollLevels( event:Event ):void
        {
            _pageIndicator.selectedIndex = _levels.horizontalPageIndex;
        }
    }
}
