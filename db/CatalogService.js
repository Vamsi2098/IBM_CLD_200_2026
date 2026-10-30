// export default (srv) => {

// const { UPDATE } = require("@sap/cds/lib/ql/cqn");
const SELECT = require("@sap/cds/lib/ql/SELECT");

//     const {EmployeeSet} = srv.entities;

//     srv.before(['CREATE', 'UPDATE'], EmployeeSet, (req) => {
//         if(req.data.salaryAmount > 1000000) {
//             req.error(500, 'The salary exceeded the limit');
//         }
//     })
// }

module.exports = cds.service.impl( async function(){

    //Step 1: get the object of our odata entities
    const { EmployeeSet, POs, ProductSet } = this.entities;

    //Step 2: define generic handler for validation
    this.before(['CREATE', 'UPDATE'], EmployeeSet, (req,res) => {
        // console.log(req);
        console.log(req.data);
        console.log(req.params);
        console.log(req.event);
        console.log(req.user);
        // console.log(req.target);
        console.log("Aa gaya " + req.data.salaryAmount);
        if(parseFloat(req.data.salaryAmount) >= 1000000){
            req.error(500, "Salary must be less than a million for employee");
        }
    });

    this.on('boost', async (req,res) => {
        try {
            console.log(req);
            console.log(req.params[0].NODE_KEY);
            const ID = req.params[0];
            console.log("Hey Amigo, Your purchase order with id " + req.params[0] + " will be boosted");
            const tx = cds.tx(req);
            await tx.update(POs).with({
                GROSS_AMOUNT: { '+=' : 20000 },
                NOTE: 'Boosted!!'
            }).where(ID);
        } catch (error) {
            return "Error " + error.toString();
        }
    });

    this.on('getPOs', async (req,res) =>{

        const aPOs = await SELECT.one.from(POs).columns('count(*) as total');
await SELECT.from(POs)
    .columns('OVERALL_STATUS', 'sum(GROSS_AMOUNT) as total')
    .groupBy('OVERALL_STATUS');
    console.log(aPOs.total);
    })
    
    this.on('largestOrder', async (req,res) => {
        const aPO = await SELECT.one.from(POs).orderBy('GROSS_AMOUNT desc');
        console.log(aPO);
        return aPO
    });

    this.on('getPOsByStatus', async (req,res) => {
        const aPOsN = await SELECT.from(POs).where({OVERALL_STATUS: 'N'});
        return aPOsN.length;
    })

    this.on('approve', async (req) => {
        const PoID = req.params[0];
        const aPO = await SELECT.one.from(POs).where(PoID);
        if (!aPO) {
            return req.error(404, `Purchase order ${PoID.NODE_KEY} not found`);
        }
        if (aPO.OVERALL_STATUS === 'Approved') {
            return req.error(400, 'PO already approved');
        }
            await UPDATE(POs).set({ OVERALL_STATUS: 'A' }).where(PoID)
            return SELECT.one.from(POs).where(PoID);
        

    })

    this.before(['CREATE', 'UPDATE'], ProductSet,  async (req) => {
        if(req.data.PRICE <= 0){
            return req.error(400, 'Price should not be less than 0');
        }
    })
})