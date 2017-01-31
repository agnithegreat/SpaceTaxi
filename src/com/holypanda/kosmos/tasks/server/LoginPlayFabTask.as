/**
 * Created by agnither on 30.01.17.
 */
package com.holypanda.kosmos.tasks.server
{
    import com.agnither.tasks.abstract.SimpleTask;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.managers.Services;
    import com.holypanda.kosmos.utils.LocalStorage;

    import com.playfab.ClientModels.LoginResult;
    import com.playfab.ClientModels.LoginWithCustomIDRequest;
    import com.playfab.ClientModels.LoginWithFacebookRequest;
    import com.playfab.ClientModels.LoginWithPlayFabRequest;
    import com.playfab.PlayFabClientAPI;
    import com.playfab.PlayFabError;
    import com.playfab.PlayFabSettings;

    public class LoginPlayFabTask extends SimpleTask
    {
        public function LoginPlayFabTask()
        {
            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

            var userId: String = LocalStorage.auth.read("userId") as String;
            if (userId == null)
            {
                userId = Services.deviceId;
                LocalStorage.auth.write("userId", userId)
            }
            Config.userId = userId;

            var customIdRequest: LoginWithCustomIDRequest = new LoginWithCustomIDRequest();
            customIdRequest.TitleId = PlayFabSettings.TitleId;
            customIdRequest.CustomId = userId;
            customIdRequest.CreateAccount = true;
            PlayFabClientAPI.LoginWithCustomID(customIdRequest, onComplete, onError);
        }

        private function onComplete(result: LoginResult):void
        {
            complete();
        }

        private function onError(err: PlayFabError):void
        {
            error(err.errorMessage);
        }
    }
}
