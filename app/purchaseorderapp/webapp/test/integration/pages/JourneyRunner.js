sap.ui.define([
    "sap/fe/test/JourneyRunner",
	"com/ibm/purchaseorderapp/test/integration/pages/POsList.gen",
	"com/ibm/purchaseorderapp/test/integration/pages/POsObjectPage.gen",
	"com/ibm/purchaseorderapp/test/integration/pages/PurchaseOrderItemsObjectPage.gen"
], function (JourneyRunner, POsListGenerated, POsObjectPageGenerated, PurchaseOrderItemsObjectPageGenerated) {
    'use strict';

    const runner = new JourneyRunner({
        launchUrl: sap.ui.require.toUrl('com/ibm/purchaseorderapp') + '/test/flpSandbox.html#comibmpurchaseorderapp-tile',
        pages: {
			onThePOsListGenerated: POsListGenerated,
			onThePOsObjectPageGenerated: POsObjectPageGenerated,
			onThePurchaseOrderItemsObjectPageGenerated: PurchaseOrderItemsObjectPageGenerated
        },
        async: true
    });

    return runner;
});

