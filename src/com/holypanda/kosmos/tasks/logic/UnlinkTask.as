/**
 * Created by agnither on 02.02.17.
 */
package com.holypanda.kosmos.tasks.logic
{
    import com.agnither.tasks.abstract.MultiTask;

    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.tasks.social.LogoutTask;

    public class UnlinkTask extends MultiTask
    {
        public function UnlinkTask()
        {
            super();
        }

        override public function execute(token: Object):void
        {
            addTask(new LogoutTask());
            addTask(new EnterTask(AuthMethod.GUEST));

            super.execute(token);
        }
    }
}
