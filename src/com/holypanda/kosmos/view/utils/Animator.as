/**
 * Created by agnither on 22.12.16.
 */
package com.holypanda.kosmos.view.utils
{
    import starling.animation.IAnimatable;
    import starling.core.Starling;

    public class Animator implements IAnimatable
    {
        public static function create(multiplier: Number, shift: Number, fn: Function):Animator
        {
            return new Animator(fn, multiplier, shift);
        }
        
        private var _fn: Function;
        
        private var _time: Number;
        private var _multiplier: Number;
        
        public function Animator(fn: Function, multiplier: Number = 1, shift: Number = 0)
        {
            _fn = fn;
            
            _multiplier = multiplier;
            _time = shift;

            Starling.juggler.add(this);
        }
        
        public function advanceTime(time: Number):void
        {
            _time += time;
            _fn(_time * _multiplier);
        }
    }
}
