/**
 * Created by agnither on 14.09.15.
 */
package com.agnither.spacetaxi
{
    import com.agnither.spacetaxi.controller.AppController;
    import com.agnither.spacetaxi.managers.windows.WindowManager;
    import com.agnither.spacetaxi.tasks.init.InitTask;
    import com.agnither.spacetaxi.utils.LevelParser;
    import com.agnither.spacetaxi.view.Fonts;
    import com.agnither.tasks.global.TaskSystem;

    import feathers.layout.AnchorLayout;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.TiledRowsLayout;
    import feathers.layout.VerticalLayout;

    import flash.geom.Rectangle;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.extensions.AssetMediator;
    import starling.extensions.TextureMaskStyle;
    import starling.styles.DistanceFieldStyle;

    import starlingbuilder.engine.UIBuilder;

    public class Application extends Sprite implements IStartable
    {
        public static var guiSize: Rectangle = new Rectangle(0, 0, 2048, 1536);
        public static var viewport: Rectangle = new Rectangle(0, 0, 2048, 1536);
        public static var graphicPack: int = 2048;
        public static var scaleFactor: Number = 1;

        public static var appController: AppController;

        public static var assetsManager: AssetMediator;

        public static var uiBuilder: UIBuilder;

        public function start():void
        {
            Starling.current.antiAliasing = 16;

            viewport.width = stage.stageWidth;
            viewport.height = stage.stageHeight;

            graphicPack = Math.round(viewport.width / 1024) * 1024;
            scaleFactor = 2.5 * viewport.width / guiSize.width;
//            Application.scaleFactor = graphicPack / guiSize.width;

            assetsManager = new AssetMediator(graphicPack / guiSize.width, true);
            assetsManager.verbose = Config.debug;

            const linkers:Array = [AnchorLayout, HorizontalLayout, VerticalLayout, TiledRowsLayout, TextureMaskStyle, DistanceFieldStyle];
            uiBuilder = new UIBuilder(assetsManager);
            
            appController = new AppController();

            LevelParser.init();

            WindowManager.init(this, viewport);

            TaskSystem.getInstance().addTask(new InitTask());
        }
    }
}
