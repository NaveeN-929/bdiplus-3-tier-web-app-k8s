# Express App

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Overview

This is a simple Express application that fetches the number of database connections and displays it using a React frontend.

## Prerequisites

- Node.js and npm installed
- Docker installed
- Docker Hub account

## Installation

### Install Dependencies

```sh
npm install
```

### Run the Application Locally

```sh
npm start
```

The server will be running at `http://localhost:8080`.


## Docker Instructions

### Build the Docker Image

1. a multi-stage `Dockerfile`

2. Build the Docker image:
    ```sh
    docker build -t dockerhub-username/app:latest .
    ```

### Push the Docker Image to Docker Hub

1. Log in to Docker Hub:
    ```sh
    docker login
    ```

2. Push the Docker image:
    ```sh
    docker push dockerhub-username/app:latest
    ```

### Run the Docker Image

1. Pull the Docker image from Docker Hub (optional if you just pushed it):
    ```sh
    docker pull dockerhub-username/app:latest
    ```

2. Run the Docker container:
    ```sh
    docker run -p 8080:8080 dockerhub-username/app:latest
    ```

Open your browser and navigate to [http://localhost:8080](http://localhost:8080) to see the app running in a Docker container.


## API Endpoint

- `GET /connections`: Returns the number of database connections.