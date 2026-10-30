using { anubhav.db.master, anubhav.db.transaction } from '../db/datamodel';


service CatalogService @(path: 'CatalogService') {
    entity  EmployeeSet as projection on master.employees;
    entity BusinessPartnerSet as projection on master.businesspartner;
    entity AddressSet as projection on master.address;
    entity PurchaseOrderItems as projection on transaction.poitems;
    entity POs @(odata.draft.enabled: true) as projection on transaction.purchaseorder{
        case OVERALL_STATUS
            when 'N' then 'New'
            when 'P' then 'Pending'
            when 'A' then 'Approved'
            when 'X' then 'Rejected' end as OVERALL_STATUS: String(20),
            case OVERALL_STATUS
            when 'N' then 0
            when 'P' then 2
            when 'X' then 1
            else 3 end as Criticality: Integer,

            *,
            Items
    }
    actions {
            @cds.odata.bindingparameter.name: '_anubhav'
            @Common.SideEffects : {
                TargetProperties: ['_anubhav/GROSS_AMOUNT']
            }
            action boost();
            @cds.odata.bindingparameter.name: '_anubhav'
             @Common.SideEffects: {
                TargetProperties: ['_anubhav/OVERALL_STATUS', '_anubhav/Criticality']
            }
            action approve() returns POs;
        };
    function getPOs() returns array of POs;
    function largestOrder() returns array of POs;
    function getPOsByStatus() returns array of POs;
    
    entity ProductSet as projection on master.product;
}