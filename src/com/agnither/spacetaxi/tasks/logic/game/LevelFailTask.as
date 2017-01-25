/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.logic.game
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.view.gui.popups.LevelFailPopup;
    import com.agnither.tasks.abstract.SimpleTask;

    public class LevelFailTask extends SimpleTask
    {
        public function LevelFailTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);
            
            Application.appController.space.lose();

            complete();
        }
    }
}
