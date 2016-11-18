/**
 * Created by agnither on 01.07.16.
 */
package com.agnither.spacetaxi.utils
{
    public class ObjectUtil
    {
        public static function getObjectNode(object: Object, path: String):Object
        {
            if (object == null || path == null) return object;
            if (path.length > 0)
            {
                var nodes: Array = path.split(".");
                if (nodes.length > 0)
                {
                    var node: String = nodes.shift();
                    return getObjectNode(object[node], nodes.join("."));
                }
            }
            return object;
        }
    }
}
