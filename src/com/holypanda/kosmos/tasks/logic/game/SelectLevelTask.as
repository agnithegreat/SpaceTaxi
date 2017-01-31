/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.logic.game
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.view.gui.popups.LevelStartPopup;
    import com.agnither.tasks.abstract.SimpleTask;

    public class SelectLevelTask extends SimpleTask
    {
        private var _level: int;
        
        public function SelectLevelTask(level: int = -1):void
        {
            _level = level;
            
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);
            
            if (_level == -1)
            {
                _level = Application.appController.player.progress.level;
            }

            Application.appController.selectLevel(_level);
            WindowManager.showPopup(new LevelStartPopup(), true);

            complete();
        }
    }
}
