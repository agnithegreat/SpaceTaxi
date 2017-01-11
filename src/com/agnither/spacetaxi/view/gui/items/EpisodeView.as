/**
 * Created by agnither on 10.01.17.
 */
package com.agnither.spacetaxi.view.gui.items
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.sound.SoundManager;
    import com.agnither.spacetaxi.vo.EpisodeVO;
    import com.agnither.utils.gui.components.AbstractComponent;

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

            _episodeTF.text = _episode.id + " episode";
            _episodeNameTF.text = _episode.name;
            _starsTF.text = "" + _episode.stars + "/" + _episode.starsTotal;

            _episodeBtn.addEventListener(Event.TRIGGERED, handleTriggered);
        }
        
        public function setActive(value: Boolean, animate: Boolean = true):void
        {
            Starling.juggler.tween(this, animate ? 0.3 : 0, {alpha: value ? 1 : 0.3});
            touchable = value;
        }

        private function handleTriggered(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            Application.appController.selectEpisode(_episode.id-1);
            Application.appController.states.levelState();
        }
    }
}
