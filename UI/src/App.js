import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import Hello from './Hello';
import axios from 'axios';

function App() {
  const [numberOfConnections, setNumberOfConnections] = useState(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const response = await axios.get('http://localhost:8080/connections');
        setNumberOfConnections(response.data.numberOfConnections);
      } catch (error) {
        console.error('Error fetching data from Express API:', error);
      }
    };

    fetchData();
  }, []);

  return (
    <Router>
      <div className="App">
        <Routes>
          <Route
            path="/"
            element={<Hello name="Naveen" />}
          />
          <Route
            path="/connections"
            element={<Hello name="Naveen" numberOfConnections={numberOfConnections} />}
          />
        </Routes>
      </div>
    </Router>
  );
}

export default App;