/**
 * Created by agnither on 14.09.15.
 */
package com.holypanda.kosmos
{
    import com.holypanda.kosmos.controller.AppController;
    import com.holypanda.kosmos.managers.sound.SoundManager;
    import com.holypanda.kosmos.managers.windows.WindowManager;
    import com.holypanda.kosmos.tasks.init.InitTask;
    import com.holypanda.kosmos.utils.LevelParser;

    import com.agnither.tasks.global.TaskSystem;
    import com.holypanda.kosmos.utils.logger.Logger;

    import feathers.layout.AnchorLayout;
    import feathers.layout.HorizontalLayout;
    import feathers.layout.TiledRowsLayout;
    import feathers.layout.VerticalLayout;

    import flash.display.Bitmap;
    import flash.geom.Rectangle;
    import flash.ui.Keyboard;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.KeyboardEvent;
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
        
        public static var splash: Bitmap;

        public static var appController: AppController;

        public static var assetsManager: AssetMediator;

        public static var uiBuilder: UIBuilder;

        public function start():void
        {
            Starling.current.antiAliasing = 16;

            viewport.width = stage.stageWidth;
            viewport.height = stage.stageHeight;

            scaleFactor = 2 * viewport.width / guiSize.width;
            graphicPack = 768;
            BUILD::standalone
            {
                graphicPack = Math.round(scaleFactor) * 1024;
            }

            assetsManager = new AssetMediator(graphicPack / guiSize.width);
            assetsManager.verbose = Config.debug;

            const linkers:Array = [AnchorLayout, HorizontalLayout, VerticalLayout, TiledRowsLayout, TextureMaskStyle, DistanceFieldStyle];
            uiBuilder = new UIBuilder(assetsManager);
            
            appController = new AppController();

            Logger.init();
            SoundManager.init();

            LevelParser.init();

            WindowManager.init(this, viewport);

            TaskSystem.getInstance().addTask(new InitTask());

            stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
        }

        private function handleKeyDown(event: KeyboardEvent):void
        {
            switch (event.keyCode)
            {
                case Keyboard.ENTER:
                {
                    Config.ai = !Config.ai;
                    break;
                }
            }
        }
    }
}
