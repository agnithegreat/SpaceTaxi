/**
 * Created by agnither on 17.12.16.
 */
package com.agnither.spacetaxi.vo
{
    import flash.geom.Rectangle;

    public class LevelVO
    {
        public var ship: ShipVO;
        public var planets: Vector.<PlanetVO>;
        public var orders: Vector.<OrderVO>;
        public var viewport: Rectangle;
    }
}
