/**
 * Created by agnither on 14.09.15.
 */
package com.agnither.spacetaxi
{
    import com.agnither.spacetaxi.controller.AppController;
    import com.agnither.spacetaxi.view.SpaceView;

    import starling.display.Sprite;

    public class Application extends Sprite implements IStartable
    {
        public static var appController: AppController;
        public static var viewport: Sprite;
        
        public function start():void
        {
            appController = new AppController();
            appController.init();

            viewport = new Sprite();
            viewport.addChild(new SpaceView(appController.space));
//            viewport.x = stage.stageWidth/2;
//            viewport.y = stage.stageHeight/2;
//            viewport.scaleX = 0.5;
//            viewport.scaleY = 0.5;
            addChild(viewport);
        }
    }
}
