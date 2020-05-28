const databaseController = require('../controllers/database.js');
const express = require('express');

const router = new express.Router();

router.route('/run/')
    .post(databaseController.run);


module.exports = router;