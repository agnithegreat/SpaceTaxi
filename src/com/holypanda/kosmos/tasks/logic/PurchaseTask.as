/**
 * Created by agnither on 02.02.17.
 */
package com.holypanda.kosmos.tasks.logic
{
    import com.agnither.tasks.abstract.SimpleTask;

    import com.holypanda.kosmos.Application;
    import com.holypanda.kosmos.controller.ServicesController;
    import com.holypanda.kosmos.managers.windows.LoaderManager;

    import starling.events.Event;

    public class PurchaseTask extends SimpleTask
    {
        private var _id: String;
        private var _callback: Function;
        
        public function PurchaseTask(id: String, callback: Function)
        {
            _id = id;
            _callback = callback;
            
            super();
        }

        override public function execute(token: Object):void
        {
            super.execute(token);

            Application.appController.services.services.purchase(_id);
            Application.appController.services.addEventListener(ServicesController.PURCHASE_SUCCESS, handlePurchaseSuccess);
            Application.appController.services.addEventListener(ServicesController.PURCHASE_FAIL, handlePurchaseFail);
            LoaderManager.startLoading(toString());
        }

        private function handlePurchaseSuccess(event: Event):void
        {
            LoaderManager.stopLoading(toString());
            
            Application.appController.services.removeEventListener(ServicesController.PURCHASE_SUCCESS, handlePurchaseSuccess);
            Application.appController.services.removeEventListener(ServicesController.PURCHASE_FAIL, handlePurchaseFail);

            _callback(true);

            complete();
        }

        private function handlePurchaseFail(event: Event):void
        {
            LoaderManager.stopLoading(toString());
            
            Application.appController.services.removeEventListener(ServicesController.PURCHASE_SUCCESS, handlePurchaseSuccess);
            Application.appController.services.removeEventListener(ServicesController.PURCHASE_FAIL, handlePurchaseFail);

            _callback(false);

            complete();
        }
    }
}
