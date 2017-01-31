/**
 * Created by agnither on 23.01.17.
 */
package com.holypanda.kosmos.managers.analytics
{
    import com.holypanda.kosmos.model.Space;

    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;

    import starling.core.Starling;
    import starling.events.EnterFrameEvent;

    public class GamePlayAnalytics
    {
        private static var _startTime: Number;
        private static var _replay: ReplayVO;
        
        public static function get level():int
        {
            return _replay.level;
        }
        
        private static var _space: Space;
        private static var _last: int;
        private static var _replayMode: Boolean;
        
        public static function startLevel(id: int):void
        {
            if (_replayMode) return;

            _startTime = (new Date()).time;
            _replay = new ReplayVO();
            _replay.level = id;
            _replay.movements = [];
        }
        
        public static function setMovement(angle: Number, power: Number):void
        {
            if (_replayMode) return;
            
            var movement: MovementVO = new MovementVO();
            movement.angle = angle;
            movement.power = power;
            movement.time = (new Date()).time - _startTime;
            _replay.movements.push(movement);
        }
        
        public static function launch():void
        {
            if (_replayMode) return;
            
            var movement: MovementVO = MovementVO.clone(_replay.movements[_replay.movements.length - 1]);
            movement.time = (new Date()).time - _startTime;
            movement.launch = true;
            _replay.movements.push(movement);
        }
        
        public static function exportData():ByteArray
        {
            registerClassAlias("ReplayVO", ReplayVO);
            registerClassAlias("MovementVO", MovementVO);

            var byteArray: ByteArray = new ByteArray();
            byteArray.writeObject(_replay);
            return byteArray;
        }
        
        public static function importData(data: ByteArray):void
        {
            registerClassAlias("ReplayVO", ReplayVO);
            registerClassAlias("MovementVO", MovementVO);

            data.position = 0;
            _replay = data.readObject();
            _replayMode = true;
        }

        public static function replay(space: Space):void
        {
            if (_replay == null) return;

            _startTime = (new Date()).time - _replay.movements[0].time;

            _last = -1;
            _space = space;
            
            Starling.current.stage.addEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
            Starling.current.stage.touchable = false;
        }
        
        private static function handleEnterFrame(event: EnterFrameEvent):void
        {
            var time: Number = (new Date()).time - _startTime;
            var current: MovementVO;
            for (var i:int = _last+1; i < _replay.movements.length; i++)
            {
                var movement: MovementVO = _replay.movements[i];
                if (movement.time <= time)
                {
                    current = movement;
                    _last = i;
                }
            }

            if (current != null)
            {
                _space.setPullPoint(current.angle, current.power, true, true);
                if (current.launch)
                {
                    _space.launch();
                }
            } else if (_last == _replay.movements.length-1) {
                Starling.current.stage.removeEventListener(EnterFrameEvent.ENTER_FRAME, handleEnterFrame);
                Starling.current.stage.touchable = true;
            }
        }
    }
}