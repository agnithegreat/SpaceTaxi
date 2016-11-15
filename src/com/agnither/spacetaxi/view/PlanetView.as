/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view
{
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.SpaceBody;

    import starling.display.Canvas;
    import starling.display.Sprite;
    import starling.events.Event;

    public class PlanetView extends Sprite
    {
        private var _planet: Planet;
        
        private var _canvas: Canvas;
        
        public function PlanetView(planet: Planet)
        {
            super();
            
            _planet = planet;
            _planet.addEventListener(SpaceBody.UPDATE, handleUpdate);
            handleUpdate(null);
            
            _canvas = new Canvas();
            _canvas.beginFill(Math.random() * 0xFFFFFF);
            _canvas.drawCircle(0, 0, _planet.radius);
            addChild(_canvas);
        }

        private function handleUpdate(event: Event):void
        {
            x = _planet.x;
            y = _planet.y;
        }
    }
}
