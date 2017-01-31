/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.init
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.managers.social.MobileFacebookSocial;
    import com.holypanda.kosmos.managers.social.MobileVkontakteSocial;

    import com.agnither.tasks.abstract.SimpleTask;

    public class InitSocialTask extends SimpleTask
    {
        public function InitSocialTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            BUILD::mobile
            {
                Application.appController.social.addSocial(AuthMethod.FB, new MobileFacebookSocial());
                Application.appController.social.addSocial(AuthMethod.VK, new MobileVkontakteSocial());
//                Application.appController.social.addSocial(AuthMethod.GP, new MobileGameServicesSocial());
            }

            complete();
        }
    }
}
