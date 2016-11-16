/**
 * Created by agnither on 14.09.15.
 */
package com.agnither.spacetaxi
{
    import com.agnither.spacetaxi.controller.AppController;
    import com.agnither.spacetaxi.view.SpaceView;

    import flash.display.Sprite;

    import starling.core.Starling;
    import starling.display.Sprite;

    public class Application extends starling.display.Sprite implements IStartable
    {
        public static var appController: AppController;
        public static var viewport: starling.display.Sprite;
        
        public static var flashViewport: flash.display.Sprite;
        
        public function start():void
        {
            appController = new AppController();
            appController.init();
            
            var scale: Number = Math.max(Starling.current.stage.stageWidth / 800, Starling.current.stage.stageHeight / 600);

            flashViewport = new flash.display.Sprite();
            flashViewport.scaleX = scale;
            flashViewport.scaleY = scale;
            Starling.current.nativeOverlay.addChild(flashViewport);

            viewport = new starling.display.Sprite();
            viewport.addChild(new SpaceView(appController.space));
            viewport.scaleX = scale;
            viewport.scaleY = scale;
            addChild(viewport);
        }
    }
}
