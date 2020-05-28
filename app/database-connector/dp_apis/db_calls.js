const database = require('../services/database.js');

async function find(context) {
    let query = `SELECT ${context.columns} FROM ${context.table}`;
    if (context.whereClause) {
        query += ` WHERE ${whereClause}`
    }
    console.log(query)
    const binds = {};

    const result = await database.simpleExecute(query, binds);

    return result.rows;
}

module.exports.find = find