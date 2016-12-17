/**
 * Created by agnither on 16.12.16.
 */
package starling.extensions
{
    import starling.utils.AssetManager;

    import starlingbuilder.engine.IAssetMediator;

    public class AssetMediator extends AssetManager implements IAssetMediator
    {
        public function AssetMediator(scaleFactor:Number = 1, useMipmaps:Boolean = false)
        {
            super(scaleFactor, useMipmaps);
        }

        public function getExternalData(name:String):Object
        {
            return super.getObject(name);
        }

        public function getCustomData(type:String, name:String):Object
        {
            return null;
        }
    }
}
