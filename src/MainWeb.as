/**
 * Created by agnither on 14.09.15.
 */
package
{
    import com.holypanda.kosmos.Application;

    [SWF (frameRate=60, width=768, height=576, backgroundColor="#00000000")]
    public class MainWeb extends Main
    {
        [Embed (source="logo_web.png")]
        private var Splash: Class;

        public function MainWeb()
        {
            super();
        }

        override protected function initialize():void
        {
            super.initialize();

            Application.splash = new Splash();
            addChild(Application.splash);
        }

        override protected function initializeStarling():void
        {
            super.initializeStarling();

//            showStats = Config.debug;
        }
    }
}

