/**
 * Created by agnither on 17.11.16.
 */
package com.agnither.spacetaxi.enums
{
    public class PlanetType
    {
        public static const NORMAL: PlanetType = new PlanetType("normal");
        public static const ANTI_GRAVITY: PlanetType = new PlanetType("anti_gravity");
        public static const LAVA: PlanetType = new PlanetType("lava", true, false);
        public static const BLACK_HOLE: PlanetType = new PlanetType("black_hole", false, false);
        
        private static var types: Vector.<PlanetType> = new <PlanetType>[NORMAL, ANTI_GRAVITY, LAVA, BLACK_HOLE];
        
        public static function getType(type: String):PlanetType
        {
            for (var i:int = 0; i < types.length; i++)
            {
                if (types[i].type == type)
                {
                    return types[i];
                }
            }
            return null;
        }

        private var _type: String;
        public function get type():String
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

        public function PlanetType(type: String, solid: Boolean = true, safe: Boolean = true)
        {
            _type = type;
            _solid = solid;
            _safe = safe;
        }
    }
}
