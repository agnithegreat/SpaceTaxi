/**
 * Created by agnither on 23.04.14.
 */
package com.holypanda.kosmos.managers.iap
{
    import com.holypanda.kosmos.Config;
    import com.holypanda.kosmos.utils.logger.Logger;

    import com.myflashlab.air.extensions.billing.Billing;
    import com.myflashlab.air.extensions.billing.BillingType;
    import com.myflashlab.air.extensions.billing.Product;
    import com.myflashlab.air.extensions.billing.Purchase;

    import starling.core.Starling;
    import starling.events.EventDispatcher;

    public class IAP extends EventDispatcher
    {
        public static const SUCCESS: String = "success_IAP";
        public static const FAIL: String = "fail_IAP";
        public static const PRODUCTS_RECEIVED: String = "products_received_IAP";

        private static var gpKey: String = "MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiZXRy1yZGkQC" +
                                           "9UwbajwyLm7m81ZOSrPxiTOlj4COkYAnPkU6M/yQlmlhO0f4MlQb/ZhX" +
                                           "GI1hWzBeN7m55Ppy4YdP793DMKk23g3qJYMKQcSjYcmaHJOBVfJuRR9O" +
                                           "LEwgUCG3hj2scoXqKDSOlWKwjWANiYUNO9+gv/HE8klp+9oWz1Nj62FT" +
                                           "49NTvb+q40KhSZ7gtjibXVetziif7MqeEj39Z04Kwn2QmqTvws1RuLn4" +
                                           "6PW7ZzsDmgNYRrTZRUYdgwIVqw8rVOVeZ44OfPpKggeuK+5Wia7+q4Wb" +
                                           "N5oz9E1DYQgNpnPZpiL5ph1E1PS/17v6zniCSCXskKL7XT2cKQIDAQAB";

        private var _prices: Object;
        public function getProduct(id: String):Object
        {
            return _prices != null ? _prices[id] : null;
        }
        
        public function get isEnabled():Boolean
        {
            return _prices != null;
        }

        public function IAP() {
            Billing.IS_DEBUG_MODE = Config.debug;
        }

        public function init(ids: Array):void {
            Billing.init(gpKey, ids, ids, handleInit);
        }

        public function purchase(id: String):void {
            Billing.doPayment(BillingType.PERMANENT, id, "Payload", handleSuccess);
        }

        public function complete(receipt: String):void {
            Billing.forceConsume(receipt, Logger.log);
        }

        private function handleInit(status: int, message: String):void {
            _prices = {};
            for (var i:int = 0; i < Billing.products.length; i++)
            {
                var product: Product = Billing.products[i];
                _prices[product.productId] = product;
            }
            dispatchEventWith(PRODUCTS_RECEIVED);

            Billing.getPurchases(handleRestore);
        }

        private function handleRestore(purchases: Array):void {
            var l: int = purchases.length;
            for (var i:int = 0; i < l; i++) {
                Starling.juggler.delayCall(dispatchSuccess, i, purchases[i]);
            }
        }

        private function dispatchSuccess(data: Purchase):void {
            dispatchEventWith(SUCCESS, false, data);
        }

        private function dispatchFail(data: Purchase):void {
            dispatchEventWith(FAIL, false, data);
        }

        private function handleSuccess(status:int, data:Purchase, msg:String):void {
            Logger.log("status:", status);
            Logger.log("message:", msg);
            if (Boolean(status))
            {
                dispatchSuccess(data);
            } else {
                dispatchFail(data);
            }
        }
    }
}
