/**
 * Created by agnither on 26.01.17.
 */
package com.holypanda.kosmos.vo
{
    import flash.geom.Point;

    public class TutorialVO
    {
        public var point: Point;
        public var approx: int;
        public var trigger: String;

        public function TutorialVO(x: int, y: int, approx: int, trigger: String)
        {
            this.point = new Point(x, y);
            this.approx = approx;
            this.trigger = trigger;
        }
    }
}
