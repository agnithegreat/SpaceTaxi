/**
 * Created by agnither on 16.12.16.
 */
package com.holypanda.kosmos.view.gui.game
{
    import com.agnither.utils.gui.components.AbstractComponent;

    import feathers.controls.LayoutGroup;

    import starling.animation.IAnimatable;

    import starling.core.Starling;
    import starling.display.Image;

    public class IndicatorView extends AbstractComponent implements IAnimatable
    {
        public static const FUEL: String = "fuel";
        public static const DURABILITY: String = "durability";

        public var _root: LayoutGroup;

        public var _back: Image;
        public var _bar: Image;
        public var _icon: Image;

        private var _baseScale: Number = 0;

        private var _type: String;
        private var _value: int;
        private var _max: int;
        private var _amount: int;

        private var _time: Number = 0;

        public function IndicatorView()
        {
            super();
        }

        public function init(type: String, max: int, amount: int = 0):void
        {
            _type = type;

            _max = max;
            _amount = amount || max;

            if (_baseScale == 0)
            {
                _baseScale = _back.mask.scaleX;
            }

//            _back.mask.scaleX = _baseScale * (_max + 1) / (_amount + 1);
//            _root.width = _back.x + _back.mask.width;
        }

        public function update(value: int, animate: Boolean = true):void
        {
            if (_value != value)
            {
                _value = value;

                var scale: Number = _baseScale * (_value + 1) / (_amount + 1);
                Starling.juggler.tween(_bar.mask, animate ? 0.3 : 0, {scaleX: scale});

                if (_value < 2 && _value != _max)
                {
                    _time = 0;
                    Starling.juggler.add(this);
                } else {
                    Starling.juggler.remove(this);
                    _icon.alpha = 1;
                }
            }
        }

        public function advanceTime(time: Number):void
        {
            _time += time * 10;
            _icon.alpha = (1 + Math.cos(_time)) * 0.5;
        }
    }
}
