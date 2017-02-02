/**
 * Created by agnither on 30.01.17.
 */
package com.holypanda.kosmos.tasks.server
{
    import com.agnither.tasks.abstract.SimpleTask;
    import com.agnither.tasks.global.TaskSystem;

    import com.holypanda.kosmos.enums.AuthMethod;
    import com.holypanda.kosmos.utils.logger.Logger;

    import com.playfab.ClientModels.LinkCustomIDRequest;
    import com.playfab.PlayFabClientAPI;
    import com.playfab.PlayFabError;

    public class LinkPlayFabTask extends SimpleTask
    {
        private var _userId: String;
        private var _auth: AuthMethod;

        public function LinkPlayFabTask(userId: String, auth: AuthMethod)
        {
            _userId = userId;
            _auth = auth;

            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);
            
            var customIdRequest: LinkCustomIDRequest = new LinkCustomIDRequest();
            customIdRequest.CustomId = _userId;
            PlayFabClientAPI.LinkCustomID(customIdRequest, onComplete, onError);
        }

        private function onComplete(result: *):void
        {
            complete();
        }

        private function onError(err: PlayFabError):void
        {
            // TODO: check errors:
            // InvalidParams	1000
            // LinkedIdentifierAlreadyClaimed	1184

            if (err.errorCode == 1184)
            {
                TaskSystem.getInstance().addTask(new LoginPlayFabTask(_userId, _auth), complete);
            } else {
                Logger.log(this, err.errorMessage);
                complete();
            }
        }
    }
}
