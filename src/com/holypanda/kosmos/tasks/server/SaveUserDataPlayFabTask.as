/**
 * Created by agnither on 30.01.17.
 */
package com.holypanda.kosmos.tasks.server
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.holypanda.kosmos.tasks.server.vo.UserDataVO;

    import com.holypanda.kosmos.utils.logger.Logger;

    import com.playfab.ClientModels.UpdateUserDataRequest;
    import com.playfab.ClientModels.UpdateUserDataResult;
    import com.playfab.PlayFabClientAPI;
    import com.playfab.PlayFabError;

    public class SaveUserDataPlayFabTask extends SimpleTask
    {
        private var _userData: UserDataVO;

        public function SaveUserDataPlayFabTask(userData: UserDataVO)
        {
            _userData = userData;

            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);
            
            var updateRequest: UpdateUserDataRequest = new UpdateUserDataRequest();
            updateRequest.Data = _userData.exportData();
            updateRequest.Permission = "Public";
            PlayFabClientAPI.UpdateUserData(updateRequest, onComplete, onError);
        }

        private function onComplete(result: UpdateUserDataResult):void
        {
            complete();
        }

        private function onError(err: PlayFabError):void
        {
            Logger.log(this, err.errorMessage);
            complete();
        }
    }
}
