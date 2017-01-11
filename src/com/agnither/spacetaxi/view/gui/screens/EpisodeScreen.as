/**
 * Created by agnither on 22.12.16.
 */
package com.agnither.spacetaxi.view.gui.screens
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.view.gui.items.EpisodeView;
    import com.agnither.spacetaxi.vo.EpisodeVO;
    import com.agnither.utils.gui.components.Screen;

    import feathers.controls.LayoutGroup;
    import feathers.controls.ScrollContainer;

    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class EpisodeScreen extends Screen
    {
        public var _root: LayoutGroup;

        public var _back: Image;

        public var _backBtn: ContainerButton;
        public var _backTF: TextField;

        public var _starsTF: TextField;

        public var _episodes: ScrollContainer;

        public var _leftButton: Button;
        public var _rightButton: Button;
        
        private var _page: int;

        public function EpisodeScreen()
        {
            super(0, 0);

            var data: Object = Application.assetsManager.getObject("episode_screen");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _leftButton.scaleX *= -1;

            StageUtil.fitAll(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);

            _back.width = stage.stageWidth;
            _back.height = stage.stageHeight;

            _episodes.snapScrollPositionsToPixels = true;
            _episodes.snapToPages = true;
            _episodes.clipContent = false;

            _page = 0;
        }
        
        override protected function activate():void
        {
            var sum: int = 0;
            var total: int = 0;

            var episodes: Vector.<EpisodeVO> = Application.appController.levelsController.episodes;
            for (var i:int = 0; i < episodes.length; i++)
            {
                sum += episodes[i].stars;
                total += episodes[i].starsTotal;
                _episodes.addChild(new EpisodeView(episodes[i]));
            }
            _episodes.validate();

            _starsTF.text = "" + sum + "/" + total;

            showPage(_page, false);
            
            _backBtn.addEventListener(Event.TRIGGERED, handleBack);
            _leftButton.addEventListener(Event.TRIGGERED, handleLeft);
            _rightButton.addEventListener(Event.TRIGGERED, handleRight);

            _episodes.addEventListener(Event.SCROLL, handleScrollEpisodes);
        }
        
        override protected function deactivate():void
        {
            _backBtn.removeEventListener(Event.TRIGGERED, handleBack);
            _leftButton.removeEventListener(Event.TRIGGERED, handleLeft);
            _rightButton.removeEventListener(Event.TRIGGERED, handleRight);

            _episodes.removeEventListener(Event.SCROLL, handleScrollEpisodes);

            _episodes.removeChildren(0, -1, true);
        }

        private function showPage(index: int, animate: Boolean = true):void
        {
            _page = index;
            
            _episodes.scrollToPageIndex(index, 0);
            _leftButton.visible = index > 0;
            _rightButton.visible = index < _episodes.horizontalPageCount-1;

            var amount: int = Math.ceil(_episodes.numChildren / _episodes.horizontalPageCount);
            for (var i:int = 0; i < _episodes.numChildren; i++)
            {
                var episode: EpisodeView = _episodes.getChildAt(i) as EpisodeView;
                episode.setActive(int(i / amount) == _episodes.horizontalPageIndex, animate);
            }
        }

        private function handleBack(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            Application.appController.states.goBack();
        }

        private function handleLeft(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);

            showPage(_episodes.horizontalPageIndex-1);
        }

        private function handleRight(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);

            showPage(_episodes.horizontalPageIndex+1);
        }

        private function handleScrollEpisodes( event:Event ):void
        {
            showPage(_episodes.horizontalPageIndex);
        }
    }
}
