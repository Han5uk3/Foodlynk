const https = require('https');

const data = JSON.stringify({
  whatAreYouCooking: "dinner",
  toWhomAreYouCooking: "family",
  numberOfServings: 4,
  dietaryPreferences: ["vegetarian"],
  ingredients: ["Tomato", "Cheese"],
  weight: "80",
  isDieting: false
});

const options = {
  hostname: 'us-central1-saver-app-2ae53.cloudfunctions.net',
  path: '/api/api-features/generate-protein-plan',
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'x-api-key': 'AIzaSyAHcM9LqAYQEhvGANJZCkqF53PVuOvH4SQ',
    'Content-Length': data.length
  }
};

const req = https.request(options, (res) => {
  let body = '';
  res.on('data', (d) => {
    body += d;
  });
  res.on('end', () => {
    console.log('STATUS:', res.statusCode);
    console.log('BODY:', body);
  });
});

req.on('error', (error) => {
  console.error(error);
});

req.write(data);
req.end();
