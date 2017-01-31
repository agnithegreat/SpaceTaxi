/**
 * Created by agnither on 28.04.16.
 */
package com.holypanda.kosmos.tasks.init
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.managers.Services;
    import com.holypanda.kosmos.tasks.load.LoadAdditionalTask;
    import com.holypanda.kosmos.tasks.server.InitPlayFabTask;
    import com.holypanda.kosmos.tasks.server.LoginPlayFabTask;
    import com.holypanda.kosmos.utils.LocalStorage;

    import com.agnither.tasks.abstract.MultiTask;

    import dragonBones.starling.StarlingFactory;

    import flash.system.Capabilities;

    import starlingbuilder.engine.localization.DefaultLocalization;

    public class InitApplicationTask extends MultiTask
    {
        public function InitApplicationTask():void
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            addTask(new LoadAdditionalTask());
            addTask(new InitSocialTask());
            addTask(new InitPlayFabTask());
            addTask(new LoginPlayFabTask());

            super.execute(token);
        }

        override protected function processComplete():void
        {
            StarlingFactory.factory.parseDragonBonesData(
                Application.assetsManager.getObject("ship_skeleton")
            );
            StarlingFactory.factory.parseTextureAtlasData(
                Application.assetsManager.getObject("ship_texture"),
                Application.assetsManager.getTexture("ship_texture")
            );
            
            var locale: String = Config.localization_map[Capabilities.language];
            Config.locale = locale != null ? Capabilities.language : "en";
            locale = Config.localization_map[Config.locale];
            Application.uiBuilder.localization = new DefaultLocalization(Application.assetsManager.getObject("strings"), locale);
            
            Application.appController.init();
            Application.appController.states.mainState();

            super.processComplete();
        }
    }
}
