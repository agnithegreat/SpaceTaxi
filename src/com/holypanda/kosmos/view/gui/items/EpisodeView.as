/**
 * Created by agnither on 10.01.17.
 */
package com.holypanda.kosmos.view.gui.items
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.utils.StringUtils;
    import com.holypanda.kosmos.vo.EpisodeVO;
    import com.agnither.utils.gui.components.AbstractComponent;

    import feathers.controls.LayoutGroup;

    import starling.core.Starling;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class EpisodeView extends AbstractComponent
    {
        private var _episode: EpisodeVO;
        
        public var _back: Image;

        public var _episodeBtn: ContainerButton;
        public var _episodeImage: Image;

        public var _stars: LayoutGroup;
        public var _starsTF: TextField;

        public var _episodeTF: TextField;
        public var _episodeNameTF: TextField;

        public function EpisodeView(episode: EpisodeVO)
        {
            _episode = episode;
            
            super();

            var data: Object = Application.assetsManager.getObject("episode");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _episodeImage.texture = Application.assetsManager.getTexture("episode_screen/" + _episode.skin);

            _episodeTF.text = StringUtils.format(Application.uiBuilder.localization.getLocalizedText("Episode"), _episode.id);
            _episodeNameTF.text = Application.uiBuilder.localization.getLocalizedText("Episode" + _episode.id);
            _starsTF.text = "" + _episode.stars + "/" + _episode.starsTotal;

            _stars.visible = !_episode.locked;

            _episodeBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        }
        
        public function setActive(value: Boolean, animate: Boolean = true):void
        {
            Starling.juggler.tween(this, animate ? 0.3 : 0, {alpha: value ? 1 : 0.3});
            touchable = value;
        }

        private function handleTriggered(event: Event):void
        {
            if (_episode.locked)
            {
                SoundManager.playSound(SoundManager.UNAVAILABLE_PLANET);
            } else {
                SoundManager.playSound(SoundManager.CLICK);
                Application.appController.selectEpisode(_episode.id-1);
                Application.appController.states.levelState();
            }
        }

        override public function dispose():void
        {
            _episodeBtn.removeEventListener(Event.TRIGGERED, handleTriggered);
            _episode = null;

            super.dispose();
        }
    }
}
