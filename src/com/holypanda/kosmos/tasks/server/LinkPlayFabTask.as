/**
 * Created by agnither on 30.01.17.
 */
package com.holypanda.kosmos.tasks.server
{
    import com.agnither.tasks.abstract.SimpleTask;

    import com.holypanda.kosmos.enums.AuthMethod;

    import com.playfab.ClientModels.LinkFacebookAccountRequest;
    import com.playfab.ClientModels.LinkFacebookAccountResult;
    import com.playfab.PlayFabClientAPI;
    import com.playfab.PlayFabError;

    public class LinkPlayFabTask extends SimpleTask
    {
        private var _token: String;
        private var _auth: AuthMethod;

        public function LinkPlayFabTask(token: String, auth: AuthMethod)
        {
            _token = token;
            _auth = auth;

            super();
        }
        
        override public function execute(token: Object):void
        {
            super.execute(token);

//            switch (_auth)
//            {
//                case AuthMethod.FB:
//                {
                    var facebookRequest: LinkFacebookAccountRequest = new LinkFacebookAccountRequest();
                    facebookRequest.AccessToken = _token;
                    PlayFabClientAPI.LinkFacebookAccount(facebookRequest, onComplete, onError);
//                    break;
//                }
//            }
        }

        private function onComplete(result: LinkFacebookAccountResult):void
        {
            complete();
        }

        private function onError(err: PlayFabError):void
        {
            // TODO: check errors:
            // InvalidParams	1000
            // InvalidFacebookToken	1013
            // LinkedAccountAlreadyClaimed	1012
            // AccountAlreadyLinked	1011
            error(err.errorMessage);
        }
    }
}
