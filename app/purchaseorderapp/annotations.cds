using CatalogService as service from '../../db/CatalogService';

annotate service.POs with @(

    UI.SelectionFields: [
        PO_ID,
        PARTNER_GUID.COMPANY_NAME,
        PARTNER_GUID.ADDRESS_GUID.COUNTRY,
        GROSS_AMOUNT,
        OVERALL_STATUS
    ],

    UI.HeaderInfo:{
        TypeName : 'PO',
        TypeNamePlural: 'POs',
        Title : {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        Description: {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID.COMPANY_NAME,
        },
        ImageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmnMckxXlZ_QfVB0-EiCaAjVOPJdjhOlLOxzGGBl-rfg&s=10'
    },

    UI.LineItem: [
        {
            $Type: 'UI.DataField',
            Value: PO_ID
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.COMPANY_NAME
        },
        {
            $Type: 'UI.DataField',
            Value: PARTNER_GUID.ADDRESS_GUID.COUNTRY
        },
        {
            $Type: 'UI.DataField',
            Value: GROSS_AMOUNT
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'boost',
            Inline : true,
            Action : 'CatalogService.boost',
        },
        {
            $Type : 'UI.DataFieldForAction',
            Label : 'Approve',
            Inline : true,
            Action : 'CatalogService.approve',
        },
        {
            $Type: 'UI.DataField',
            Value: OVERALL_STATUS,
            Criticality: Criticality,
        }
    ],

    UI.Identification: [
        {
            $Type : 'UI.DataField',
            Value : NODE_KEY,
        },
        {
            $Type : 'UI.DataField',
            Value : PO_ID,
        },
        {
            $Type : 'UI.DataField',
            Value : PARTNER_GUID_NODE_KEY,
        },
    ],

    UI.FieldGroup #PricingData: {
        Label : 'Pricing Data',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },{
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },{
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },
        ],
    },

    UI.FieldGroup #ProductData:{
        Label: 'Product Details',
        Data: [
            {
                $Type : 'UI.DataField',
                Value : CURRENCY_code,
            },{
                $Type : 'UI.DataField',
                Value : OVERALL_STATUS
            },{
                $Type : 'UI.DataField',
                Value : LIFECYCLE_STATUS
            },
        ]
    },

    UI.Facets: [
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Item Details',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Item Data',
                    Target : '@UI.Identification',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Pricing Data',
                    Target : '@UI.FieldGroup#PricingData',
                },
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Status',
                    Target : '@UI.FieldGroup#ProductData',
                },

                {
            $Type : 'UI.ReferenceFacet',
            Label : 'PO Line Items',
            Target : 'Items/@UI.LineItem',
        },
            ],
        }
    ],

    
);

annotate CatalogService.PurchaseOrderItems with @(
    UI.LineItem:[
        {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        },{
            $Type : 'UI.DataField',
            Value : PRODUCT_GUID_NODE_KEY,
        },{
            $Type : 'UI.DataField',
            Value : GROSS_AMOUNT,
        },{
            $Type : 'UI.DataField',
            Value : NET_AMOUNT,
        },{
            $Type : 'UI.DataField',
            Value : TAX_AMOUNT,
        },{
            $Type : 'UI.DataField',
            Value : CURRENCY_code,
        }

    ],

    UI.HeaderInfo:{
        TypeName : 'Item',
        TypeNamePlural : 'Items',
        Title : {
            $Type : 'UI.DataField',
            Value : PO_ITEM_POS,
        }
    },
    UI.Facets:[
        {
            $Type : 'UI.CollectionFacet',
            Label : 'Item Details',
            Facets : [
                {
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Item Data',
                    Target : '@UI.FieldGroup#ItemData',
                },{
                    $Type : 'UI.ReferenceFacet',
                    Label : 'Product Data',
                    Target : '@UI.FieldGroup#ProductData',
                }
            ],
        },
    ],
    UI.FieldGroup #ItemData:{
        Label : 'Item Data',
        Data : [
            {
                $Type : 'UI.DataField',
                Value : PO_ITEM_POS,
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID_NODE_KEY,
            },{
                $Type : 'UI.DataField',
                Value : GROSS_AMOUNT,
            },{
                $Type : 'UI.DataField',
                Value : NET_AMOUNT,
            },{
                $Type : 'UI.DataField',
                Value : TAX_AMOUNT,
            },{
                $Type : 'UI.DataField',
                Value : CURRENCY_code,
            },
        ],
    },
    UI.FieldGroup #ProductData:{
        Label: 'Product Details',
        Data: [
            {
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.CATEGORY,
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.DESCRIPTION,
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.PRICE,
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.SUPPLIER_GUID.ADDRESS_GUID.COUNTRY,
            },{
                $Type : 'UI.DataField',
                Value : PRODUCT_GUID.SUPPLIER_GUID.COMPANY_NAME,
            }
        ]
    }

);


annotate CatalogService.POs with {
    PARTNER_GUID @(
        Common : { 
            Text : PARTNER_GUID.COMPANY_NAME,
         },
         ValueList.entity: CatalogService.BusinessPartnerSet
    )
};

annotate CatalogService.PurchaseOrderItems with {
    PRODUCT_GUID @(
        Common : { 
            Text : PRODUCT_GUID.DESCRIPTION,
         },
         ValueList.entity: CatalogService.ProductSet
    )
};


@cds.odata.valuelist
annotate CatalogService.BusinessPartnerSet with @(
    UI.Identification:[{
        $Type : 'UI.DataField',
        Value : COMPANY_NAME,
    }]
);

@cds.odata.valuelist
annotate CatalogService.ProductSet with @(
    UI.Identification:[{
        $Type : 'UI.DataField',
        Value : DESCRIPTION
    }]
);