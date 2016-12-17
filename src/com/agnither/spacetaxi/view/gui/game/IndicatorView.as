/**
 * Created by agnither on 16.12.16.
 */
package com.agnither.spacetaxi.view.gui.game
{
    import com.agnither.utils.gui.components.AbstractComponent;

    import starling.core.Starling;
    import starling.display.Image;

    public class IndicatorView extends AbstractComponent
    {
        public static const FUEL: String = "fuel";
        public static const DURABILITY: String = "durability";
        public static const CAPACITY: String = "capacity";
        
        public var _back: Image;
        public var _bar: Image;
        public var _icon: Image;

        private var _baseScale: Number = 0;
        
        private var _type: String;
        private var _value: int;
        private var _max: int;
        private var _amount: int;
        private var _reverse: Boolean;

        public function IndicatorView()
        {
            super();
        }

        public function init(type: String, max: int, amount: int = 0, reverse: Boolean = false):void
        {
            _type = type;

            _max = max;
            _amount = amount || max;
            _reverse = reverse;

            if (_baseScale == 0)
            {
                _baseScale = _back.mask.scaleX;
            }

            _back.mask.scaleX = _baseScale * (_max + 1) / (_amount + 1);
        }

        public function update(value: int):void
        {
            if (_value != value)
            {
                _value = value;

                var part: Number = _value / _max;
                if (_reverse)
                {
                    part = 1 - part;
                }

                var scale: Number = _baseScale * (part * _max + 1) / (_amount + 1);
                Starling.juggler.tween(_bar.mask, 0.3, {scaleX: scale});
            }
        }
    }
}
