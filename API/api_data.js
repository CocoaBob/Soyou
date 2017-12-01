define({ "api": [
  {
    "type": "post",
    "url": "/api/analytics",
    "title": "Send user manipulation data",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Analytics\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Analytics",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "target",
            "description": "<p>Possible values: 1(News), 2(Products), 3(app: log usage of the app), 4(Discounts).</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "device",
            "description": "<p>Possible values: iOS, Android.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "action",
            "description": "<p>Possible values: 1(view), 2(like), 3(favorite), 4(share), 5(search), 6(launch).</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "data",
            "description": "<p>Possible values: id(view, like, share, favorite), scope|keywords(search), null(launch).</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operatedAt",
            "description": "<p>User manipulation UTC time.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "uuid",
            "description": "<p>Device uuid.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/analytics.js",
    "groupTitle": "Analytics",
    "name": "PostApiAnalytics"
  },
  {
    "type": "post",
    "url": "/api/analytics",
    "title": "Send user manipulation data",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Analytics\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Analytics",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "target",
            "description": "<p>Possible values: 1(News), 2(Products), 3(app: log usage of the app).</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "device",
            "description": "<p>Possible values: iOS, Android.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "action",
            "description": "<p>Possible values: 1(view), 2(like), 3(favorite), 4(share), 5(search), 6(launch).</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "data",
            "description": "<p>Possible values: id(view, like, share, favorite), scope|keywords(search), null(launch).</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operatedAt",
            "description": "<p>User manipulation UTC time.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "uuid",
            "description": "<p>Device uuid.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/analytics.js",
    "groupTitle": "Analytics",
    "name": "PostApiAnalytics"
  },
  {
    "type": "get",
    "url": "/api/auth/activate-account/:activationCode",
    "title": "activate an account",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, or null</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty array.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad request\n{\n   \"message\":\"Bad request\",\n   \"data\": [\"invalid_activation_code\"]\n}\nHTTP/1.1 500 Server error\n{\n   \"message\":\"Server error\",\n   \"data\": [\"server_error\"]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/authentication.js",
    "groupTitle": "Authentication",
    "name": "GetApiAuthActivateAccountActivationcode"
  },
  {
    "type": "get",
    "url": "/api/auth/activate-account/:activationCode",
    "title": "activate an account",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, or null</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty array.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad request\n{\n   \"message\":\"Bad request\",\n   \"data\": [\"invalid_activation_code\"]\n}\nHTTP/1.1 500 Server error\n{\n   \"message\":\"Server error\",\n   \"data\": [\"server_error\"]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/authentication.js",
    "groupTitle": "Authentication",
    "name": "GetApiAuthActivateAccountActivationcode"
  },
  {
    "type": "get",
    "url": "/api/secure/auth/check",
    "title": "Check if the user token is valid and renews the user token if it's valid",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, must exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"AuthCheck\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty array.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "401",
            "description": "<p>Unauthorized.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 401 Unauthorized\n{\n   \"message\": \"Unauthorized\",\n   \"data\": [\n         \"unauthorized\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/authentication.js",
    "groupTitle": "Authentication",
    "name": "GetApiSecureAuthCheck"
  },
  {
    "type": "get",
    "url": "/api/secure/auth/check",
    "title": "Check if the user token is valid and renews the user token if it's valid",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, must exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"AuthCheck\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty array.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "401",
            "description": "<p>Unauthorized.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 401 Unauthorized\n{\n   \"message\": \"Unauthorized\",\n   \"data\": [\n         \"unauthorized\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/authentication.js",
    "groupTitle": "Authentication",
    "name": "GetApiSecureAuthCheck"
  },
  {
    "type": "post",
    "url": "/api/auth/login",
    "title": "Login",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>The login.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>The password.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "uuid",
            "description": "<p>The uuid.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The granted user info.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"Login succeeded\",\n   \"data\":{\n             \"token\":\"asdfa\",\n             \"username\": \"sfwef\",\n             \"gender\": \"1\",\n             \"matricule\": 666666,\n             \"roleCode\":\"dffe\",\n             \"region\":\"中国\"\n          }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"email_password_cannot_be_empty\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"email_not_exist\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"incorrect_password\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthLogin"
  },
  {
    "type": "post",
    "url": "/api/auth/login",
    "title": "Login",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>The login.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>The password.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "uuid",
            "description": "<p>The uuid.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The granted user info.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"Login succeeded\",\n   \"data\":{\n             \"token\":\"asdfa\",\n             \"username\": \"sfwef\",\n             \"gender\": \"1\",\n             \"matricule\": 666666,\n             \"roleCode\":\"dffe\",\n             \"region\":\"中国\"\n          }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"email_password_cannot_be_empty\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"email_not_exist\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"incorrect_password\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthLogin"
  },
  {
    "type": "post",
    "url": "/api/auth/logout",
    "title": "Logout",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\"\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\"\n   \"data\":[\n        \"logout_failed\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthLogout"
  },
  {
    "type": "post",
    "url": "/api/auth/logout",
    "title": "Logout",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\"\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\"\n   \"data\":[\n        \"logout_failed\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthLogout"
  },
  {
    "type": "post",
    "url": "/api/auth/password",
    "title": "Reset password",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "verificationCode",
            "description": "<p>The verify code.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>The new password.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data.",
            "description": ""
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"Password reset succeeded\",\n   \"data\":{\n             \"token\":\"asdfa\",\n             \"roleCode\":\"dffe\"\n          }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n          \"invalid_verification_code\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthPassword"
  },
  {
    "type": "post",
    "url": "/api/auth/password",
    "title": "Reset password",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "verificationCode",
            "description": "<p>The verify code.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>The new password.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data.",
            "description": ""
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"Password reset succeeded\",\n   \"data\":{\n             \"token\":\"asdfa\",\n             \"roleCode\":\"dffe\"\n          }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n          \"invalid_verification_code\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthPassword"
  },
  {
    "type": "post",
    "url": "/api/auth/register",
    "title": "Register",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>The login.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>The password alphanumeric. containing at least 8 characters, in which at least 1 number, 1 upper and 1 lowercase</p>"
          },
          {
            "group": "Parameter",
            "type": "Enum",
            "optional": false,
            "field": "gender",
            "description": "<p>, possible values &quot;1&quot;: neutral, &quot;2&quot;: male, &quot;3&quot;: female</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"Register succeeded\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"email_password_cannot_be_empty\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"email_already_exist\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthRegister"
  },
  {
    "type": "post",
    "url": "/api/auth/register",
    "title": "Register",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>The login.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "password",
            "description": "<p>The password alphanumeric. containing at least 8 characters, in which at least 1 number, 1 upper and 1 lowercase</p>"
          },
          {
            "group": "Parameter",
            "type": "Enum",
            "optional": false,
            "field": "gender",
            "description": "<p>, possible values &quot;1&quot;: neutral, &quot;2&quot;: male, &quot;3&quot;: female</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"Register succeeded\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"email_password_cannot_be_empty\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"email_already_exist\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthRegister"
  },
  {
    "type": "post",
    "url": "/api/auth/third",
    "title": "login by third party",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "type",
            "description": "<p>the name of the third party (possible values: sinaweibo, ...).</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "accessToken",
            "description": "<p>the access token</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "thirdId",
            "description": "<p>the thirdId</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "uuid",
            "description": "<p>the device uuid</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "username",
            "description": "<p>the access token</p>"
          },
          {
            "group": "Parameter",
            "type": "Enum",
            "optional": false,
            "field": "gender",
            "description": "<p>, possible values &quot;1&quot;: neutral, &quot;2&quot;: male, &quot;3&quot;: female</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The granted user info..</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n          \"token\": \"162f97cd1a0176eade5f54aa\",\n          \"username\": \"hh\",\n          \"gender\": \"0\",\n          \"matricule\": 100074,\n          \"roleCode\": \"Basic\",\n          \"region\": null\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"incorrect_third_token\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthThird"
  },
  {
    "type": "post",
    "url": "/api/auth/third",
    "title": "login by third party",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "type",
            "description": "<p>the name of the third party (possible values: sinaweibo, ...).</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "accessToken",
            "description": "<p>the access token</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "thirdId",
            "description": "<p>the thirdId</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "uuid",
            "description": "<p>the device uuid</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "username",
            "description": "<p>the access token</p>"
          },
          {
            "group": "Parameter",
            "type": "Enum",
            "optional": false,
            "field": "gender",
            "description": "<p>, possible values &quot;1&quot;: neutral, &quot;2&quot;: male, &quot;3&quot;: female</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The granted user info..</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n          \"token\": \"162f97cd1a0176eade5f54aa\",\n          \"username\": \"hh\",\n          \"gender\": \"0\",\n          \"matricule\": 100074,\n          \"roleCode\": \"Basic\",\n          \"region\": null\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"incorrect_third_token\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthThird"
  },
  {
    "type": "post",
    "url": "/api/auth/verify-code",
    "title": "Request verify code",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>The email address to which an email will be sent.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\"\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Bad request\n{\n   \"message\": \"Server error\" ,\n   \"data\": [\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"invalid_login\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthVerifyCode"
  },
  {
    "type": "post",
    "url": "/api/auth/verify-code",
    "title": "Request verify code",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Auth\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Authentication",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>The email address to which an email will be sent.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\"\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Bad request\n{\n   \"message\": \"Server error\" ,\n   \"data\": [\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"invalid_login\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/authentication.js",
    "groupTitle": "Authentication",
    "name": "PostApiAuthVerifyCode"
  },
  {
    "type": "get",
    "url": "/api/brands",
    "title": "Request all brands list",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Brands\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Brands",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The Brands list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":[\n           {\n              \"id\": 1,\n              \"label\": \"BURBERRY\",\n              \"imageUrl\": \"http://www.geocities.ws/iprice/imgs/o-burberry.jpg\",\n              \"extra\": null,\n              \"isHot\": true,\n              \"brandIndex\": \"A\",\n              \"order\": 0,\n\t\t         \"categories\": [\n\t\t     \t    {\n\t\t     \t        \"id\": 1,\n\t\t\t            \"label\": \"女士\"\n\t\t\t            \"parentId\": null,\n\t\t\t            \"order\": 0\n\t\t\t        },\n\t\t\t       {\n\t\t     \t        \"id\": 2,\n\t\t\t            \"label\": \"手包\"\n\t\t\t            \"parentId\": 1,\n\t\t\t            \"order\": 1\n\t\t\t        }\n              ]\n           }\n       ]\n    }",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/brands.js",
    "groupTitle": "Brands",
    "name": "GetApiBrands"
  },
  {
    "type": "get",
    "url": "/api/brands",
    "title": "Request all brands list",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Brands\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Brands",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The Brands list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":[\n           {\n              \"id\": 1,\n              \"label\": \"BURBERRY\",\n              \"imageUrl\": \"http://www.geocities.ws/iprice/imgs/o-burberry.jpg\",\n              \"extra\": null,\n              \"isHot\": true,\n              \"brandIndex\": \"A\",\n              \"order\": 0,\n\t\t         \"categories\": [\n\t\t     \t    {\n\t\t     \t        \"id\": 1,\n\t\t\t            \"label\": \"女士\"\n\t\t\t            \"parentId\": null,\n\t\t\t            \"order\": 0\n\t\t\t        },\n\t\t\t       {\n\t\t     \t        \"id\": 2,\n\t\t\t            \"label\": \"手包\"\n\t\t\t            \"parentId\": 1,\n\t\t\t            \"order\": 1\n\t\t\t        }\n              ]\n           }\n       ]\n    }",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/brands.js",
    "groupTitle": "Brands",
    "name": "GetApiBrands"
  },
  {
    "type": "get",
    "url": "/api/currencyRates/:query",
    "title": "Request currency exchange rates",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Currencies\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Currency",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "id",
            "description": "<p>The news query with following format : EUR:CNY,USD:CNY</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"sourceCode\": USD,\n         \"targetCode\": \"CNY\",\n         \"rate\": 6.5895\n     },\n     {\n         \"sourceCode\": EUR,\n         \"targetCode\": \"CNY\",\n         \"rate\": 7.5895\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/currencies.js",
    "groupTitle": "Currency",
    "name": "GetApiCurrencyratesQuery"
  },
  {
    "type": "get",
    "url": "/api/currencyRates/:query",
    "title": "Request currency exchange rates",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Currencies\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Currency",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "id",
            "description": "<p>The news query with following format : EUR:CNY,USD:CNY</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"sourceCode\": USD,\n         \"targetCode\": \"CNY\",\n         \"rate\": 6.5895\n     },\n     {\n         \"sourceCode\": EUR,\n         \"targetCode\": \"CNY\",\n         \"rate\": 7.5895\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/currencies.js",
    "groupTitle": "Currency",
    "name": "GetApiCurrencyratesQuery"
  },
  {
    "type": "delete",
    "url": "/api/discounts/comments/:commentIds",
    "title": "deletes comments",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentIds",
            "description": "<p>The comment ids, for ex: '1, 2'</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/discounts.js",
    "groupTitle": "Discounts",
    "name": "DeleteApiDiscountsCommentsCommentids"
  },
  {
    "type": "delete",
    "url": "/api/discounts/comments/:commentIds",
    "title": "deletes comments",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentIds",
            "description": "<p>The comment ids, for ex: '1, 2'</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/discounts.js",
    "groupTitle": "Discounts",
    "name": "DeleteApiDiscountsCommentsCommentids"
  },
  {
    "type": "get",
    "url": "/api/discounts/:id",
    "title": "Request a specific discount by id",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discounts list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":{\n             \"id\":1,\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"subtitle\":\"the subtitle\",\n             \"coverImage\":\"http://www.geocities.ws/baodating/app/discounts/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"content\":\"abcde\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\",\n             \"publishDate\":\"2015-09-06T00:00:00.000Z\"\n          }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Not Found\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsId"
  },
  {
    "type": "get",
    "url": "/api/discounts/:id",
    "title": "Request a specific discount by id",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discounts list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":{\n             \"id\":1,\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"subtitle\":\"the subtitle\",\n             \"coverImage\":\"http://www.geocities.ws/baodating/app/discounts/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"content\":\"abcde\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\",\n             \"publishDate\":\"2015-09-06T00:00:00.000Z\"\n          }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Not Found\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsId"
  },
  {
    "type": "get",
    "url": "/api/discounts/:id/comments/:number/:commentId",
    "title": "Request n discount comments created before the comment specified by the commentId. The parentUsername and parentComment are null is parentComment is deleted, parentMatricule is always present.",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of comments to fetch.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The comment to compare to, use 0 if not specified.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"id\": 2,\n         \"username\": \"Jime\",\n         \"matricule\": 123455,\n         \"comment\": \"comment content1\",\n         \"parentUsername\": null,\n         \"parentMatricule\": null,\n         \"parentComment\": null,\n         \"canDelete\": 1\n     },\n     {\n         \"id\": 3,\n         \"username\": \"Mike\",\n         \"matricule\": 12,\n         \"comment\": \"comment content2\",\n         \"parentUsername\": \"Li Lei\",\n         \"parentMatricule\": 9988,\n         \"parentComment\": \"comment content0\",\n         \"canDelete\": 0\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsIdCommentsNumberCommentid"
  },
  {
    "type": "get",
    "url": "/api/discounts/:id/comments/:number/:commentId",
    "title": "Request n discount comments created before the comment specified by the commentId. The parentUsername and parentComment are null is parentComment is deleted, parentMatricule is always present.",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of comments to fetch.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The comment to compare to, use 0 if not specified.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"id\": 2,\n         \"username\": \"Jime\",\n         \"matricule\": 123455,\n         \"comment\": \"comment content1\",\n         \"parentUsername\": null,\n         \"parentMatricule\": null,\n         \"parentComment\": null,\n         \"canDelete\": 1\n     },\n     {\n         \"id\": 3,\n         \"username\": \"Mike\",\n         \"matricule\": 12,\n         \"comment\": \"comment content2\",\n         \"parentUsername\": \"Li Lei\",\n         \"parentMatricule\": 9988,\n         \"parentComment\": \"comment content0\",\n         \"canDelete\": 0\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsIdCommentsNumberCommentid"
  },
  {
    "type": "get",
    "url": "/api/discounts/:id/extra",
    "title": "Request extra information of a specified discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"likeNumber\": 10,\n     \"isFavorite\": 1,\n     \"isLiked\": 1,\n     \"commentNumber\": 5\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsIdExtra"
  },
  {
    "type": "get",
    "url": "/api/discounts/:id/extra",
    "title": "Request extra information of a specified discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"likeNumber\": 10,\n     \"isFavorite\": 1,\n     \"isLiked\": 1,\n     \"commentNumber\": 5\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsIdExtra"
  },
  {
    "type": "get",
    "url": "/api/discounts/latest/:number",
    "title": "Request latest n discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of discounts.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discounts list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"title\":\"The first discounts\",\n             \"coverImage\":\"http://www.geocities.ws/baodating/app/discounts/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"publishDate\":\"2014-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsLatestNumber"
  },
  {
    "type": "get",
    "url": "/api/discounts/latest/:number",
    "title": "Request latest n discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of discounts.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discounts list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"title\":\"The first discounts\",\n             \"coverImage\":\"http://www.geocities.ws/baodating/app/discounts/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"publishDate\":\"2014-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsLatestNumber"
  },
  {
    "type": "get",
    "url": "/api/discounts/next/:number/:id",
    "title": "Request n newer discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of discounts.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The id of the discounts to compare.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discounts list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"title\":\"The first discounts\",\n             \"coverImage\":\"http://www.geocities.ws/baodating/app/discounts/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"publishDate\":\"2014-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n         }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"message\":\"bad_request\"\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsNextNumberId"
  },
  {
    "type": "get",
    "url": "/api/discounts/next/:number/:id",
    "title": "Request n newer discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of discounts.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The id of the discounts to compare.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discounts list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"title\":\"The first discounts\",\n             \"coverImage\":\"http://www.geocities.ws/baodating/app/discounts/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"publishDate\":\"2014-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n         }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"message\":\"bad_request\"\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsNextNumberId"
  },
  {
    "type": "get",
    "url": "/api/discounts/previous/:number/:id",
    "title": "Request n older discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of discounts.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The id of the discounts to compare.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discounts list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"title\":\"The first discounts\",\n             \"coverImage\":\"http://www.geocities.ws/baodating/app/discounts/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"publishDate\":\"2014-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n         }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n     }\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsPreviousNumberId"
  },
  {
    "type": "get",
    "url": "/api/discounts/previous/:number/:id",
    "title": "Request n older discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of discounts.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The id of the discounts to compare.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discounts list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"title\":\"The first discounts\",\n             \"coverImage\":\"http://www.geocities.ws/baodating/app/discounts/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"publishDate\":\"2014-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n         }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n     }\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/discounts.js",
    "groupTitle": "Discounts",
    "name": "GetApiDiscountsPreviousNumberId"
  },
  {
    "type": "post",
    "url": "/api/discounts",
    "title": "Request a collection of discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "ids",
            "description": "<p>The discount id list.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discounts list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"title\":\"The first discounts\",\n             \"coverImage\":\"http://www.geocities.ws/baodating/app/discounts/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"publishDate\":\"2014-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n         }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/discounts.js",
    "groupTitle": "Discounts",
    "name": "PostApiDiscounts"
  },
  {
    "type": "post",
    "url": "/api/discounts",
    "title": "Request a collection of discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "ids",
            "description": "<p>The discount id list.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discounts list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"title\":\"The first discounts\",\n             \"coverImage\":\"http://www.geocities.ws/baodating/app/discounts/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"publishDate\":\"2014-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n         }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/discounts.js",
    "groupTitle": "Discounts",
    "name": "PostApiDiscounts"
  },
  {
    "type": "post",
    "url": "/api/secure/discounts/:id/comments/:commentId",
    "title": "Create a comment against a discount",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The parent comment id, use 0 if not specified.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "comment",
            "description": "<p>The comment content.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"id\": 13\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/discounts.js",
    "groupTitle": "Discounts",
    "name": "PostApiSecureDiscountsIdCommentsCommentid"
  },
  {
    "type": "post",
    "url": "/api/secure/discounts/:id/comments/:commentId",
    "title": "Create a comment against a discount",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The parent comment id, use 0 if not specified.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "comment",
            "description": "<p>The comment content.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"id\": 13\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/discounts.js",
    "groupTitle": "Discounts",
    "name": "PostApiSecureDiscountsIdCommentsCommentid"
  },
  {
    "type": "post",
    "url": "/api/secure/discounts/:id/like",
    "title": "Like a discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/discounts.js",
    "groupTitle": "Discounts",
    "name": "PostApiSecureDiscountsIdLike"
  },
  {
    "type": "post",
    "url": "/api/secure/discounts/:id/like",
    "title": "Like a discounts",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Discounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/discounts.js",
    "groupTitle": "Discounts",
    "name": "PostApiSecureDiscountsIdLike"
  },
  {
    "type": "get",
    "url": "/api/secure/favorite/discounts",
    "title": "Request all discount favorites",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteDiscounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_Discounts",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discountId list, order by add date.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":[\n         {\n\t          \"id\": 1,\n\t\t      \"dateModification\": \"2016-05-22T16:41:35.000Z\"\n\t\t    },\n         {\n\t          \"id\": 2,\n\t\t      \"dateModification\": \"2016-05-22T16:41:35.000Z\"\n\t\t    }\n       ]\n    }",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/favorites.js",
    "groupTitle": "Favorite_Discounts",
    "name": "GetApiSecureFavoriteDiscounts"
  },
  {
    "type": "get",
    "url": "/api/secure/favorite/discounts",
    "title": "Request all discount favorites",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteDiscounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_Discounts",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The discountId list, order by add date.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":[\n         {\n\t          \"id\": 1,\n\t\t      \"dateModification\": \"2016-05-22T16:41:35.000Z\"\n\t\t    },\n         {\n\t          \"id\": 2,\n\t\t      \"dateModification\": \"2016-05-22T16:41:35.000Z\"\n\t\t    }\n       ]\n    }",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/favorites.js",
    "groupTitle": "Favorite_Discounts",
    "name": "GetApiSecureFavoriteDiscounts"
  },
  {
    "type": "post",
    "url": "/api/secure/favorite/discounts/:id",
    "title": "Add or remove a discount to favorite",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteDiscounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/favorites.js",
    "groupTitle": "Favorite_Discounts",
    "name": "PostApiSecureFavoriteDiscountsId"
  },
  {
    "type": "post",
    "url": "/api/secure/favorite/discounts/:id",
    "title": "Add or remove a discount to favorite",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteDiscounts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_Discounts",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/favorites.js",
    "groupTitle": "Favorite_Discounts",
    "name": "PostApiSecureFavoriteDiscountsId"
  },
  {
    "type": "get",
    "url": "/api/secure/favorite/news",
    "title": "Request all news favorites",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteNews\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_News",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The newsId list, order by add date.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":[\n         {\n\t          \"id\": 1,\n\t\t      \"dateModification\": \"\"\n\t\t    },\n         {\n\t          \"id\": 2,\n\t\t      \"dateModification\": \"\"\n\t\t    }\n       ]\n    }",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/favorites.js",
    "groupTitle": "Favorite_News",
    "name": "GetApiSecureFavoriteNews"
  },
  {
    "type": "get",
    "url": "/api/secure/favorite/news",
    "title": "Request all news favorites",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteNews\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_News",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The newsId list, order by add date.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":[\n         {\n\t          \"id\": 1,\n\t\t      \"dateModification\": \"\"\n\t\t    },\n         {\n\t          \"id\": 2,\n\t\t      \"dateModification\": \"\"\n\t\t    }\n       ]\n    }",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/favorites.js",
    "groupTitle": "Favorite_News",
    "name": "GetApiSecureFavoriteNews"
  },
  {
    "type": "post",
    "url": "/api/secure/favorite/news/:id",
    "title": "Add or remove a news to favorite",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteNews\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/favorites.js",
    "groupTitle": "Favorite_News",
    "name": "PostApiSecureFavoriteNewsId"
  },
  {
    "type": "post",
    "url": "/api/secure/favorite/news/:id",
    "title": "Add or remove a news to favorite",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteNews\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/favorites.js",
    "groupTitle": "Favorite_News",
    "name": "PostApiSecureFavoriteNewsId"
  },
  {
    "type": "get",
    "url": "/api/secure/favorite/category-products/:categoryId",
    "title": "Request all favorite products of a specified category",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteProductsByCategory\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "categoryId",
            "description": "<p>The product categoryId.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The productId list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\"productId\": 1},\n     {\"productId\": 2}\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/favorites.js",
    "groupTitle": "Favorite_Products",
    "name": "GetApiSecureFavoriteCategoryProductsCategoryid"
  },
  {
    "type": "get",
    "url": "/api/secure/favorite/category-products/:categoryId",
    "title": "Request all favorite products of a specified category",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteProductsByCategory\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "categoryId",
            "description": "<p>The product categoryId.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The productId list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\"productId\": 1},\n     {\"productId\": 2}\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/favorites.js",
    "groupTitle": "Favorite_Products",
    "name": "GetApiSecureFavoriteCategoryProductsCategoryid"
  },
  {
    "type": "get",
    "url": "/api/secure/favorite/products",
    "title": "Request all product favorites",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteProducts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_Products",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The productId list, order by add date.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":[\n         {\n\t          \"id\": 1,\n\t\t      \"dateModification\": \"\"\n\t\t    },\n         {\n\t          \"id\": 2,\n\t\t      \"dateModification\": \"\"\n\t\t    }\n       ]\n    }",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/favorites.js",
    "groupTitle": "Favorite_Products",
    "name": "GetApiSecureFavoriteProducts"
  },
  {
    "type": "get",
    "url": "/api/secure/favorite/products",
    "title": "Request all product favorites",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteProducts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_Products",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The productId list, order by add date.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":[\n         {\n\t          \"id\": 1,\n\t\t      \"dateModification\": \"\"\n\t\t    },\n         {\n\t          \"id\": 2,\n\t\t      \"dateModification\": \"\"\n\t\t    }\n       ]\n    }",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/favorites.js",
    "groupTitle": "Favorite_Products",
    "name": "GetApiSecureFavoriteProducts"
  },
  {
    "type": "post",
    "url": "/api/secure/favorite/products/:id",
    "title": "Add a product to favorite",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteProducts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>empty list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The productId is not valid.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Parameter not valid\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/favorites.js",
    "groupTitle": "Favorite_Products",
    "name": "PostApiSecureFavoriteProductsId"
  },
  {
    "type": "post",
    "url": "/api/secure/favorite/products/:id",
    "title": "Add a product to favorite",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"FavoriteProducts\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Favorite_Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>empty list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The productId is not valid.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Parameter not valid\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/favorites.js",
    "groupTitle": "Favorite_Products",
    "name": "PostApiSecureFavoriteProductsId"
  },
  {
    "type": "delete",
    "url": "/api/news/comments/:commentIds",
    "title": "deletes comments",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentIds",
            "description": "<p>The comment ids, for ex: '1, 2'</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "DeleteApiNewsCommentsCommentids"
  },
  {
    "type": "delete",
    "url": "/api/news/comments/:commentIds",
    "title": "deletes comments",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentIds",
            "description": "<p>The comment ids, for ex: '1, 2'</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "DeleteApiNewsCommentsCommentids"
  },
  {
    "type": "get",
    "url": "/api/news/:id",
    "title": "Request a specific news by id",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The news list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":{\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"content\":\"abcde\",\n             \"isOnline\": 0,\n             \"url\":\"http://www.lemonde.fr\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\"\n          }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Not Found\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsId"
  },
  {
    "type": "get",
    "url": "/api/news/:id",
    "title": "Request a specific news by id",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The news list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":{\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"content\":\"abcde\",\n             \"isOnline\": 0,\n             \"url\":\"http://www.lemonde.fr\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\"\n          }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Not Found\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsId"
  },
  {
    "type": "get",
    "url": "/api/news/:id/comments/:number/:commentId",
    "title": "Request n news comments created before the comment specified by the commentId. The parentUsername and parentComment are null is parentComment is deleted, parentMatricule is always present.",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of comments to fetch.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The comment to compare to, use 0 if not specified.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"id\": 2,\n         \"username\": \"Jime\",\n         \"matricule\": 123455,\n         \"comment\": \"comment content1\",\n         \"parentUsername\": null,\n         \"parentMatricule\": null,\n         \"parentComment\": null,\n         \"canDelete\": 1\n     },\n     {\n         \"id\": 3,\n         \"username\": \"Mike\",\n         \"matricule\": 12,\n         \"comment\": \"comment content2\",\n         \"parentUsername\": \"Li Lei\",\n         \"parentMatricule\": 9988,\n         \"parentComment\": \"comment content0\",\n         \"canDelete\": 0\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsIdCommentsNumberCommentid"
  },
  {
    "type": "get",
    "url": "/api/news/:id/comments/:number/:commentId",
    "title": "Request n news comments created before the comment specified by the commentId. The parentUsername and parentComment are null is parentComment is deleted, parentMatricule is always present.",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of comments to fetch.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The comment to compare to, use 0 if not specified.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"id\": 2,\n         \"username\": \"Jime\",\n         \"matricule\": 123455,\n         \"comment\": \"comment content1\",\n         \"parentUsername\": null,\n         \"parentMatricule\": null,\n         \"parentComment\": null,\n         \"canDelete\": 1\n     },\n     {\n         \"id\": 3,\n         \"username\": \"Mike\",\n         \"matricule\": 12,\n         \"comment\": \"comment content2\",\n         \"parentUsername\": \"Li Lei\",\n         \"parentMatricule\": 9988,\n         \"parentComment\": \"comment content0\",\n         \"canDelete\": 0\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsIdCommentsNumberCommentid"
  },
  {
    "type": "get",
    "url": "/api/news/:id/extra",
    "title": "Request extra information of a specified news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"likeNumber\": 10,\n     \"isFavorite\": 1,\n     \"isLiked\": 1,\n     \"commentNumber\": 5\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsIdExtra"
  },
  {
    "type": "get",
    "url": "/api/news/:id/extra",
    "title": "Request extra information of a specified news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"likeNumber\": 10,\n     \"isFavorite\": 1,\n     \"isLiked\": 1,\n     \"commentNumber\": 5\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsIdExtra"
  },
  {
    "type": "get",
    "url": "/api/news/latest/:number",
    "title": "Request latest n news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of news.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The news list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsLatestNumber"
  },
  {
    "type": "get",
    "url": "/api/news/latest/:number",
    "title": "Request latest n news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of news.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The news list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsLatestNumber"
  },
  {
    "type": "get",
    "url": "/api/news/next/:number/:id",
    "title": "Request n newer news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of news.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The id of the news to compare.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The news list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"message\":\"bad_request\"\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsNextNumberId"
  },
  {
    "type": "get",
    "url": "/api/news/next/:number/:id",
    "title": "Request n newer news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of news.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The id of the news to compare.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The news list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"message\":\"bad_request\"\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsNextNumberId"
  },
  {
    "type": "get",
    "url": "/api/news/previous/:number/:id",
    "title": "Request n older news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of news.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The id of the news to compare.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The news list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n     }\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsPreviousNumberId"
  },
  {
    "type": "get",
    "url": "/api/news/previous/:number/:id",
    "title": "Request n older news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of news.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The id of the news to compare.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The news list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n     }\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "GetApiNewsPreviousNumberId"
  },
  {
    "type": "post",
    "url": "/api/news",
    "title": "Request a collection of news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "ids",
            "description": "<p>The news id list.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The news list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "PostApiNews"
  },
  {
    "type": "post",
    "url": "/api/news",
    "title": "Request a collection of news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "ids",
            "description": "<p>The news id list.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The news list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>The parameter is not valid.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "PostApiNews"
  },
  {
    "type": "post",
    "url": "/api/news/:id/like",
    "title": "Like a news deprecated",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": 10\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "PostApiNewsIdLike"
  },
  {
    "type": "post",
    "url": "/api/news/:id/like",
    "title": "Like a news deprecated",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": 10\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "PostApiNewsIdLike"
  },
  {
    "type": "post",
    "url": "/api/secure/news/:id/comments/:commentId",
    "title": "Create a comment against a news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The parent comment id, use 0 if not specified.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "comment",
            "description": "<p>The comment content.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"id\": 13\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "PostApiSecureNewsIdCommentsCommentid"
  },
  {
    "type": "post",
    "url": "/api/secure/news/:id/comments/:commentId",
    "title": "Create a comment against a news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The parent comment id, use 0 if not specified.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "comment",
            "description": "<p>The comment content.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"id\": 13\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "PostApiSecureNewsIdCommentsCommentid"
  },
  {
    "type": "post",
    "url": "/api/secure/news/:id/like",
    "title": "Like a news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": 10\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/news.js",
    "groupTitle": "News",
    "name": "PostApiSecureNewsIdLike"
  },
  {
    "type": "post",
    "url": "/api/secure/news/:id/like",
    "title": "Like a news",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"News\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "News",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": 10\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/news.js",
    "groupTitle": "News",
    "name": "PostApiSecureNewsIdLike"
  },
  {
    "type": "post",
    "url": "/api/notifications/register",
    "title": "Register a device for push notification",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Notification\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Notifications",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "uuid",
            "description": "<p>The uuid.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "deviceToken",
            "description": "<p>The deviceToken get from apple.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": []\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\n\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/notification.js",
    "groupTitle": "Notifications",
    "name": "PostApiNotificationsRegister"
  },
  {
    "type": "post",
    "url": "/api/notifications/register",
    "title": "Register a device for push notification",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Notification\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Notifications",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "uuid",
            "description": "<p>The uuid.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "deviceToken",
            "description": "<p>The deviceToken get from apple.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": []\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\n\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/notification.js",
    "groupTitle": "Notifications",
    "name": "PostApiNotificationsRegister"
  },
  {
    "type": "post",
    "url": "/api/notifications/register-monitor",
    "title": "Register a device for monitoring the server status",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Notification\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Notifications",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "deviceToken",
            "description": "<p>The deviceToken.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": []\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/notification.js",
    "groupTitle": "Notifications",
    "name": "PostApiNotificationsRegisterMonitor"
  },
  {
    "type": "post",
    "url": "/api/notifications/register-monitor",
    "title": "Register a device for monitoring the server status",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Notification\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Notifications",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "deviceToken",
            "description": "<p>The deviceToken.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": []\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/notification.js",
    "groupTitle": "Notifications",
    "name": "PostApiNotificationsRegisterMonitor"
  },
  {
    "type": "delete",
    "url": "/api/products/comments/:commentIds",
    "title": "deletes comments",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentIds",
            "description": "<p>The comment ids, for ex: '1, 2'</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "DeleteApiProductsCommentsCommentids"
  },
  {
    "type": "delete",
    "url": "/api/products/comments/:commentIds",
    "title": "deletes comments",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentIds",
            "description": "<p>The comment ids, for ex: '1, 2'</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "DeleteApiProductsCommentsCommentids"
  },
  {
    "type": "get",
    "url": "/api/product/:id",
    "title": "Request a product by id which must be active",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"id\": 870,\n     \"sku\": \"sdfwef\",\n     \"title\": \"SAC � BANDOULI�RE LILY TWIST EN VISON ET AYERS \",\n     \"brandId\": 5,\n     \"surname\": null,\n     \"keywords\": null,\n     \"brandLabel\": \"DOLCE & GABBANA\",\n     \"reference\": \"BB5948A8710\",\n     \"dimension\": \"20 X 30 X 50\",\n     \"descriptions\":\"<ul><li>Sac avec bandouli�re r�glable et amovible</li></ul>\",\n     \"likeNumber\": 0,\n     \"categories\": \"|1|2|\",\n     \"prices\": [\n         {\n             \"country\": \"??\",\n             \"currency\": \"CNY\",\n             \"officialUrl\": \"http://awefaweff\",\n             \"price\": 1450\n         }\n     ],\n     \"images\": [\n             \"http://cdn.yoox.biz/55/55011908QN_13_F.jpg\",\n             \"http://cdn.yoox.biz/55/55011908QN_13_R.jpg\",\n             \"http://cdn.yoox.biz/55/55011908QN_13_E.jpg\",\n             \"http://cdn.yoox.biz/55/55011908QN_13_D.jpg\"\n     ]\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductId"
  },
  {
    "type": "get",
    "url": "/api/product/:id",
    "title": "Request a product by id which must be active",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"id\": 870,\n     \"sku\": \"sdfwef\",\n     \"title\": \"SAC � BANDOULI�RE LILY TWIST EN VISON ET AYERS \",\n     \"brandId\": 5,\n     \"surname\": null,\n     \"keywords\": null,\n     \"brandLabel\": \"DOLCE & GABBANA\",\n     \"reference\": \"BB5948A8710\",\n     \"dimension\": \"20 X 30 X 50\",\n     \"descriptions\":\"<ul><li>Sac avec bandouli�re r�glable et amovible</li></ul>\",\n     \"likeNumber\": 0,\n     \"categories\": \"|1|2|\",\n     \"prices\": [\n         {\n             \"country\": \"??\",\n             \"currency\": \"CNY\",\n             \"officialUrl\": \"http://awefaweff\",\n             \"price\": 1450\n         }\n     ],\n     \"images\": [\n             \"http://cdn.yoox.biz/55/55011908QN_13_F.jpg\",\n             \"http://cdn.yoox.biz/55/55011908QN_13_R.jpg\",\n             \"http://cdn.yoox.biz/55/55011908QN_13_E.jpg\",\n             \"http://cdn.yoox.biz/55/55011908QN_13_D.jpg\"\n     ]\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductId"
  },
  {
    "type": "get",
    "url": "/api/products",
    "title": "Request all product ids, only active products of active brands will be returned",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product list, ordered.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     1,\n     2\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "GetApiProducts"
  },
  {
    "type": "get",
    "url": "/api/products",
    "title": "Request all product ids, only active products of active brands will be returned",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product list, ordered.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\n         \"id\": 310,\n         \"brandId\": 1,\n         \"categories\": \"|1|2|\",\n         \"dateModification\": \"2015-10-11T21:04:48.000Z\"\n     },\n    {\n         \"id\": 1,\n         \"brandId\": 2,\n         \"categories\": \"||\",\n         \"dateModification\": \"2015-10-11T21:04:48.000Z\"\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products-standby.js",
    "groupTitle": "Products",
    "name": "GetApiProducts"
  },
  {
    "type": "get",
    "url": "/api/products",
    "title": "Request all product ids, only active products of active brands will be returned",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product list, ordered.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     1,\n     2\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "GetApiProducts"
  },
  {
    "type": "get",
    "url": "/api/products/deleted",
    "title": "Request all inactive product ids",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The results.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"timestamp\": \"2015-10-11T21:04:48.000Z\",\n     \"products\": [\n         1,\n         2\n     ]\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsDeleted"
  },
  {
    "type": "get",
    "url": "/api/products/deleted",
    "title": "Request all inactive product ids",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The results.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"timestamp\": \"2015-10-11T21:04:48.000Z\",\n     \"products\": [\n         1,\n         2\n     ]\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsDeleted"
  },
  {
    "type": "get",
    "url": "/api/products/deleted/:timestamp",
    "title": "Request all inactive product ids which have been modified after the timestamp",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "timestamp",
            "description": "<p>The last timestamp, the format is 2015-10-11T21:04:48.000Z.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The results.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"timestamp\": \"2015-10-11T21:04:48.000Z\",\n     \"products\": [\n         1,\n         2\n     ]\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsDeletedTimestamp"
  },
  {
    "type": "get",
    "url": "/api/products/deleted/:timestamp",
    "title": "Request all inactive product ids which have been modified after the timestamp",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "timestamp",
            "description": "<p>The last timestamp, the format is 2015-10-11T21:04:48.000Z.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The results.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"timestamp\": \"2015-10-11T21:04:48.000Z\",\n     \"products\": [\n         1,\n         2\n     ]\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsDeletedTimestamp"
  },
  {
    "type": "get",
    "url": "/api/products/:id",
    "title": "Request a product by id which must be active",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"id\": 870,\n     \"title\": \"SAC À BANDOULIÈRE LILY TWIST EN VISON ET AYERS \",\n     \"brandId\": 5,\n     \"surname\": null,\n     \"keywords\": null,\n     \"brandLabel\": \"DOLCE & GABBANA\",\n     \"reference\": \"BB5948A8710\",\n     \"descriptions\":\"<ul><li>Sac avec bandoulière réglable et amovible</li></ul>\",\n     \"likeNumber\": 0,\n     \"prices\": [\n         {\n             \"country\": \"法国\",\n             \"offocialUrl\": \"http://awefaweff\",\n             \"price\": 1450\n         }\n     ],\n     \"images\": [\n             \"http://cdn.yoox.biz/55/55011908QN_13_F.jpg\",\n             \"http://cdn.yoox.biz/55/55011908QN_13_R.jpg\",\n             \"http://cdn.yoox.biz/55/55011908QN_13_E.jpg\",\n             \"http://cdn.yoox.biz/55/55011908QN_13_D.jpg\"\n     ]\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products-standby.js",
    "groupTitle": "Products",
    "name": "GetApiProductsId"
  },
  {
    "type": "get",
    "url": "/api/products/:id/comments/:number/:commentId",
    "title": "Request n product comments created before the comment specified by the commentId, The parentUsername and parentComment are null is parentComment is deleted, parentMatricule is always present.",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of comments to fetch.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The comment to compare to, use 0 if not specified.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"id\": 2,\n         \"username\": \"Jime\",\n         \"matricule\": 123455,\n         \"comment\": \"comment content1\",\n         \"parentUsername\": null,\n         \"parentMatricule\": null,\n         \"parentComment\": null,\n         \"canDelete\": 1\n     },\n     {\n         \"id\": 3,\n         \"username\": \"Mike\",\n         \"matricule\": 12,\n         \"comment\": \"comment content2\",\n         \"parentUsername\": \"Li Lei\",\n         \"parentMatricule\": 9988,\n         \"parentComment\": \"comment content0\",\n         \"canDelete\": 0\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsIdCommentsNumberCommentid"
  },
  {
    "type": "get",
    "url": "/api/products/:id/comments/:number/:commentId",
    "title": "Request n product comments created before the comment specified by the commentId, The parentUsername and parentComment are null is parentComment is deleted, parentMatricule is always present.",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The news id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "number",
            "description": "<p>The number of comments to fetch.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The comment to compare to, use 0 if not specified.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"id\": 2,\n         \"username\": \"Jime\",\n         \"matricule\": 123455,\n         \"comment\": \"comment content1\",\n         \"parentUsername\": null,\n         \"parentMatricule\": null,\n         \"parentComment\": null,\n         \"canDelete\": 1\n     },\n     {\n         \"id\": 3,\n         \"username\": \"Mike\",\n         \"matricule\": 12,\n         \"comment\": \"comment content2\",\n         \"parentUsername\": \"Li Lei\",\n         \"parentMatricule\": 9988,\n         \"parentComment\": \"comment content0\",\n         \"canDelete\": 0\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsIdCommentsNumberCommentid"
  },
  {
    "type": "get",
    "url": "/api/products/:id/extra",
    "title": "Request extra information of a specified product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"likeNumber\": 10,\n     \"isFavorite\": true\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products-standby.js",
    "groupTitle": "Products",
    "name": "GetApiProductsIdExtra"
  },
  {
    "type": "get",
    "url": "/api/products/:id/extra",
    "title": "Request extra information of a specified product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"likeNumber\": 10,\n     \"isFavorite\": 1,\n     \"isLiked\": 1,\n     \"commentNumber\": 5\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsIdExtra"
  },
  {
    "type": "get",
    "url": "/api/products/:id/extra",
    "title": "Request extra information of a specified product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The extra object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"likeNumber\": 10,\n     \"isFavorite\": 1,\n     \"isLiked\": 1,\n     \"commentNumber\": 5\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsIdExtra"
  },
  {
    "type": "get",
    "url": "/api/products/:id/translation",
    "title": "Fetch the translation of a specified product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"descriptions\": \"逗你玩儿\"\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products-standby.js",
    "groupTitle": "Products",
    "name": "GetApiProductsIdTranslation"
  },
  {
    "type": "get",
    "url": "/api/products/:id/translation",
    "title": "Fetch the translation of a specified product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"descriptions\": \"????\"\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsIdTranslation"
  },
  {
    "type": "get",
    "url": "/api/products/:id/translation",
    "title": "Fetch the translation of a specified product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"descriptions\": \"????\"\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsIdTranslation"
  },
  {
    "type": "get",
    "url": "/api/products/:timestamp",
    "title": "Request all active prodocuts which have been modified after the timestamp",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "timestamp",
            "description": "<p>The last timestamp.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The results.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{[\n     timestamp: 12434234234\n     \"products\": {\n         \"id\": 870,\n         \"title\": \"SAC À BANDOULIÈRE LILY TWIST EN VISON ET AYERS \",\n         \"brandId\": 5,\n         \"surname\": null,\n         \"keywords\": null,\n         \"brandLabel\": \"DOLCE & GABBANA\",\n         \"isTranslated\":true,\n         \"reference\": \"BB5948A8710\",\n         \"descriptions\":\"<ul><li>Sac avec bandoulière réglable et amovible</li></ul>\",\n         \"likeNumber\": 0,\n         \"order\": 0,\n         \"prices\": [\n             {\n                 \"country\": \"法国\",\n                 \"officialUrl\": \"http://afiwef\",\n                 \"price\": 1450\n             }\n         ],\n         \"images\": [\n                 \"http://cdn.yoox.biz/55/55011908QN_13_F.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_R.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_E.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_D.jpg\"\n         ]\n     }\n   ]}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products-standby.js",
    "groupTitle": "Products",
    "name": "GetApiProductsTimestamp"
  },
  {
    "type": "get",
    "url": "/api/products/:timestamp",
    "title": "Request all active product ids which have been modified or created after the timestamp",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "timestamp",
            "description": "<p>The last timestamp, the format is 2015-10-11T21:04:48.000Z.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The results.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"timestamp\": \"2015-10-11T21:04:48.000Z\",\n     \"products\": [\n         1,\n         2\n     ]\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsTimestamp"
  },
  {
    "type": "get",
    "url": "/api/products/:timestamp",
    "title": "Request all active product ids which have been modified or created after the timestamp",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "timestamp",
            "description": "<p>The last timestamp, the format is 2015-10-11T21:04:48.000Z.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The results.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"timestamp\": \"2015-10-11T21:04:48.000Z\",\n     \"products\": [\n         1,\n         2\n     ]\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "GetApiProductsTimestamp"
  },
  {
    "type": "post",
    "url": "/api/products",
    "title": "Request a collection of products which must be active",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "ids",
            "description": "<p>The product id list.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\n         \"id\": 870,\n         \"sku\": \"sdfawf\",\n         \"title\": \"SAC � BANDOULI�RE LILY TWIST EN VISON ET AYERS \",\n         \"brandId\": 5,\n         \"surname\": null,\n         \"keywords\": null,\n         \"brandLabel\": \"DOLCE & GABBANA\",\n         \"isTranslated\":true,\n         \"reference\": \"BB5948A8710\",\n         \"dimension\": \"20 X 30 X 50\",\n         \"descriptions\":\"<ul><li>Sac avec bandouli�re r�glable et amovible</li></ul>\",\n         \"likeNumber\": 0,\n         \"categories\": \"|1|2|\",\n         \"order\": 0,\n         \"prices\": [\n             {\n                 \"country\": \"??\",\n                 \"currency\": \"CNY\",\n                 \"officialUrl\": \"http://sdfa\",\n                 \"price\": 1450\n             }\n         ],\n         \"images\": [\n                 \"http://cdn.yoox.biz/55/55011908QN_13_F.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_R.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_E.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_D.jpg\"\n         ]\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "PostApiProducts"
  },
  {
    "type": "post",
    "url": "/api/products",
    "title": "Request a collection of products which must be active",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "ids",
            "description": "<p>The product id list.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\n         \"id\": 870,\n         \"sku\": \"sdfawf\",\n         \"title\": \"SAC � BANDOULI�RE LILY TWIST EN VISON ET AYERS \",\n         \"brandId\": 5,\n         \"surname\": null,\n         \"keywords\": null,\n         \"brandLabel\": \"DOLCE & GABBANA\",\n         \"isTranslated\":true,\n         \"reference\": \"BB5948A8710\",\n         \"dimension\": \"20 X 30 X 50\",\n         \"descriptions\":\"<ul><li>Sac avec bandouli�re r�glable et amovible</li></ul>\",\n         \"likeNumber\": 0,\n         \"categories\": \"|1|2|\",\n         \"order\": 0,\n         \"prices\": [\n             {\n                 \"country\": \"??\",\n                 \"currency\": \"CNY\",\n                 \"officialUrl\": \"http://sdfa\",\n                 \"price\": 1450\n             }\n         ],\n         \"images\": [\n                 \"http://cdn.yoox.biz/55/55011908QN_13_F.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_R.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_E.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_D.jpg\"\n         ]\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad request\",\n   \"data\":[\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "PostApiProducts"
  },
  {
    "type": "post",
    "url": "/api/products/:id/like",
    "title": "Like a product deprecated",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": 10\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "PostApiProductsIdLike"
  },
  {
    "type": "post",
    "url": "/api/products/:id/like",
    "title": "Like a product deprecated",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": 10\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "PostApiProductsIdLike"
  },
  {
    "type": "post",
    "url": "/api/products/:id/like",
    "title": "Like a product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": 10\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products-standby.js",
    "groupTitle": "Products",
    "name": "PostApiProductsIdLike"
  },
  {
    "type": "post",
    "url": "/api/secure/products/:id/comments/:commentId",
    "title": "Create a comment against a product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The parent comment id, use 0 if not specified.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "comment",
            "description": "<p>The comment content.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"id\": 13\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "PostApiSecureProductsIdCommentsCommentid"
  },
  {
    "type": "post",
    "url": "/api/secure/products/:id/comments/:commentId",
    "title": "Create a comment against a product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The discount id.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "commentId",
            "description": "<p>The parent comment id, use 0 if not specified.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "comment",
            "description": "<p>The comment content.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": {\n     \"id\": 13\n   }\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad Request.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "PostApiSecureProductsIdCommentsCommentid"
  },
  {
    "type": "post",
    "url": "/api/secure/products/:id/like",
    "title": "Like a product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": 10\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/products.js",
    "groupTitle": "Products",
    "name": "PostApiSecureProductsIdLike"
  },
  {
    "type": "post",
    "url": "/api/secure/products/:id/like",
    "title": "Like a product",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Products\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Products",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The product id.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>Possible values: +, -.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The product.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": 10\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "404",
            "description": "<p>The resource does not exist.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[\n         \"not_found\"\n   ]\n}\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/products.js",
    "groupTitle": "Products",
    "name": "PostApiSecureProductsIdLike"
  },
  {
    "type": "get",
    "url": "/api/regions",
    "title": "Request all regions",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Regions\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Regions",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Array",
            "optional": false,
            "field": "data",
            "description": "<p>the region list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\n         code: \"CN\",\n         currency: \"CNY\"\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/regions.js",
    "groupTitle": "Regions",
    "name": "GetApiRegions"
  },
  {
    "type": "get",
    "url": "/api/regions",
    "title": "Request all regions",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Regions\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Regions",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Array",
            "optional": false,
            "field": "data",
            "description": "<p>the region list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\n         code: \"CN\",\n         currency: \"CNY\"\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/regions.js",
    "groupTitle": "Regions",
    "name": "GetApiRegions"
  },
  {
    "type": "post",
    "url": "/api/search",
    "title": "Search against a query",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Search\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Search",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "query",
            "description": "<p>The query</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "brandId",
            "description": "<p>The brand id ex: 1</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "category",
            "description": "<p>The category id ex: |12|</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "page",
            "description": "<p>The page number, from 0</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "size",
            "description": "<p>The page size</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The results.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"id\": 870,\n         \"sku\": \"sdfawf\",\n         \"title\": \"SAC � BANDOULI�RE LILY TWIST EN VISON ET AYERS \",\n         \"brandId\": 5,\n         \"surname\": null,\n         \"keywords\": null,\n         \"brandLabel\": \"DOLCE & GABBANA\",\n         \"isTranslated\":true,\n         \"reference\": \"BB5948A8710\",\n         \"dimension\": \"20 X 30 X 50\",\n         \"descriptions\":\"<ul><li>Sac avec bandouli�re r�glable et amovible</li></ul>\",\n         \"likeNumber\": 0,\n         \"categories\": \"|1|2|\",\n         \"order\": 0,\n         \"prices\": [\n             {\n                 \"country\": \"??\",\n                 \"currency\": \"CNY\",\n                 \"officialUrl\": \"http://sdfa\",\n                 \"price\": 1450\n             }\n         ],\n         \"images\": [\n                 \"http://cdn.yoox.biz/55/55011908QN_13_F.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_R.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_E.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_D.jpg\"\n         ]\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/search.js",
    "groupTitle": "Search",
    "name": "PostApiSearch"
  },
  {
    "type": "post",
    "url": "/api/search",
    "title": "Search against a query",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Search\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Search",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "query",
            "description": "<p>The query</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "brandId",
            "description": "<p>The brand id ex: 1</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "category",
            "description": "<p>The category id ex: |12|</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "page",
            "description": "<p>The page number, from 0</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "size",
            "description": "<p>The page size</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>The results.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"id\": 870,\n         \"sku\": \"sdfawf\",\n         \"title\": \"SAC � BANDOULI�RE LILY TWIST EN VISON ET AYERS \",\n         \"brandId\": 5,\n         \"surname\": null,\n         \"keywords\": null,\n         \"brandLabel\": \"DOLCE & GABBANA\",\n         \"isTranslated\":true,\n         \"reference\": \"BB5948A8710\",\n         \"dimension\": \"20 X 30 X 50\",\n         \"descriptions\":\"<ul><li>Sac avec bandouli�re r�glable et amovible</li></ul>\",\n         \"likeNumber\": 0,\n         \"categories\": \"|1|2|\",\n         \"order\": 0,\n         \"prices\": [\n             {\n                 \"country\": \"??\",\n                 \"currency\": \"CNY\",\n                 \"officialUrl\": \"http://sdfa\",\n                 \"price\": 1450\n             }\n         ],\n         \"images\": [\n                 \"http://cdn.yoox.biz/55/55011908QN_13_F.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_R.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_E.jpg\",\n                 \"http://cdn.yoox.biz/55/55011908QN_13_D.jpg\"\n         ]\n     }\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/search.js",
    "groupTitle": "Search",
    "name": "PostApiSearch"
  },
  {
    "type": "get",
    "url": "/api/stores",
    "title": "Request all stores",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Stores\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Stores",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>the timestamp and store list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":{\n\t\t\t \"timestamp\": 1454075088319,\n\t\t\t \"stores\":[\n         \t{\n             id: 1,\n             title: \"title\",\n             division: \"division\",\n             address: \"address\",\n             zipcode: \"zipcode\",\n             city: \"city\",\n             country: \"country\",\n             phoneNumber: \"phoneNumber\",\n             longitude: 2.452452,\n             latitude: 40.98342,\n             brandId: 3\n         }\n        ]\n\t\t  }\n    }",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/stores.js",
    "groupTitle": "Stores",
    "name": "GetApiStores"
  },
  {
    "type": "get",
    "url": "/api/stores",
    "title": "Request all stores",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Stores\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Stores",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>the timestamp and store list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":{\n\t\t\t \"timestamp\": 1454075088319,\n\t\t\t \"stores\":[\n         \t{\n             id: 1,\n             title: \"title\",\n             division: \"division\",\n             address: \"address\",\n             zipcode: \"zipcode\",\n             city: \"city\",\n             country: \"country\",\n             phoneNumber: \"phoneNumber\",\n             longitude: 2.452452,\n             latitude: 40.98342,\n             brandId: 3\n         }\n        ]\n\t\t  }\n    }",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/stores.js",
    "groupTitle": "Stores",
    "name": "GetApiStores"
  },
  {
    "type": "get",
    "url": "/api/stores/timestamp",
    "title": "Request all stores modified after the timestamp",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Stores\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Stores",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>the timestamp and store list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":{\n\t\t\t \"timestamp\": 1454075088319,\n\t\t\t \"stores\":[\n         \t{\n             id: 1,\n             title: \"title\",\n             division: \"division\",\n             address: \"address\",\n             zipcode: \"zipcode\",\n             city: \"city\",\n             country: \"country\",\n             phoneNumber: \"phoneNumber\",\n             longitude: 2.452452,\n             latitude: 40.98342,\n             brandId: 3\n         }\n        ]\n\t\t  }\n    }",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/stores.js",
    "groupTitle": "Stores",
    "name": "GetApiStoresTimestamp"
  },
  {
    "type": "get",
    "url": "/api/stores/timestamp",
    "title": "Request all stores modified after the timestamp",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Stores\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Stores",
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>the timestamp and store list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "    HTTP/1.1 200 OK\n    {\n       \"message\":\"OK\",\n       \"data\":{\n\t\t\t \"timestamp\": 1454075088319,\n\t\t\t \"stores\":[\n         \t{\n             id: 1,\n             title: \"title\",\n             division: \"division\",\n             address: \"address\",\n             zipcode: \"zipcode\",\n             city: \"city\",\n             country: \"country\",\n             phoneNumber: \"phoneNumber\",\n             longitude: 2.452452,\n             latitude: 40.98342,\n             brandId: 3\n         }\n        ]\n\t\t  }\n    }",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/stores.js",
    "groupTitle": "Stores",
    "name": "GetApiStoresTimestamp"
  },
  {
    "type": "post",
    "url": "/api/secure/user/email",
    "title": "Modify the email",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"UserEmail\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "User",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>The login.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/users.js",
    "groupTitle": "User",
    "name": "PostApiSecureUserEmail"
  },
  {
    "type": "post",
    "url": "/api/secure/user/email",
    "title": "Modify the email",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"UserEmail\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "User",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "email",
            "description": "<p>The login.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/users.js",
    "groupTitle": "User",
    "name": "PostApiSecureUserEmail"
  },
  {
    "type": "post",
    "url": "/api/secure/user/info",
    "title": "Modify user info, only one field can be modified at once",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"UserInfo\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "User",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "field",
            "description": "<p>The field to change, possible values: &quot;gender&quot;, &quot;username&quot;, &quot;region&quot;.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "value",
            "description": "<p>The new value.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/users.js",
    "groupTitle": "User",
    "name": "PostApiSecureUserInfo"
  },
  {
    "type": "post",
    "url": "/api/secure/user/info",
    "title": "Modify user info, only one field can be modified at once",
    "header": {
      "fields": {
        "Header": [
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "apiKey",
            "description": "<p>The app access key</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "api",
            "description": "<p>The name of api</p>"
          },
          {
            "group": "Header",
            "type": "String",
            "optional": false,
            "field": "authorization",
            "description": "<p>The user token, null or &quot;&quot; if not exist</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Header-Example:",
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"UserInfo\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "User",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "field",
            "description": "<p>The field to change, possible values: &quot;gender&quot;, &quot;username&quot;, &quot;region&quot;.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "value",
            "description": "<p>The new value.</p>"
          }
        ]
      }
    },
    "success": {
      "fields": {
        "Success 200": [
          {
            "group": "Success 200",
            "type": "String",
            "optional": false,
            "field": "message",
            "description": "<p>Server message.</p>"
          },
          {
            "group": "Success 200",
            "type": "Object",
            "optional": false,
            "field": "data",
            "description": "<p>Empty object.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n}",
          "type": "json"
        }
      ]
    },
    "error": {
      "fields": {
        "Error 4xx": [
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "500",
            "description": "<p>Server error.</p>"
          },
          {
            "group": "Error 4xx",
            "optional": false,
            "field": "400",
            "description": "<p>Bad request.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Error-Response:",
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v2/users.js",
    "groupTitle": "User",
    "name": "PostApiSecureUserInfo"
  }
] });
