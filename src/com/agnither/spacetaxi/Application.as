/**
 * Created by agnither on 14.09.15.
 */
package com.agnither.spacetaxi
{
    import com.agnither.tasks.global.TaskSystem;
    import com.dieselpuppet.lotto.controllers.AppController;
    import com.dieselpuppet.lotto.managers.windows.WindowManager;
    import com.dieselpuppet.lotto.tasks.init.InitTask;
    import com.dieselpuppet.lotto.view.utils.Browser;
    import com.dieselpuppet.lotto.view.utils.ChatView;

    import feathers.layout.AnchorLayout;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.TiledRowsLayout;
    import feathers.layout.VerticalLayout;

    import flash.display.Sprite;

    import flash.geom.Rectangle;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.utils.AssetManager;

    import starlingbuilder.engine.DefaultAssetMediator;

    import starlingbuilder.engine.UIBuilder;

    public class Application extends Sprite implements IStartable
    {
        public static var guiSize: Rectangle = new Rectangle(0, 0, 1080, 1920);
        public static var viewport: Rectangle = new Rectangle(0, 0, 1080, 1920);
        public static var graphicPack: int = 1920;

        public static var scaleX: Number;
        public static var scaleY: Number;
        public static var scaleFactor: Number;

        public static var assetsManager: AssetManager;

        public static var uiBuilder: UIBuilder;

//        public static var preloadingManager: PreloadingManager;

        public static var appController: AppController;
        
        public static var browser: Browser;
        public static var chatView: ChatView;

        public function start():void
        {
            WindowManager.init(this);

            viewport.width = stage.stageWidth;
            viewport.height = stage.stageHeight;

//            var sd: int = BUILD::android ? 1280 : 1024;
//            var hd: int = BUILD::android ? 2560 : 2048;
//            Application.graphicPack = viewport.height <= 1024 ? sd : hd;
//            Application.graphicPack = viewport.width <= 1440 ? 1024 : 2048;
//            Application.scaleX = viewport.width / guiSize.width;
//            Application.scaleY = viewport.height / guiSize.height;
//            Application.scaleFactor = graphicPack / viewport.height;
            Application.scaleFactor = 1;

            assetsManager = new AssetManager(scaleFactor);
            assetsManager.verbose = Config.debug;

            const linkers:Array = [AnchorLayout, HorizontalLayout, VerticalLayout, TiledRowsLayout];
            uiBuilder = new UIBuilder(new DefaultAssetMediator(assetsManager));

//            preloadingManager = new PreloadingManager();

            browser = new Browser(Starling.current.nativeStage);

            chatView = new ChatView(Starling.current.nativeStage);

            appController = new AppController();
            appController.analytics.logActivatedApp();

            TaskSystem.getInstance().addTask(new InitTask());
        }
    }
}
