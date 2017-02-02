/**
 * Created by agnither on 30.01.17.
 */
package com.holypanda.kosmos.tasks.server
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.global.TaskSystem;

    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.tasks.logic.LoadProgressTask;
    import com.holypanda.kosmos.utils.LocalStorage;
    import com.holypanda.kosmos.utils.logger.Logger;

    import com.playfab.ClientModels.LoginResult;
    import com.playfab.ClientModels.LoginWithCustomIDRequest;
    import com.playfab.PlayFabClientAPI;
    import com.playfab.PlayFabError;
    import com.playfab.PlayFabSettings;

    public class LoginPlayFabTask extends SimpleTask
    {
        private var _userId: String;
        private var _auth: AuthMethod;
        
        public function LoginPlayFabTask(userId: String, auth: AuthMethod)
        {
            _userId = userId;
            _auth = auth;
            
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);
            
            var customIdRequest: LoginWithCustomIDRequest = new LoginWithCustomIDRequest();
            customIdRequest.TitleId = PlayFabSettings.TitleId;
            customIdRequest.CustomId = _userId;
            customIdRequest.CreateAccount = true;
            PlayFabClientAPI.LoginWithCustomID(customIdRequest, onComplete, onError);
        }

        private function onComplete(result: LoginResult):void
        {
            LocalStorage.auth.write("userId", _userId);
            LocalStorage.auth.write("auth", _auth.tag);
            Config.userId = _userId;

            TaskSystem.getInstance().addTask(new LoadProgressTask(), complete);
        }

        private function onError(err: PlayFabError):void
        {
            Logger.log(this, err.errorMessage);
            complete();
        }
    }
}
