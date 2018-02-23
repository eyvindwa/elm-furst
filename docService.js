const express = require('express');
const app = express();

app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });

app.get('/docs', (req, resp) => {
    console.log('Hello');
    resp.send(JSON.stringify( { "name" : "Dr. Stave" }))
});

app.listen(3000, () => console.log("HEllo, I'm running"));