/**
 * Created by agnither on 22.12.16.
 */
package com.holypanda.kosmos.view.gui.screens
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.utils.StringUtils;
    import com.holypanda.kosmos.view.gui.items.LevelView;
    import com.holypanda.kosmos.vo.EpisodeVO;
    import com.holypanda.kosmos.vo.LevelVO;
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

        public var _episodeTF: TextField;
        public var _episodeNameTF: TextField;

        public var _levels: ScrollContainer;

        public var _leftButton: Button;
        public var _rightButton: Button;

        public var _pageIndicator: PageIndicator;

        private var _page: int;
        private var _episode: int;

        public function LevelScreen()
        {
            super(0, 0);

            var data: Object = Application.assetsManager.getObject("level_screen");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            addChildAt(_back, 0);
            _back.height = stage.stageHeight;

            _rightButton.scaleX *= -1;

            _backTF.text = Application.uiBuilder.localization.getLocalizedText("Back");

            StageUtil.fitAll(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);

            _pageIndicator.gap = 10;
            _pageIndicator.scaleX = 1.5;
            _pageIndicator.scaleY = 1.5;
            _pageIndicator.interactionMode = PageIndicatorInteractionMode.PRECISE;
            _pageIndicator.normalSymbolFactory = function():DisplayObject
            {
                return new Image(Application.assetsManager.getTexture("common/bar_empty"));
            };
            _pageIndicator.selectedSymbolFactory = function():DisplayObject
            {
                return new Image(Application.assetsManager.getTexture("common/bar_active"));
            };

            _levels.snapScrollPositionsToPixels = true;
            _levels.snapToPages = true;
            _levels.clipContent = false;

            _page = -1;
            _episode = -1;
        }

        override protected function activate():void
        {
            var episode: EpisodeVO = Application.appController.levelsController.currentEpisode;
            _episodeTF.text = StringUtils.format(Application.uiBuilder.localization.getLocalizedText("Episode"), episode.id);
            _episodeNameTF.text = Application.uiBuilder.localization.getLocalizedText("Episode" + episode.id);
            _starsTF.text = "" + episode.stars + "/" + episode.starsTotal;

            var levels: Vector.<LevelVO> = Application.appController.levelsController.currentEpisode.levels;
            var current: int;
            for (var i:int = 0; i < levels.length; i++)
            {
                var level: LevelVO = levels[i];
                if (level.id <= Application.appController.player.level)
                {
                    current = i / 3;
                }
                _levels.addChild(new LevelView(level));
            }

            _pageIndicator.validate();
            _levels.validate();
            _pageIndicator.pageCount = _levels.horizontalPageCount;
            _back.width = stage.stageWidth * (_levels.horizontalPageCount + 1);
            
            if (_episode != episode.id)
            {
                _episode = episode.id;
                _page = -1;
            }
            if (_page == -1)
            {
                _page = current;
            }
            
            showPage(_page, false);

            _backBtn.addEventListener(Event.TRIGGERED, handleBack);
            _leftButton.addEventListener(Event.TRIGGERED, handleLeft);
            _rightButton.addEventListener(Event.TRIGGERED, handleRight);

            _pageIndicator.addEventListener(Event.CHANGE, handleChangePage);
            _levels.addEventListener(Event.SCROLL, handleScrollLevels);
            handleScrollLevels(null);
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
            if (animate && _page == index) return;
            
            _page = index;

            _levels.scrollToPageIndex(index, 0, animate ? NaN : 0);
            _leftButton.visible = index > 0;
            _rightButton.visible = index < _levels.horizontalPageCount-1;

            var amount: int = Math.ceil(_levels.numChildren / _levels.horizontalPageCount);
            for (var i:int = 0; i < _levels.numChildren; i++)
            {
                var level: LevelView = _levels.getChildAt(i) as LevelView;
                level.setActive(int(i / amount) == _levels.horizontalPageIndex, animate);
            }

            if (animate)
            {
                SoundManager.playSound(SoundManager.SWISH);
            }
        }

        private function handleBack(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            Application.appController.states.goBack();
        }

        private function handleLeft(event: Event):void
        {
            _pageIndicator.selectedIndex--;
        }

        private function handleRight(event: Event):void
        {
            _pageIndicator.selectedIndex++;
        }

        private function handleChangePage(event: Event):void
        {
            showPage(_pageIndicator.selectedIndex);
        }

        private function handleScrollLevels(event: Event):void
        {
            _back.pivotX = stage.stageWidth / _back.scaleX * ((_levels.horizontalScrollPosition / _levels.maxHorizontalScrollPosition) + 0.5);
            _pageIndicator.selectedIndex = _levels.horizontalPageIndex;
        }
    }
}
