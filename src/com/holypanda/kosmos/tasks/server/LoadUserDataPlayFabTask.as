/**
 * Created by agnither on 30.01.17.
 */
package com.holypanda.kosmos.tasks.server
{
    import com.agnither.tasks.abstract.SimpleTask;

    import com.holypanda.kosmos.tasks.server.vo.UserDataVO;
    import com.holypanda.kosmos.utils.logger.Logger;

    import com.playfab.ClientModels.GetUserDataRequest;
    import com.playfab.ClientModels.GetUserDataResult;
    import com.playfab.PlayFabClientAPI;
    import com.playfab.PlayFabError;

    public class LoadUserDataPlayFabTask extends SimpleTask
    {
        private var _userId: String;
        private var _keys: Vector.<String>;

        public function LoadUserDataPlayFabTask(userId: String = null, keys: Vector.<String> = null)
        {
            _userId = userId;
            _keys = keys;

            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);
            
            var getRequest: GetUserDataRequest = new GetUserDataRequest();
            getRequest.PlayFabId = _userId;
            getRequest.Keys = _keys;
            PlayFabClientAPI.GetUserData(getRequest, onComplete, onError);
        }

        private function onComplete(result: GetUserDataResult):void
        {
            var data: UserDataVO = new UserDataVO();
            data.importData(result.Data);
            _result = data;
            
            complete();
        }

        private function onError(err: PlayFabError):void
        {
            _result = new UserDataVO();
            Logger.log(this, err.errorMessage);
            complete();
        }
    }
}
