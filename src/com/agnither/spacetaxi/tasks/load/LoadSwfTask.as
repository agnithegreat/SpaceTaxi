/**
 * Created by agnither on 28.04.16.
 */
package com.agnither.spacetaxi.tasks.load
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.utils.gui.SWFLoader;

    import flash.events.Event;
    import flash.events.ProgressEvent;

    public class LoadSwfTask extends SimpleTask
    {
        private var _swfLoader: SWFLoader;
        private var _path: String;
        
        public function LoadSwfTask(path: String)
        {
            _path = path;
            
            super(data);
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);
            
            _swfLoader = new SWFLoader();
            _swfLoader.addEventListener(ProgressEvent.PROGRESS, handleSwfProgress);
            _swfLoader.addEventListener(Event.COMPLETE, handleSwfLoaded);
            _swfLoader.addFile(_path);
            _swfLoader.load();
        }

        private function handleSwfProgress(event:ProgressEvent):void
        {
            progress(_swfLoader.progress);
        }

        private function handleSwfLoaded(event:Event):void
        {
            complete();
        }
        
        override protected function dispose():void
        {
            if (_swfLoader != null)
            {
                _swfLoader.removeEventListener(ProgressEvent.PROGRESS, handleSwfProgress);
                _swfLoader.removeEventListener(Event.COMPLETE, handleSwfLoaded);
                _swfLoader.destroy();
                _swfLoader = null;
            }
            
            super.dispose();
        }
    }
}
