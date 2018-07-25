import express from 'express';
import http from 'http';
import bodyParser from 'body-parser';
import RateLimit from 'express-rate-limit';
import { default as yargs } from 'yargs';
import { default as quorumInterface } from '../../blockchain';

process.on('unhandledRejection', function(reason, p) {
  console.error('Unhandled Rejection:', p, '\nreason:', reason.stack || reason);
});

const WEB_SERVER_PORT = process.env.SERVER_PORT || 8181;
const app = express();

// --- JSON ---
app.use(bodyParser.urlencoded({ extended: false, limit: '2mb' }));
app.use(bodyParser.json({ limit: '2mb' }));

// --- plaintext ---
// app.use(bodyParser.text({ type: '*/*' }));

// --- TODO use limiter ---
// var limiter = new RateLimit({
//   delayAfter: 1,
//   delayMs: 1,
//   max: 1000
// });

// app.use(limiter);
// --- TODO use limiter ---

app.post('/send_all/:seq', (req, res) => {
  var seq = req.params.seq;
  // var data = req.body;
  var data = req.body.message;
  quorumInterface.createTransaction(seq, data, yargs.argv.node);
  res.send('Success');
});

app.post('/send_idp/:seq', (req, res) => {
  var seq = req.params.seq;
  // var data = req.body;
  var data = req.body.message;
  quorumInterface.createTransaction(seq, data, yargs.argv.node);
  res.send('Success');
});

const server = http.createServer(app);
server.listen(WEB_SERVER_PORT);

console.log(
  `Quorum RESTful API is running. Listening to port ${WEB_SERVER_PORT}`
);
