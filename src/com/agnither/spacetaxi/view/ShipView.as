/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view
{
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.Ship;
    import com.agnither.spacetaxi.model.SpaceBody;

    import starling.display.Canvas;
    import starling.display.Sprite;
    import starling.events.Event;

    public class ShipView extends Sprite
    {
        private var _ship: Ship;
        
        private var _canvas: Canvas;
        
        public function ShipView(ship: Ship)
        {
            super();
            
            _ship = ship;
            _ship.addEventListener(SpaceBody.UPDATE, handleUpdate);
            handleUpdate(null);
            
            _canvas = new Canvas();
            _canvas.beginFill(0xFFFFFF);
            _canvas.drawCircle(0, 0, _ship.radius * 5);
            addChild(_canvas);
        }

        private function handleUpdate(event: Event):void
        {
            x = _ship.x;
            y = _ship.y;
        }
    }
}
