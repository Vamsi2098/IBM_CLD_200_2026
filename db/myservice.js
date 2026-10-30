// const { module } = require("@sap/cds/lib/compile/resolve");

export default (srv) => {
    srv.on('vendors', (req, next) =>{
        var Vendors = [{
            'vendorID' : 1,
            'name' : 'SAP'
        },
        {
            'vendorID' : 2,
            'name' : 'IBM' 
        }]

        const vendor= Vendors.find(v=> v.vendorID === req.data.vendorID);
        return vendor.name;
    })
}