const express = require('express');
const app = express();

app.use(function(req, res, next) {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
    next();
  });
  
app.get('/docs', (req, resp) => {
    resp.send( JSON.stringify({ "name" : "Dr Doolittle"}));
});


var server = app.listen(3000, () => console.log('Super doc service listening on port 3000!'));