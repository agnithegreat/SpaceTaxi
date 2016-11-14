/**
 * Created by agnither on 14.09.15.
 */
package
{
    import com.dieselpuppet.lotto.Application;
    import com.dieselpuppet.lotto.Config;
    import com.mesmotronic.ane.AndroidFullScreen;

    import flash.display.StageQuality;
    import flash.display3D.Context3DTextureFormat;
    import flash.text.TextField;

    import starling.text.TextField;

    [SWF (frameRate=60, width=640, height=960, backgroundColor="#000000")]
    public class Main extends StarlingMainBase
    {
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

            stage.quality = StageQuality.BEST;
            TextField.defaultTextureFormat = Context3DTextureFormat.BGRA;
        }

        override protected function initializeStarling():void
        {
            super.initializeStarling();

            showStats = Config.debug;
        }
    }
}
