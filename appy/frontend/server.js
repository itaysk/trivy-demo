const express = require('express');
const path = require('path');
const axios = require('axios');

const app = express();
const port = 8080;

app.use(express.static(path.join(__dirname, 'public')));

backendUrl = process.env.BACKEND_URL;
if (!backendUrl) {
    console.error('Error: BACKEND_URL environment variable is not set.');
    process.exit(1);
}

app.get('/ping', (req, res) => {
    axios.get(`${backendUrl}/ping`, {
        timeout: 5000
    })
    .then(response => {
        if (response.status == 200 && response.data) {
            res.json(response.data);
        } else {
            res.json({ message: 'Invalid response from backend service' });
        }
    })
    .catch(error => {
        if (error.code === 'ECONNABORTED') {
            res.json({ message: 'Request timed out' });
        } else {
            res.json({ message: 'Unknown error' });
        }
    });
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});