/**
 * Created by agnither on 16.11.16.
 */
package com.holypanda.kosmos.controller.game
{
    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.vo.TutorialVO;

    import starling.events.EventDispatcher;

    public class TutorialController extends EventDispatcher
    {
        public static const TUTORIAL: String = "TutorialController.TUTORIAL";
        
        private var _tutorial: Vector.<TutorialVO>;

        public function TutorialController()
        {
        }
        
        public function init(level: int):void
        {
            _tutorial = new <TutorialVO>[];
            
            var data: Array = Application.assetsManager.getObject("tutorial")[level];
            if (data == null) return;
            for (var i:int = 0; i < data.length; i++)
            {
                var tutorial: Object = data[i];
                var x: int = tutorial.x;
                var y: int = tutorial.y;
                var approx: int = tutorial.approx;
                var trigger: String = tutorial.trigger;
                _tutorial.push(new TutorialVO(x, y, approx, trigger));
            }
        }

        public function triggerEvent(type: String = null):void
        {
            if (_tutorial.length > 0)
            {
                var tutorial: TutorialVO = _tutorial[0];
                if (tutorial.trigger == type || tutorial.trigger == "")
                {
                    dispatchEventWith(TUTORIAL, false, _tutorial.shift());
                }
            }
        }
    }
}