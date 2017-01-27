/**
 * Created by agnither on 14.09.15.
 */
package
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.Config;

    import flash.desktop.NativeApplication;

    import flash.events.InvokeEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;

    BUILD::android
    {
        import com.mesmotronic.ane.AndroidFullScreen;
    }

    import flash.display.StageQuality;
    import flash.display3D.Context3DTextureFormat;

    import starling.text.TextField;

    [SWF (frameRate=60, width=1000, height=768, backgroundColor="#000000")]
    public class Main extends StarlingMainBase
    {
        [Embed (source="logo.png")]
        private var Splash: Class;
        
        public function Main()
        {
            BUILD::android
            {
                AndroidFullScreen.stage = stage;
                AndroidFullScreen.immersiveMode() || AndroidFullScreen.leanMode();
            }
            super(Application);
        }

        override protected function initialize():void
        {
            super.initialize();

            Application.splash = new Splash();
            addChild(Application.splash);
            resize();

            stage.quality = StageQuality.BEST;
            TextField.defaultTextureFormat = Context3DTextureFormat.BGRA;

            BUILD::standalone
            {
                BUILD::debug
                {
                    NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, handleInitializationArgs);
    
                    function handleInitializationArgs(event: InvokeEvent):void
                    {
                        var args:Array = event.arguments as Array;
                        if (args.length > 0)
                        {
                            var file: File = new File(String(args[0]));
                            var fileStream: FileStream = new FileStream();
                            fileStream.open(file, FileMode.READ);
                            Config.replay = new ByteArray();
                            fileStream.readBytes(Config.replay);
                            fileStream.close();
                        }
                    }
                }
            }
        }

        override protected function initializeStarling():void
        {
            super.initializeStarling();

//            showStats = Config.debug;
        }

        override protected function resize():void
        {
            if (Application.splash == null) return;

            Application.splash.scaleX = 1;
            Application.splash.scaleY = 1;

            var scale: Number = Math.max(stage.stageWidth / Application.splash.width, stage.stageHeight / Application.splash.height);
            Application.splash.scaleX = scale;
            Application.splash.scaleY = scale;
            Application.splash.x = (stage.stageWidth - Application.splash.width) * 0.5;
            Application.splash.y = (stage.stageHeight - Application.splash.height) * 0.5;
        }
    }
}

