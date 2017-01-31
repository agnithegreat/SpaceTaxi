/**
 * Created by agnither on 24.01.17.
 */
package com.holypanda.kosmos.managers.analytics
{
    public class MovementVO
    {
        public var angle: Number;
        public var power: Number;
        public var time: Number;
        public var launch: Boolean;

        public static function clone(prev: MovementVO):MovementVO
        {
            var movement: MovementVO = new MovementVO();
            movement.angle = prev.angle;
            movement.power = prev.power;
            return movement;
        }
    }
}
