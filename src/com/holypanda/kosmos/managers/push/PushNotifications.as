/**
 * Created by agnither on 26.10.16.
 */
package com.holypanda.kosmos.managers.push
{
    import com.holypanda.kosmos.utils.logger.Logger;

    import com.marpies.ane.onesignal.OneSignal;
    import com.marpies.ane.onesignal.OneSignalNotification;

    public class PushNotifications
    {
        public function PushNotifications()
        {
            OneSignal.addNotificationReceivedCallback(onNotificationReceived);
            OneSignal.idsAvailable(onOneSignalIdsAvailable);

            OneSignal.settings
                    .setAutoRegister(true)
                    .setEnableInAppAlerts(true)
                    .setShowLogs(true);

            if (OneSignal.init("f82bc1b1-0a7f-4d36-839d-23ae2bb78211"))
            {
                // successfully initialized
            }
        }

        private function onNotificationReceived(notification: OneSignalNotification):void
        {
            // callback can be removed using OneSignal.removeNotificationReceivedCallback( onNotificationReceived );
            // process the notification
            Logger.log("onNotificationReceived", notification);
        }

        private function onOneSignalIdsAvailable(oneSignalUserId: String, pushToken: String):void
        {
            // 'pushToken' may be null if there's a server or connection error
            // callback is automatically removed when 'pushToken' is delivered
            Logger.log("onOneSignalIdsAvailable", oneSignalUserId, pushToken);
        }
    }
}
