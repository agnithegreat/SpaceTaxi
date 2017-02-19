/**
 * Created by agnither on 21.01.17.
 */
package com.holypanda.kosmos.view.gui.popups
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.utils.StringUtils;
    import com.holypanda.kosmos.vo.EpisodeVO;
    import com.agnither.utils.gui.components.Popup;

    import feathers.controls.LayoutGroup;

    import starling.core.Starling;
    import starling.display.MovieClip;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.text.TextField;

    import starlingbuilder.engine.util.StageUtil;
    import starlingbuilder.extensions.uicomponents.ContainerButton;

    public class EpisodeDonePopup extends Popup
    {
        public var _root: LayoutGroup;

        public var _textTF: TextField;

        public var _glowMC: MovieClip;
        
        public var _okButton: ContainerButton;

        public var _container: LayoutGroup;
        public var _rewardTF: TextField;

        public function EpisodeDonePopup()
        {
            super(0, 1);

            var data: Object = Application.assetsManager.getObject("episode_done_popup");
            addChild(Application.uiBuilder.create(data, true, this) as Sprite);
        }

        override protected function initialize():void
        {
            _glowMC.touchable = false;

            _root.pivotX = _root.width * 0.5;
            _root.pivotY = _root.height * 0.5;

            StageUtil.fitPopup(_root, Application.guiSize.width, Application.guiSize.height, Application.viewport.width, Application.viewport.height);
        }

        override protected function activate():void
        {
            var episode: EpisodeVO = Application.appController.levelsController.currentEpisode;
            
            _okButton.addEventListener(Event.TRIGGERED, handleTriggered);

            _rewardTF.text = StringUtils.formatNumberDelimeter(episode.reward, " ");
            _container.readjustLayout();
            _container.validate();

            Starling.juggler.add(_glowMC);
        }

        override public function setup():void
        {
            SoundManager.playSound(SoundManager.POPUP_WIN_EPISODE);
        }

        override protected function deactivate():void
        {
            _okButton.removeEventListener(Event.TRIGGERED, handleTriggered);

            Starling.juggler.remove(_glowMC);
        }

        override protected function cancelHandler():void
        {
            WindowManager.closePopup(this, true);
        }

        private function handleTriggered(event: Event):void
        {
            SoundManager.playSound(SoundManager.CLICK);
            WindowManager.closePopup(this, true);
        }
    }
}
