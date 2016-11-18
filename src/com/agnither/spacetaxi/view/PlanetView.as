/**
 * Created by agnither on 14.11.16.
 */
package com.agnither.spacetaxi.view
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.model.Planet;
    import com.agnither.spacetaxi.model.SpaceBody;
    import com.agnither.spacetaxi.model.orders.Zone;

    import starling.display.Canvas;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.geom.Polygon;

    public class PlanetView extends Sprite
    {
        private static var PLANETS: Array = ["1", "2", "3", "5", "6", "7", "8", "9", "10", "12"];

        private var _planet: Planet;
        
        private var _glow: Canvas;

        private var _image: Image;
        private var _baseScale: Number;

        public function PlanetView(planet: Planet)
        {
            super();
            
            _planet = planet;
            _planet.addEventListener(SpaceBody.UPDATE, handleUpdate);
            _planet.addEventListener(Planet.ORDER, handleOrder);
            handleUpdate(null);

            _glow = new Canvas();
            addChild(_glow);

            _baseScale = (_planet.radius) / 428 * 2;

            var rand: int = Math.random() * PLANETS.length;
            _image = new Image(Application.assetsManager.getTexture(PLANETS[rand]));
//            _image = new Image(Application.assetsManager.getTexture("Planets/"+(rand+1)));
            _image.pivotX = _image.width / 2;
            _image.pivotY = _image.height / 2;
            _image.scaleX = _baseScale;
            _image.scaleY = _baseScale;
            addChild(_image);
        }

        private function handleUpdate(event: Event):void
        {
            x = _planet.x;
            y = _planet.y;
            
            scaleX = (1 + Math.cos(_planet.time) * _planet.scale);
            scaleY = (1 + Math.sin(_planet.time) * _planet.scale);
        }

        private function handleOrder(event: Event):void
        {
            var zone: Zone = event.data as Zone;
            
            _glow.clear();
            
            if (zone.order == null) return;

            const thickness: int = 20;

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
