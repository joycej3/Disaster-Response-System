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
  "red_button": {
    "primary": "localhost:8080",
    "path": "worker/red_button",
    "type": "get"
  },
  "worker_get": {
    "primary": "localhost:8080",
    "path": "worker/data",
    "type": "get"
  },
  "public_get": {
    "primary": "localhost:8080",
    "path": "public/data",
    "type": "get"
  },
  "super_get": {
    "primary": "localhost:8080",
    "path": "super/data",
    "type": "get"
  },
  "coordinator_get": {
    "primary": "localhost:8080",
    "path": "coordinator/data",
    "type": "get"
  },
  "get_user_info": {
    "primary": "localhost:8080",
    "path": "backend/get_user_info",
    "type": "get"
  },
  "get_suggestion": {
    "primary": "localhost:8080",
    "path": "worker/get_suggestion",
    "type": "get"
  },
  "aggregator_get": {
    "primary": "localhost:8080",
    "path": "worker/aggregator_get",
    "type": "get"
  }
};
