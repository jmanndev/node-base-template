var dbAPI = require('../dp_apis/db_calls.js');

async function run(req, res, next) {
    var columnsString = ''
    if (typeof (req.body.columns) == 'string') {
        columnsString = req.body.columns
    } else {
        req.body.columns.forEach(element => {
            columnsString += element + ','
        });
        columnsString = columnsString.slice(0, -1)
    }
    const context = {
        'columns': columnsString,
        'table': req.body.table,
        'whereClause': req.body.whereClause
    };

    const rows = await dbAPI.find(context);

    try {
        res.status(200).json(rows);
    } catch (err) {
        next(err);
    }
}
module.exports.run = run;