/**
 * Created by agnither on 14.09.15.
 */
package com.agnither.spacetaxi
{
    import com.agnither.spacetaxi.controller.AppController;
    import com.agnither.spacetaxi.tasks.init.InitTask;
    import com.agnither.tasks.global.TaskSystem;

    import flash.display.Sprite;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.utils.AssetManager;

    public class Application extends starling.display.Sprite implements IStartable
    {
        public static var graphicPack: int = 2048;

        public static var appController: AppController;

        public static var assetsManager: AssetManager;

        public static var viewport: starling.display.Sprite;
        
        public static var flashViewport: flash.display.Sprite;
        
        public function start():void
        {
            Starling.current.antiAliasing = 16;

            assetsManager = new AssetManager(1, true);
            assetsManager.verbose = Config.debug;
            
            appController = new AppController();

            flashViewport = new flash.display.Sprite();
            Starling.current.nativeOverlay.addChild(flashViewport);

            viewport = new starling.display.Sprite();
            addChild(viewport);
            
            TaskSystem.getInstance().addTask(new InitTask());
        }
    }
}
