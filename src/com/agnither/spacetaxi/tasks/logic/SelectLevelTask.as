/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.logic
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.view.gui.popups.LevelStartPopup;
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
