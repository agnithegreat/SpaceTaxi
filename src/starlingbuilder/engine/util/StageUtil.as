/**
 *  Starling Builder
 *  Copyright 2015 SGN Inc. All Rights Reserved.
 *
 *  This program is free software. You can redistribute and/or modify it in
 *  accordance with the terms of the accompanying license agreement.
 */
package starlingbuilder.engine.util
{
    import feathers.controls.LayoutGroup;
    import feathers.controls.LayoutGroup;
    import feathers.core.FeathersControl;
    import feathers.layout.AnchorLayoutData;

    import flash.display.Stage;
    import flash.geom.Point;
    import flash.system.Capabilities;

    import starling.core.Starling;

    import starling.display.DisplayObject;
    import starling.utils.RectangleUtil;
    import starling.utils.ScaleMode;

    /**
     * Helper class to support multiple resolution
     *
     * <p>Example usage:</p>
     *
     * <listing version="3.0">
     *     var stageUtil:StageUtil = new StageUtil(stage);
     *     var size:Point = stageUtil.getScaledStageSize();
     *     var starling:Starling = new Starling(Game, stage, new Rectangle(0, 0, stageUtil.stageWidth, stageUtil.stageHeight));
     *     starling.stage.stageWidth = size.x;
     *     starling.stage.stageHeight = size.y;</listing>
     *
     * @see http://wiki.starling-framework.org/builder/multiple_resolution Multiple resolution support
     * @see http://github.com/mindjolt/starling-builder-engine/tree/master/demo Starling Builder demo project
     */
    public class StageUtil
    {
        private var _stage:Stage;
        private var _designStageWidth:int;
        private var _designStageHeight:int;

        /**
         * Constructor
         * @param stage flash stage
         * @param designStageWidth design stage width of the project
         * @param designStageHeight design stage height of the project
         */
        public function StageUtil(stage:Stage, designStageWidth:int = 640, designStageHeight:int = 960)
        {
            _stage = stage;

            _designStageWidth = designStageWidth;
            _designStageHeight = designStageHeight;
        }

        /**
         * Return stage width of the device
         */
        public function get stageWidth():int
        {
            var iOS:Boolean = isiOS();
            var android:Boolean = isAndroid();

            if (iOS || android)
            {
                return _stage.fullScreenWidth;
            }
            else
            {
                return _stage.stageWidth;
            }
        }

        /**
         * Return stage height of the device
         */
        public function get stageHeight():int
        {
            var iOS:Boolean = isiOS();
            var android:Boolean = isAndroid();

            if (iOS || android)
            {
                return _stage.fullScreenHeight;
            }
            else
            {
                return _stage.stageHeight;
            }
        }

        /**
         * Calculate the scaled starling stage size
         *
         * @param stageWidth stageWidth of flash stage, if not specified then use this.stageWidth
         * @param stageHeight stageHeight of flash stage, if not specified then use this.stageHeight
         * @return the scaled starling stage
         */
        public function getScaledStageSize(stageWidth:int = 0, stageHeight:int = 0):Point
        {
            if (stageWidth == 0 || stageHeight == 0)
            {
                stageWidth = this.stageWidth;
                stageHeight = this.stageHeight;
            }

            var designWidth:int;
            var designHeight:int;

            var rotated:Boolean = ((stageWidth < stageHeight) != (_designStageWidth < _designStageHeight));

            if (rotated)
            {
                designWidth = _designStageHeight;
                designHeight = _designStageWidth;
            }
            else
            {
                designWidth = _designStageWidth;
                designHeight = _designStageHeight;
            }

            var maxRatio:Number = 1.0 * designWidth / designHeight;

            var width:Number;
            var height:Number;

            var scale:Number;

            if (1.0 * stageWidth / stageHeight <= maxRatio)
            {
                scale = _designStageWidth / stageWidth;
            }
            else
            {
                scale = _designStageHeight / stageHeight;
            }

            width = scale * stageWidth;
            height = scale * stageHeight;

            return new Point(Math.round(width), Math.round(height));
        }

        /**
         * @private
         */
        public static function isAndroid():Boolean
        {
            return Capabilities.manufacturer.indexOf("Android") != -1;
        }

        /**
         * @private
         */
        public static function isiOS():Boolean
        {
            return Capabilities.manufacturer.indexOf("iOS") != -1;
        }

        /**
         * Fit background to the center of the native stage, If the aspect ratio is different, some cropping may happen.
         * @param object background display object
         * @param stage native stage
         */
        public static function fitNativeBackground(object:flash.display.DisplayObject, stage:Stage):void
        {
            var objectRect:flash.geom.Rectangle = new flash.geom.Rectangle(0, 0, object.width, object.height);
            var stageRect:flash.geom.Rectangle = new flash.geom.Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            var rect:flash.geom.Rectangle = RectangleUtil.fit(objectRect, stageRect, ScaleMode.NO_BORDER);
            object.x = rect.x;
            object.y = rect.y;
            object.width = rect.width;
            object.height = rect.height;
        }

        /**
         * Fit background to the center of the Starling stage. If the aspect ratio is different, some cropping may happen.
         * @param object background display object
         */
        public static function fitBackground(object:DisplayObject):void
        {
            var stage:starling.display.Stage = Starling.current.stage;
            var objectRect:flash.geom.Rectangle = new flash.geom.Rectangle(0, 0, object.width, object.height);
            var stageRect:flash.geom.Rectangle = new flash.geom.Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
            var rect:flash.geom.Rectangle = RectangleUtil.fit(objectRect, stageRect, ScaleMode.NO_BORDER);
            object.x = rect.x;
            object.y = rect.y;
            object.width = rect.width;
            object.height = rect.height;
        }

        public static function fitAll(root: LayoutGroup, designWidth:int, designHeight:int, deviceWidth:int, deviceHeight:int):void
        {
            var scale:Number = Math.min(1.0 * deviceWidth / designWidth, 1.0 * deviceHeight / designHeight);

            root.width = deviceWidth;
            root.height = deviceHeight;

            for (var i:int = 0; i < root.numChildren; ++i)
            {
                var obj: DisplayObject = root.getChildAt(i);
                obj.scaleX = obj.scaleY = scale;

                var layout: FeathersControl = obj as FeathersControl;
                if (layout != null)
                {
                    var layoutData: AnchorLayoutData = layout.layoutData as AnchorLayoutData;
                    if (layoutData != null)
                    {
                        layoutData.top *= scale;
                        layoutData.bottom *= scale;
                        layoutData.left *= scale;
                        layoutData.right *= scale;
                        layoutData.horizontalCenter *= scale;
                        layoutData.verticalCenter *= scale;
                    }
                }
            }

            root.validate();
        }

        public static function fitPopup(root: LayoutGroup, designWidth:int, designHeight:int, deviceWidth:int, deviceHeight:int):void
        {
            var scale:Number = Math.min(1.0 * deviceWidth / designWidth, 1.0 * deviceHeight / designHeight);

            root.scaleX = scale;
            root.scaleY = scale;
            root.validate();
        }
    }
}
