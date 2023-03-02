Map<String, Map<String, dynamic>> nameToApiInfo = {
  "hello_world": {
    "primary": "localhost:8080",
    "fallback": "localhost:8080",
    "path": "/greeting",
    "type": "get"
  },
  "database_get": {
    "primary": "localhost:8080",
    "path": "/firebase_get",
    "type": "get"
  },
  "database_push": {
    "primary": "localhost:8080",
    "path": "/firebase_push",
    "type": "post"
  },
};
