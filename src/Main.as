/**
 * Created by agnither on 14.09.15.
 */
package
{
    import com.holypanda.kosmos.Application;

    import flash.display.StageQuality;
    import flash.display3D.Context3DTextureFormat;

    import starling.text.TextField;

    public class Main extends StarlingMainBase
    {
        public function Main()
        {
            super(Application);
        }

        override protected function initialize():void
        {
            super.initialize();

            stage.quality = StageQuality.BEST;
            TextField.defaultTextureFormat = Context3DTextureFormat.BGRA;
        }
    }
}

