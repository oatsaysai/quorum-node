var rpc = require('node-json-rpc');

var options = {
  port: 22000,
  host: 'localhost',
  path: '/',
  strict: true
};

var client = new rpc.Client(options);

client.call({ jsonrpc: '2.0', method: 'txpool_status', id: 0 }, function(
  err,
  res
) {
  if (err) {
    console.log(err);
  } else {
    console.log(
      'status: {pending: ' +
        parseInt(res.result.pending, 16) +
        ',queued: ' +
        parseInt(res.result.queued, 16) +
        '}'
    );
  }
});
