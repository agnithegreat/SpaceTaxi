/**
 * Created by agnither on 08.12.16.
 */
package com.agnither.spacetaxi.managers.windows
{
    import com.agnither.utils.gui.components.Screen;

    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.animation.Transitions;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;

    public class TweenManager
    {
        private static var _viewport: Rectangle;
        
        public static function init(viewport: Rectangle):void
        {
            _viewport = viewport;
        }

        public static function tween(screen1: Screen, screen2: Screen, container: Sprite, callback: Function):void
        {
            var screen1snapshot: Image = screen1.snapshot;
            place(screen1snapshot, new Point());
            container.addChild(screen1snapshot);
            screen1.visible = false;

            var screen2snapshot: Image = screen2.snapshot;
            place(screen2snapshot, screen2.tweenPosition);
            container.addChild(screen2snapshot);
            screen2.visible = false;

            Starling.juggler.tween(screen1snapshot, 0.5, {
                alpha: 0,
                scaleX: 0.6,
                scaleY: 0.6,
                transition: Transitions.EASE_IN_OUT
            });

            Starling.juggler.tween(screen2snapshot, 0.5, {
                x: screen1snapshot.x,
                y: screen1snapshot.y,
                transition: Transitions.EASE_IN_OUT
            });

            Starling.juggler.delayCall(callback, 0.5);
        }

        public static function tweenBack(screen1: Screen, screen2: Screen, container: Sprite, callback: Function):void
        {
            var screen1snapshot: Image = screen1.snapshot;
            place(screen1snapshot, new Point());
            container.addChild(screen1snapshot);
            screen1.visible = false;

            var screen2snapshot: Image = screen2.snapshot;
            place(screen2snapshot, new Point());
            container.addChild(screen2snapshot);
            screen2.visible = false;

            screen1snapshot.alpha = 0;
            screen1snapshot.scaleX = 0.6;
            screen1snapshot.scaleY = 0.6;
            Starling.juggler.tween(screen1snapshot, 0.5, {
                alpha: 1,
                scaleX: 1,
                scaleY: 1,
                transition: Transitions.EASE_IN_OUT
            });

            Starling.juggler.tween(screen2snapshot, 0.5, {
                x: _viewport.width * (screen2.tweenPosition.x + 0.5),
                y: _viewport.height * (screen2.tweenPosition.y + 0.75),
                transition: Transitions.EASE_IN_OUT
            });
            
            Starling.juggler.delayCall(callback, 0.5);
        }

        private static function place(image: Image, placement: Point):void
        {
            image.pivotX = _viewport.width * 0.5;
            image.pivotY = _viewport.height * 0.75;
            image.x = _viewport.width * (placement.x + 0.5);
            image.y = _viewport.height * (placement.y + 0.75);
        }
    }
}
