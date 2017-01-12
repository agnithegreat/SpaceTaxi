/**
 * Created by agnither on 19.12.16.
 */
package com.agnither.spacetaxi.view.scenes.game
{
    import com.agnither.spacetaxi.Application;

    import flash.geom.Rectangle;

    import starling.display.Image;
    import starling.display.Sprite;
    import starling.textures.RenderTexture;

    public class ParallaxLayer extends Sprite
    {
        private static var stars: Array = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11",
                                           "white_01", "white_02", "white_03", "white_04", "white_05",
                                           "white_06", "white_07", "white_08", "white_09"];
        
        private var _speed: Number;
        private var _amount: int;
        private var _scale: Number;
        
        private var _stars: Sprite;
        
        override public function set x(value: Number):void
        {
            super.x = value * _speed;
        }
        override public function get x():Number
        {
            return super.x / _speed;
        }

        override public function set y(value: Number):void
        {
            super.y = value * _speed;
        }
        override public function get y():Number
        {
            return super.y / _speed;
        }

        public function ParallaxLayer(speed: Number, amount: int, scale: Number)
        {
            _speed = speed;
            _amount = amount;
            _scale = scale;
        }
        
        public function init():void
        {
            _stars = new Sprite();
            for (var i:int = 0; i < _amount; i++)
            {
                var rand: int = Math.random() * stars.length;
                var star: Image = new Image(Application.assetsManager.getTexture("stars/" + stars[rand]));
                star.scaleX = _scale;
                star.scaleY = _scale;
                star.x = Math.random() * (stage.stageWidth * 2 - star.width);
                star.y = Math.random() * (stage.stageHeight * 2 - star.height);
                _stars.addChild(star);
            }
            _stars.pivotX = _stars.width * 0.5;
            _stars.pivotY = _stars.height * 0.5;
            _stars.x = stage.stageWidth * 0.5;
            _stars.y = stage.stageHeight * 0.5;
            addChild(_stars);
        }
    }
}
