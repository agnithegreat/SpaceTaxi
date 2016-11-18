/**
 * Created by agnither on 17.11.16.
 */
package com.agnither.spacetaxi.enums
{
    public class PlanetType
    {
        public static const NORMAL: PlanetType = new PlanetType(1);
        public static const ANTI_GRAVITY: PlanetType = new PlanetType(2);
        public static const LAVA: PlanetType = new PlanetType(3, true, false);
        public static const BLACK_HOLE: PlanetType = new PlanetType(4, false, false);

        private var _type: int;
        public function get type():int
        {
            return _type;
        }

        private var _solid: Boolean;
        public function get solid():Boolean
        {
            return _solid;
        }
        
        private var _safe: Boolean;
        public function get safe():Boolean
        {
            return _safe;
        }

        public function PlanetType(type: int, solid: Boolean = true, safe: Boolean = true)
        {
            _type = type;
            _solid = solid;
            _safe = safe;
        }
    }
}
