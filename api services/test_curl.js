const https = require('https');

const data = JSON.stringify({ ingredients: ['apple', 'banana'] });

const options = {
  hostname: 'us-central1-saver-app-2ae53.cloudfunctions.net',
  port: 443,
  path: '/api/api-features/generate-smart-recipe',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'x-api-key': 'AIzaSyAHcM9LqAYQEhvGANJZCkqF53PVuOvH4SQ',
    'Content-Length': data.length
  }
};

const req = https.request(options, res => {
  console.log(`statusCode: ${res.statusCode}`);
  let body = '';
  res.on('data', d => {
    body += d;
  });
  res.on('end', () => {
    console.log('BODY:', body);
  });
});

req.on('error', error => {
  console.error(error);
});

req.write(data);
req.end();
