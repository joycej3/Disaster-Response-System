Map<String, Map<String, dynamic>> nameToApiInfo = {
  "hello_world": {
    "primary": "localhost:8080",
    "fallback": "localhost:8080",
    "path": "backend/greeting",
    "type": "get"
  },
  "database_get": {
    "primary": "localhost:8080",
    "path": "backend/firebase_get",
    "type": "get"
  },
  "database_push": {
    "primary": "localhost:8080",
    "path": "backend/firebase_push",
    "type": "post"
  },
  "worker_get": {
    "primary": "localhost:8080",
    "path": "/worker/data",
    "type": "get"
  },
  "public_get": {
    "primary": "localhost:8080",
    "path": "/public/data",
    "type": "get"
  },
  "super_get": {
    "primary": "localhost:8080",
    "path": "/super/data",
    "type": "get"
  },
  "coordinator_get": {
    "primary": "localhost:8080",
    "path": "/coordinator/data",
    "type": "get"
  }
};
