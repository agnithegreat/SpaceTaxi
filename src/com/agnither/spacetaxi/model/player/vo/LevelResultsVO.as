/**
 * Created by agnither on 13.01.17.
 */
package com.agnither.spacetaxi.model.player.vo
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.IExternalizable;

    public class LevelResultsVO implements IExternalizable
    {
        public var levels: Object = {};

        public function writeExternal(output: IDataOutput):void
        {
            levels = {};
        }

        public function readExternal(input: IDataInput):void
        {
        }
    }
}
