// app.js
const express = require('express');
const { Pool } = require('pg');

const app = express();
const port = 8080; // You can change this port if needed

const cors = require('cors');
app.use(cors());

// Replace these with your PostgreSQL connection details
const pool = new Pool({
  user: 'postgres',
  host: process.env.PG_HOST || 'localhost',
  database: 'testdb',
  password: 'postgres',
  port: 5432, // Default PostgreSQL port
});

app.get('/connections', async (req, res) => {
  try {
    const result = await pool.query('SELECT COUNT(*) FROM pg_stat_activity');
    const numberOfConnections = result.rows[0].count;
    res.json({ numberOfConnections });
  } catch (error) {
    console.error('Error fetching data from PostgreSQL:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
