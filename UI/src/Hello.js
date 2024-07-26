// src/Hello.js
import React from 'react';
import styled from 'styled-components';

const HelloContainer = styled.div`
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100vh;
  background: linear-gradient(to right, #ff8c00, #ff4b2b);
  color: #fff;
  font-size: 24px;
`;

const Hello = ({ name, numberOfConnections }) => {
  return (
    <HelloContainer>
      <p>Hello, {name}!</p>
      {numberOfConnections !== null ? (
        <p>Number of database connections available is: {numberOfConnections}</p>
      ) : null}
    </HelloContainer>
  );
};

export default Hello;
