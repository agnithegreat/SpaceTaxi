/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.logic.game
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.view.gui.popups.LevelFailPopup;
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
