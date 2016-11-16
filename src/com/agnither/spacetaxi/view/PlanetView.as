/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view
{
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.SpaceBody;
    import com.agnither.spacetaxi.model.orders.Zone;

    import flash.geom.Point;

    import starling.display.Canvas;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.geom.Polygon;

    public class PlanetView extends Sprite
    {
        private var _planet: Planet;
        
        private var _glow: Canvas;
        private var _canvas: Canvas;

        public function PlanetView(planet: Planet)
        {
            super();
            
            _planet = planet;
            _planet.addEventListener(SpaceBody.UPDATE, handleUpdate);
            _planet.addEventListener(Planet.ORDER, handleOrder);
            handleUpdate(null);

            _glow = new Canvas();
            addChild(_glow);
            
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

        private function handleOrder(event: Event):void
        {
            var zone: Zone = event.data as Zone;
            
            _glow.clear();
            
            if (zone.order == null) return;

            const thickness: int = 10;

            var vertices: Array = [];
            vertices.push(0, 0);
            for (var i:int = 0; i < 20; i++)
            {
                var angle: Number = zone.angle - zone.size/2 + zone.size * i / 20;
                vertices.push(Math.cos(angle) * (_planet.radius + thickness), Math.sin(angle) * (_planet.radius + thickness));
            }

            _glow.beginFill(0x00FF00, 0.5);
            _glow.drawPolygon(new Polygon(vertices));
        }
    }
}
