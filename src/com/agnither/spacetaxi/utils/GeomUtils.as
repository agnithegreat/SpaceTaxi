/**
 * Created by agnither on 15.11.16.
 */
package com.agnither.spacetaxi.utils
{
    import flash.geom.Point;
    import flash.geom.Point;

    public class GeomUtils
    {
        public static function rotate(vector: Point, angle: Number):Point
        {
            var tx: Number = vector.x * Math.cos(angle) - vector.y * Math.sin(angle);
            var ty: Number = vector.x * Math.sin(angle) + vector.y * Math.cos(angle);
            return new Point(tx, ty);
        }

        public static function getProjection(center: Point, point: Point, vector: Point):Point
        {
            var projection: Point = new Point();
            var angle: Number = Math.atan2(vector.y, vector.x);
            var local: Point = point.subtract(center);
            local = rotate(local, -angle);
            local.y = 0;
            local = rotate(local, angle);
            projection.x = center.x + local.x;
            projection.y = center.y + local.y;
            return projection;
        }

        public static function getVectorDelta(vector1: Point, vector2: Point):Number
        {
            var angle1: Number = Math.atan2(vector1.y, vector1.x);
            var angle2: Number = Math.atan2(vector2.y, vector2.x);
            return angle2 - angle1;
        }

        public static function getAngleDelta(angle1: Number, angle2: Number):Number
        {
            var angleDelta: Number = (angle2 - angle1) % (Math.PI * 2);
            if (angleDelta < 0)
            {
                angleDelta += Math.PI * 2;
            }
            if (angleDelta > Math.PI)
            {
                angleDelta = -(Math.PI * 2 - angleDelta);
            }
            return angleDelta
        }
    }
}
