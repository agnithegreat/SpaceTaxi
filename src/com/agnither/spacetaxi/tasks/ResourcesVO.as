/**
 * Created by agnither on 18.07.16.
 */
package com.agnither.spacetaxi.tasks
{
    import com.agnither.spacetaxi.Application;
    import com.agnither.spacetaxi.utils.ObjectUtil;

    public class ResourcesVO
    {
        public var cache: Boolean;
        public var folder: String;
        public var assets: Array;
        
        public static function getResourcesList(groups: Array):Array
        {
            var resources: Array = [];
            for (var i:int = 0; i < groups.length; i++)
            {
                var res: ResourcesVO = create(groups[i]);
                for (var j:int = 0; j < res.assets.length; j++)
                {
                    resources.push(res.assets[j]);
                }
            }
            return resources;
        }
        
        public static function create(group: String):ResourcesVO
        {
            var resources: Object = Application.assetsManager.getObject("resources");
            var node: Object = ObjectUtil.getObjectNode(resources, group);
            
            var res: ResourcesVO = new ResourcesVO();
            res.cache = node["cache"];
            res.folder = node["folder"];
            res.assets = getReplacedPaths(node["assets"], Application.graphicPack);
            return res;
        }
        
        private static function getReplacedPaths(list: Array, replace: int):Array
        {
            var replaced: Array = [];
            if (list != null)
            {
                for (var i:int = 0; i < list.length; i++)
                {
                    var path: String = list[i].replace("*", replace);
                    replaced.push(path);
                }
            }
            return replaced;
        }
    }
}
