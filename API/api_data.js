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
            "description": "<p>Possible values: iOS, Android, Web</p>"
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
    "filename": "routes/v2/authentication.js",
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
    "filename": "routes/v1/authentication.js",
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
    "filename": "routes/v2/authentication.js",
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
    "filename": "routes/v1/authentication.js",
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"Login succeeded\",\n   \"data\":{\n             \"id\": user.userId,\n             \"token\":\"asdfa\",\n             \"username\": \"sfwef\",\n             \"profileUrl\": \"url\",\n             \"gender\": \"1\",\n             \"matricule\": 666666,\n             \"membershipExpireDate\": user.membershipExpireDate,\n             \"roleCode\":\"dffe\",\n             \"region\":\"中国\",\n             \"badges\": [{\n                 \"id\": 1,\n                 \"type\": \"Sales\",\n                 \"content\": \"老佛爷1楼\"\n             }],\n             \"totalImgCount\": user.totalImgCount,\n             \"totalArticleCount\": user.totalArticleCount,\n             \"totalInvitationCount\": user.totalInvitationCount,\n             \"points\": 0,\n             \"thirds\": [\n                 {\n                     \"type\": \"google\",\n                     \"username\": \"Jiyun YANG\",\n                     \"profileUrl\": \"profileUrl\"\n                 },\n                 {\n                     \"type\": \"qq\",\n                     \"username\": \"Jiyun\",\n                     \"profileUrl\": \"profileUrl\"\n                 }\n             ]\n          }\n}",
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
    "filename": "routes/admin/authentication.js",
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"Login succeeded\",\n   \"data\":{\n             \"id\": user.userId,\n             \"token\":\"asdfa\",\n             \"username\": \"sfwef\",\n             \"profileUrl\": \"url\",\n             \"gender\": \"1\",\n             \"matricule\": 666666,\n             \"membershipExpireDate\": user.membershipExpireDate,\n             \"roleCode\":\"dffe\",\n             \"region\":\"中国\",\n             \"badges\": [{\n                 \"id\": 1,\n                 \"type\": \"Sales\",\n                 \"content\": \"老佛爷1楼\"\n             }],\n             \"language\": [{\n                 \"order\": 1,\n                 \"code\": \"zh\"\n             }],\n             \"totalImgCount\": user.totalImgCount,\n             \"totalArticleCount\": user.totalArticleCount,\n             \"totalInvitationCount\": user.totalInvitationCount,\n             \"points\": 0,\n             \"isGDPRAccepted\": true,\n             \"isAvailableInSearchResult\": true,\n             \"thirds\": [\n                 {\n                     \"type\": \"google\",\n                     \"username\": \"Jiyun YANG\",\n                     \"profileUrl\": \"profileUrl\"\n                 },\n                 {\n                     \"type\": \"qq\",\n                     \"username\": \"Jiyun\",\n                     \"profileUrl\": \"profileUrl\"\n                 }\n             ]\n          }\n}",
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
    "filename": "routes/v2/authentication.js",
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
    "filename": "routes/admin/authentication.js",
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
    "filename": "routes/v1/authentication.js",
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
    "filename": "routes/v1/authentication.js",
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
    "filename": "routes/v2/authentication.js",
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
    "filename": "routes/v2/authentication.js",
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
    "filename": "routes/v1/authentication.js",
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
    "filename": "routes/v2/authentication.js",
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
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "profileUrl",
            "description": "<p>the profileUrl</p>"
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n          \"id\": user.userId,\n          \"token\": \"162f97cd1a0176eade5f54aa\",\n          \"username\": \"hh\",\n          \"profileUrl\": \"url\",\n          \"gender\": \"0\",\n          \"matricule\": 100074,\n          \"membershipExpireDate\": user.membershipExpireDate,\n          \"roleCode\": \"Basic\",\n          \"region\": null,\n          \"badges\": [{\n              \"id\": 1,\n              \"type\": \"Sales\",\n              \"content\": \"老佛爷1楼\"\n           }],\n          \"language\": [{\n              \"order\": 1,\n              \"code\": \"zh\"\n           }],\n          \"totalImgCount\": user.totalImgCount,\n          \"totalArticleCount\": user.totalArticleCount,\n          \"totalInvitationCount\": user.totalInvitationCount,\n          \"points\": 0,\n          \"isGDPRAccepted\": true,\n          \"isAvailableInSearchResult\": true,\n          \"thirds\": [\n              {\n                  \"type\": \"google\",\n                  \"username\": \"Jiyun YANG\",\n                  \"profileUrl\": \"profileUrl\"\n              },\n              {\n                     \"type\": \"qq\",\n                     \"username\": \"Jiyun\",\n                     \"profileUrl\": \"profileUrl\"\n              }\n          ]\n   }\n}",
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
    "type": "delete",
    "url": "/secure/circle/:circleId",
    "title": "Remove a circle",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Circle\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Circle",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "id.",
            "description": ""
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
            "description": "<p>result.</p>"
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
    "filename": "routes/v1/circle.js",
    "groupTitle": "Circle",
    "name": "DeleteSecureCircleCircleid"
  },
  {
    "type": "delete",
    "url": "/secure/circle/:id/comments/:commentId",
    "title": "deletes a comment",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Circle\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Circle",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "id",
            "description": "<p>The circle id</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "commentId",
            "description": "<p>The comment id</p>"
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n         {\n             \"id\": \"5a4ac4e463417f46940378c6\",\n             \"username\": \"CocoaBob\",\n             \"userProfileUrl\": \"https://soyou.s3.eu-west-1.amazonaws.com/users/test/100002/profile.jpg\",\n             \"createdDate\": \"2018-01-01T23:31:48.934Z\",\n             \"parentUsername\": null\n         },\n         {\n             \"id\": \"5a4ac4f963417f46940378c7\",\n             \"username\": \"CocoaBob\",\n             \"userProfileUrl\": \"https://soyou.s3.eu-west-1.amazonaws.com/users/test/100002/profile.jpg\",\n             \"createdDate\": \"2018-01-01T23:32:09.983Z\",\n             \"parentUsername\": null\n         }\n     ]\n}",
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
    "filename": "routes/v1/circle.js",
    "groupTitle": "Circle",
    "name": "DeleteSecureCircleIdCommentsCommentid"
  },
  {
    "type": "get",
    "url": "/secure/circle/:userId/count/:timestamp",
    "title": "Return the number of circle events newer than timestamp",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Circle\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Circle",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "userId",
            "description": "<p>The friend's userId.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "timestamp",
            "description": "<p>The time ex: 2017-10-23T21:25:23.000Z.</p>"
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
            "description": "<p>The Circle list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\": 10\n}",
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
    "filename": "routes/v1/circle.js",
    "groupTitle": "Circle",
    "name": "GetSecureCircleUseridCountTimestamp"
  },
  {
    "type": "get",
    "url": "/secure/circle/:userId/next/:timestamp",
    "title": "Request 10 circle events newer than timestamp of the specified user",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Circle\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Circle",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "userId",
            "description": "<p>The friend's userId.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "timestamp",
            "description": "<p>The time ex: 2017-10-23T21:25:23.000Z.</p>"
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
            "description": "<p>The Circle list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\": \"5a440e50919a55000ddbe485\",\n             \"text\": \"为什么我光发网图 不发实物图？现在店里人山人海 我怎么拍啊 拍了不好看啊只要你下单，打钱 我去买，结账图绝对私信给你！\",\n             \"images\": [\n                 \"https://s3-eu-west-1.amazonaws.com/soyou/news/1-1.jpg\",\n                 \"https://s3-eu-west-1.amazonaws.com/soyou/news/1-2.jpg\"\n             ],\n             \"userId\": 1,\n             \"username\": \"CocoaBob\",\n             \"userBadges\": [{\n                 \"id\": 1,\n                 \"type\": \"Buyer\"\n             }],\n             \"createdDate\": \"2017-10-22T21:25:23.000Z\",\n             \"visibility\": 4,\n             \"userProfileUrl\": \"https://soyou.s3.eu-west-1.amazonaws.com/users/test/100001/profile.png\",\n             \"commentCount\": 0,\n             \"likes\": {\n                        userId: id,\n                        username: username,\n                        userProfileUrl: profileUrl,\n                        createdDate: createdDate\n              },\n             \"isFollowedByCurrentUser\": true\n         }\n    ]\n}",
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
    "filename": "routes/v1/circle.js",
    "groupTitle": "Circle",
    "name": "GetSecureCircleUseridNextTimestamp"
  },
  {
    "type": "get",
    "url": "/secure/circle/:userId/previous/:timestamp",
    "title": "Request 10 circle events older than timestamp of the specified user",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Circle\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Circle",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "userId",
            "description": "<p>The userId.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "timestamp",
            "description": "<p>The time ex: 2017-10-23T21:25:23.000Z.</p>"
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
            "description": "<p>The Circle list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\": \"5a440e50919a55000ddbe485\",\n             \"text\": \"为什么我光发网图 不发实物图？现在店里人山人海 我怎么拍啊 拍了不好看啊只要你下单，打钱 我去买，结账图绝对私信给你！\",\n             \"images\": [\n                 \"https://s3-eu-west-1.amazonaws.com/soyou/news/1-1.jpg\",\n                 \"https://s3-eu-west-1.amazonaws.com/soyou/news/1-2.jpg\"\n             ],\n             \"userId\": 1,\n             \"username\": \"CocoaBob\",\n             \"userBadges\": [{\n                 \"id\": 1,\n                 \"type\": \"Buyer\"\n             }],\n             \"createdDate\": \"2017-10-22T21:25:23.000Z\",\n             \"visibility\": 4,\n             \"userProfileUrl\": \"https://soyou.s3.eu-west-1.amazonaws.com/users/test/100001/profile.png\",\n             \"commentCount\": 0,\n             \"likes\": {\n                        userId: id,\n                        username: username,\n                        userProfileUrl: profileUrl,\n                        createdDate: createdDate\n              },\n             \"isFollowedByCurrentUser\": true\n         }\n    ]\n}",
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
    "filename": "routes/v1/circle.js",
    "groupTitle": "Circle",
    "name": "GetSecureCircleUseridPreviousTimestamp"
  },
  {
    "type": "post",
    "url": "/secure/circle/",
    "title": "Create a circle event",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Circle\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Circle",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "text",
            "description": "<p>The text of the event.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "visibility",
            "description": "<p>The visibility of the event: 1: OnlyMe, 2: OnlyFriends, 3: All.</p>"
          },
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "tagUserIds",
            "description": "<p>The visible userIds</p>"
          },
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "forbiddenTagUserIds",
            "description": "<p>The not allowed userIds</p>"
          },
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "imgs",
            "description": "<p>The images max 9 images multipart/form-data.</p>"
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
    "filename": "routes/v1/circle.js",
    "groupTitle": "Circle",
    "name": "PostSecureCircle"
  },
  {
    "type": "post",
    "url": "/secure/circle/:id/comments/:parentUserId",
    "title": "Create a comment against a circle",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Circle\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Circle",
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
            "field": "parentUserId",
            "description": "<p>The parent user id, use 0 if not specified.</p>"
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n         \"username\": \"jiyuny\",\n         \"userProfileUrl\": \"https://soyou.s3.eu-west-1.amazonaws.com/users/test/100001/profile.jpg\",\n         \"createdDate\": \"2018-01-01T23:13:53.915Z\",\n         \"parentUsername\": null\n     },\n     {\n         \"username\": \"CocoaBob\",\n         \"userProfileUrl\": \"https://soyou.s3.eu-west-1.amazonaws.com/users/test/100002/profile.jpg\",\n         \"createdDate\": \"2018-01-01T23:18:26.285Z\",\n         \"parentUsername\": \"jiyuny\"\n     }\n    ]\n}",
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
    "filename": "routes/v1/circle.js",
    "groupTitle": "Circle",
    "name": "PostSecureCircleIdCommentsParentuserid"
  },
  {
    "type": "post",
    "url": "/secure/circle/:id/like",
    "title": "Like a circle",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Circle\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Circle",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The circle id.</p>"
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
            "description": "<p>The likers list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\": [\n     {\n          \"userId\": 1,\n          \"username\": \"jiyuny\",\n          \"userProfileUrl\": \"https://soyou.s3.eu-west-1.amazonaws.com/users/test/100001/profile.jpg\",\n          \"createdDate\": \"2018-01-01T22:29:04.353Z\"\n      },\n      {\n          \"userId\": 2,\n          \"username\": \"CocoaBob\",\n          \"userProfileUrl\": \"https://soyou.s3.eu-west-1.amazonaws.com/users/test/100002/profile.jpg\",\n          \"createdDate\": \"2018-01-01T22:41:56.718Z\"\n      }\n  ]\n}",
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
          "content": "HTTP/1.1 404 Not Found\n{\n   \"message\": \"Not Found\",\n   \"data\":[]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\n\nHTTP/1.1 400 Bad Request\n{\n   \"message\": \"Bad Request\",\n   \"data\":[\n         \"invalid_operation\"\n   ]\n}\n\nHTTP/1.1 500 Server Error\n{\n   \"message\": \"Server Error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/circle.js",
    "groupTitle": "Circle",
    "name": "PostSecureCircleIdLike"
  },
  {
    "type": "delete",
    "url": "/api/secure/crawls/:id",
    "title": "Remove a crawl url",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Crawls\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Crawls",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>the crawl url Id.</p>"
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
            "description": "<p>the timestamp and store list.</p>"
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
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/crawl.js",
    "groupTitle": "Crawls",
    "name": "DeleteApiSecureCrawlsId"
  },
  {
    "type": "get",
    "url": "/api/secure/crawls",
    "title": "Request current user's crawl urls",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Crawls\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Crawls",
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     \t{\n             id: 1,\n             label: \"label\",\n             url: \"division\"\n         }\n    ]\n}",
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
    "filename": "routes/v1/crawl.js",
    "groupTitle": "Crawls",
    "name": "GetApiSecureCrawls"
  },
  {
    "type": "get",
    "url": "/api/secure/crawls/suggestions",
    "title": "Request all suggested crawl urls",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Crawls\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Crawls",
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     \t{\n             id: 1,\n             label: \"label\",\n             url: \"https://fr.maje.com/\"\n         }\n    ]\n}",
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
    "filename": "routes/v1/crawl.js",
    "groupTitle": "Crawls",
    "name": "GetApiSecureCrawlsSuggestions"
  },
  {
    "type": "post",
    "url": "/api/secure/crawls",
    "title": "Create a crawl url",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Crawls\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Crawls",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "label",
            "description": "<p>the crawl label.</p>"
          },
          {
            "group": "Parameter",
            "type": "string",
            "optional": false,
            "field": "url",
            "description": "<p>the crawl url.</p>"
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
            "description": "<p>the timestamp and store list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     \t{\n             id: 1,\n             label: \"label\",\n             url: \"division\"\n         }\n    ]\n}",
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
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/crawl.js",
    "groupTitle": "Crawls",
    "name": "PostApiSecureCrawls"
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
    "filename": "routes/v1/discounts.js",
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
    "filename": "routes/v2/discounts.js",
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
    "filename": "routes/v1/discounts.js",
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
    "filename": "routes/v2/discounts.js",
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
    "filename": "routes/v1/discounts.js",
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
    "filename": "routes/v2/discounts.js",
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
    "filename": "routes/v1/discounts.js",
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
    "filename": "routes/v2/discounts.js",
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
    "filename": "routes/v2/discounts.js",
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
    "filename": "routes/v1/discounts.js",
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
    "filename": "routes/v1/discounts.js",
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
    "filename": "routes/v2/discounts.js",
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
    "filename": "routes/v2/discounts.js",
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
    "filename": "routes/v1/discounts.js",
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
    "filename": "routes/v1/favorites.js",
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
    "filename": "routes/v2/favorites.js",
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
    "filename": "routes/v2/favorites.js",
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
    "filename": "routes/v1/favorites.js",
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
    "filename": "routes/v2/favorites.js",
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
    "filename": "routes/v1/favorites.js",
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
    "filename": "routes/v2/favorites.js",
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
    "filename": "routes/v1/favorites.js",
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
    "filename": "routes/v2/favorites.js",
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
    "filename": "routes/v1/favorites.js",
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
    "type": "get",
    "url": "/secure/api/friends/followers",
    "title": "Get all followers",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Friends\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Friends",
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[{\n         userId: user.id,\n         gender: user.gender,\n         matricule:user.matricule,\n         username: user.username,\n         profileUrl: user.profileUrl,\n         badges: [{\n             id: 1,\n             type: 'Sales'\n         }]\n   }]",
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
    "filename": "routes/v1/friends.js",
    "groupTitle": "Friends",
    "name": "GetSecureApiFriendsFollowers"
  },
  {
    "type": "get",
    "url": "/secure/api/friends/following",
    "title": "Get all following",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Friends\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Friends",
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[{\n         userId: user.id,\n         gender: user.gender,\n         matricule:user.matricule,\n         username: user.username,\n         profileUrl: user.profileUrl,\n         badges: [{\n             id: 1,\n             type: 'Sales'\n         }]\n   }]",
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
    "filename": "routes/v1/friends.js",
    "groupTitle": "Friends",
    "name": "GetSecureApiFriendsFollowing"
  },
  {
    "type": "post",
    "url": "/secure/api/friends/follow/:userId",
    "title": "Follow a user by userId",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Friends\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Friends",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "userId",
            "description": "<p>The user to follow.</p>"
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     imUserId: imUserId\n   }",
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
    "filename": "routes/v1/friends.js",
    "groupTitle": "Friends",
    "name": "PostSecureApiFriendsFollowUserid"
  },
  {
    "type": "post",
    "url": "/secure/api/friends/unfollow/:userId",
    "title": "Unfollow a user by userId",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Friends\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Friends",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "userId",
            "description": "<p>The user to follow.</p>"
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}",
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
    "filename": "routes/v1/friends.js",
    "groupTitle": "Friends",
    "name": "PostSecureApiFriendsUnfollowUserid"
  },
  {
    "type": "get",
    "url": "/api/languages",
    "title": "Request all languages",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Languages\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Languages",
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
            "description": "<p>the language list.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\n         id: 1,\n         code: \"zh\",\n         label: \"中文\"\n     }\n   ]\n}",
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
    "filename": "routes/v1/languages.js",
    "groupTitle": "Languages",
    "name": "GetApiLanguages"
  },
  {
    "type": "get",
    "url": "/misc/check-list",
    "title": "Gets banned keywords list and allowed domain list",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Misc\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Misc",
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"bannedKeywords\": [\"微信\",\n         \"Vletter\",\n         \"微Letter\"\n     ],\n     \"allowedDomains\":[\n         \"soyou.io\"\n     ]\n}",
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
    "filename": "routes/v1/misc.js",
    "groupTitle": "Misc",
    "name": "GetMiscCheckList"
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":{\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"subtitle\":\"the subtitle\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"content\":\"abcde\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\",\n             \"publishDate\":\"2015-09-06T00:00:00.000Z\"\n          }\n}",
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
    "filename": "routes/v1/news.js",
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
    "filename": "routes/v2/news.js",
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
    "filename": "routes/v1/news.js",
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
    "filename": "routes/v2/news.js",
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
    "filename": "routes/v2/news.js",
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"subtitle\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"subtitle\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
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
    "filename": "routes/v2/news.js",
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"\",\n   \"data\":[\n         {\n             \"id\":1,\n             \"author\":\"一页\",\n             \"title\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"subtitle\":\"包包大科普 - Chanel 经典款Classic Flap 尺寸价格汇总\",\n             \"image\":\"http://www.geocities.ws/baodating/app/news/imgs/chanel_cf_all_size/cf_four_size.png\",\n             \"datePublication\":\"2015-09-06T00:00:00.000Z\",\n             \"dateModification\":\"2015-09-06T00:00:00.000Z\",\n             \"expireDate\":\"2015-09-06T00:00:00.000Z\"\n          }\n    ]\n}",
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
    "filename": "routes/v2/news.js",
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
    "filename": "routes/v1/news.js",
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
    "filename": "routes/v1/notification.js",
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
    "filename": "routes/v2/notification.js",
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
    "filename": "routes/v2/products.js",
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
    "filename": "routes/v1/products.js",
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
    "filename": "routes/v2/products.js",
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
    "filename": "routes/v1/products.js",
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
    "filename": "routes/v2/products.js",
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
    "type": "delete",
    "url": "/secure/tags/:id",
    "title": "Remove a tag of current user",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Tags\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Tags",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>the tag id</p>"
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n }",
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
    "filename": "routes/v1/tags.js",
    "groupTitle": "Tags",
    "name": "DeleteSecureTagsId"
  },
  {
    "type": "get",
    "url": "/secure/tags",
    "title": "List all tags of current user",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Tags\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Tags",
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\n         id: 1,\n         label: \"CNY\"\n     }\n   ]\n}",
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
    "filename": "routes/v1/tags.js",
    "groupTitle": "Tags",
    "name": "GetSecureTags"
  },
  {
    "type": "get",
    "url": "/secure/tags/:userId",
    "title": "List all tags containing the userId",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Tags\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Tags",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The tagId</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\n         id: 1,\n         lable: \"CNY\"\n     }\n   ]\n}",
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
    "filename": "routes/v1/tags.js",
    "groupTitle": "Tags",
    "name": "GetSecureTagsUserid"
  },
  {
    "type": "post",
    "url": "/secure/tags",
    "title": "Create or modify a tag's label",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Tags\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Tags",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "label",
            "description": "<p>The tag label</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The tagId, if present modifying an exist tag, creation otherwise</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n         id: 1,\n         label: \"CNY\"\n   }\n}",
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
    "filename": "routes/v1/tags.js",
    "groupTitle": "Tags",
    "name": "PostSecureTags"
  },
  {
    "type": "post",
    "url": "/secure/tags/:id/members",
    "title": "Add or remove members from a tag of the current user",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Tags\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Tags",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>the tag id</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>the operation: &quot;+&quot; or &quot;-&quot;</p>"
          },
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "userIds",
            "description": "<p>The userId list.</p>"
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n }",
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
    "filename": "routes/v1/tags.js",
    "groupTitle": "Tags",
    "name": "PostSecureTagsIdMembers"
  },
  {
    "type": "delete",
    "url": "/secure/teams/:id",
    "title": "Remove a team of current user",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Teams\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Teams",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>the team id</p>"
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n }",
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
    "filename": "routes/v1/teams.js",
    "groupTitle": "Teams",
    "name": "DeleteSecureTeamsId"
  },
  {
    "type": "delete",
    "url": "/secure/teams/:id/leave",
    "title": "Leave a team containing the current user",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Teams\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Teams",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>the team id</p>"
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n }",
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
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"invalid_operation\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/teams.js",
    "groupTitle": "Teams",
    "name": "DeleteSecureTeamsIdLeave"
  },
  {
    "type": "get",
    "url": "/secure/teams",
    "title": "List all teams of current user (as owner/admin/member)",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Teams\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Teams",
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[\n     {\n         id: 1,\n         label: \"My team\"\n     }\n   ]\n}",
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
    "filename": "routes/v1/teams.js",
    "groupTitle": "Teams",
    "name": "GetSecureTeams"
  },
  {
    "type": "get",
    "url": "/secure/teams/:id/members",
    "title": "Return all members of a team",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Teams\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Teams",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>the team id</p>"
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[{\n         userId: 1,\n         username: \"abc\",\n         profileUrl: \"url\",\n         role: \"1\"\n   }]\n }",
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
    "filename": "routes/v1/teams.js",
    "groupTitle": "Teams",
    "name": "GetSecureTeamsIdMembers"
  },
  {
    "type": "post",
    "url": "/secure/teams",
    "title": "Transfer a team's ownership",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Teams\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Teams",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "userId",
            "description": "<p>the new owner's id</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The teamId, if present modifying an exist team, creation otherwise</p>"
          }
        ]
      }
    },
    "success": {
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
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"forbidden\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/teams.js",
    "groupTitle": "Teams",
    "name": "PostSecureTeams"
  },
  {
    "type": "post",
    "url": "/secure/teams",
    "title": "Create or modify a team's label and isPublic (in public team, everyone can invite people)",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Teams\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Teams",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "label",
            "description": "<p>The team label</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The teamId, if present modifying an exist team, creation otherwise</p>"
          }
        ]
      }
    },
    "success": {
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n         id: 1,\n         label: \"My Team\"\n   }\n}",
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
    "filename": "routes/v1/teams.js",
    "groupTitle": "Teams",
    "name": "PostSecureTeams"
  },
  {
    "type": "post",
    "url": "/secure/teams/admin",
    "title": "Set a user as team admin or remove a user's admin role",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Teams\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Teams",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The teamId</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "userId",
            "description": "<p>The userId</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>the operation: &quot;+&quot; or &quot;-&quot;</p>"
          }
        ]
      }
    },
    "success": {
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
    "filename": "routes/v1/teams.js",
    "groupTitle": "Teams",
    "name": "PostSecureTeamsAdmin"
  },
  {
    "type": "post",
    "url": "/secure/teams/:id/members",
    "title": "Add or Remove members from a team of the current user",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"Teams\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "Teams",
    "parameter": {
      "fields": {
        "Parameter": [
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>the team id</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "operation",
            "description": "<p>the operation: &quot;+&quot; or &quot;-&quot;</p>"
          },
          {
            "group": "Parameter",
            "type": "Array",
            "optional": false,
            "field": "userIds",
            "description": "<p>The userId list.</p>"
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}\n }",
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
    "filename": "routes/v1/teams.js",
    "groupTitle": "Teams",
    "name": "PostSecureTeamsIdMembers"
  },
  {
    "type": "get",
    "url": "/api/secure/user/:id",
    "title": "Get user infomation",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"User\"\n\"authorization\": \"The token\"",
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
            "type": "Number",
            "optional": false,
            "field": "id",
            "description": "<p>The userId, userId can not be 0.</p>"
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"id\": userId,\n     \"token\": null,\n     \"username\": user.username,\n     \"profileUrl\": user.profileUrl,\n     \"gender\": user.gender,\n     \"matricule\":user.matricule,\n     \"membershipExpireDate\": user.membershipExpireDate,\n     \"roleCode\": code,\n     \"region\": null,\n     \"badges\": [{\n          \"id\": 1,\n          \"type\": \"Sales\",\n          \"content\": \"老佛爷1楼\"\n      }],\n     \"languages\": [{\n         \"id\": 1,\n         \"code\": CN\n     }]\n     \"totalImgCount\": 0,\n     \"totalArticleCount\": 0,\n     \"totalInvitationCount\": 0,\n     \"points\": 0,\n     \"isGDPRAccepted\": true,\n     \"isAvailableInSearchResult\": true,\n     \"thirds\": [\n         {\n             \"type\": \"google\",\n             \"username\": \"Jiyun YANG\",\n             \"profileUrl\": \"profileUrl\"\n         },\n        {\n             \"type\": \"qq\",\n             \"username\": \"Jiyun\",\n             \"profileUrl\": \"profileUrl\"\n        }\n     ]\n     },\n    \"blockStatus\": \"possible values are: 1: current user do not wanna see target user's circle, 2: current user do not want target user to see its circle, 3: both 1 and 2, 0: no blockStatus is specified \",\n    \"friendStatus\": \"possible values are: 1: current user is following target user, 2: target user is following current user, 3: both 1 and 2, 0: no friendship is specified \",\n    \"followingCount\": 1,\n    \"followerCount\": 2\n}",
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
    "name": "GetApiSecureUserId"
  },
  {
    "type": "get",
    "url": "/api/secure/user/recommendation",
    "title": "Randomly return N recommendated users, N = 9 for this moment",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"User\"\n\"authorization\": \"The token\"",
          "type": "String"
        }
      ]
    },
    "group": "User",
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
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"id\": userId,\n     \"username\": user.username,\n     \"profileUrl\": user.profileUrl,\n     \"gender\": user.gender,\n     \"matricule\": user.matricule,\n     \"badges\": [{\n          \"id\": 1,\n          \"type\": \"Sales\",\n          \"content\": \"老佛爷1楼\"\n      }]\n}",
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
    "name": "GetApiSecureUserRecommendation"
  },
  {
    "type": "post",
    "url": "/api/secure/user/accept-invitation",
    "title": "Accept a invitation",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"User\"\n\"authorization\": \"The token\"",
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
            "field": "invitationCode",
            "description": "<p>The invitationCode (the matricule of the invitor).</p>"
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
          "title": "Success-Response: Invitor user info",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{\n     \"id\": 1,\n     \"username\": \"username\",\n     \"profileUrl\": \"profileUrl\",\n     \"gender\": male,\n     \"region\": null\n   }\n}",
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
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Can only be invited once\",\n   \"data\": [\n         \"can_only_be_invited_once\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Not eligible to be invited, only new user can be invited\",\n   \"data\": [\n         \"not_eligible_to_be_invited\"\n   ]\n}\nHTTP/1.1 404 Bad request\n{\n   \"message\": \"Not found\",\n   \"data\": [\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/users.js",
    "groupTitle": "User",
    "name": "PostApiSecureUserAcceptInvitation"
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
    "url": "/api/secure/user/gdpr",
    "title": "Post the user decision of gdpr",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"User\"\n\"authorization\": \"The token\"",
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
            "type": "Boolean",
            "optional": false,
            "field": "value",
            "description": "<p>True or false</p>"
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
          "title": "Success-Response: empty result",
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
    "filename": "routes/v1/users.js",
    "groupTitle": "User",
    "name": "PostApiSecureUserGdpr"
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
            "description": "<p>The field to change, possible values: &quot;gender&quot;, &quot;username&quot;, &quot;region&quot;, &quot;isAvailableInSearchResult&quot;, &quot;languages&quot;</p>"
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
    "url": "/api/secure/user/link-user",
    "title": "Link a third account to an already exist user",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"User\"\n\"authorization\": \"The token\"",
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
            "field": "username",
            "description": "<p>the username</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "profileUrl",
            "description": "<p>the profileUrl</p>"
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
          "title": "Success-Response: empty result",
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
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"incorrect_third_token\"\n   ]\n}\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"already_linked_to_another_user\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/users.js",
    "groupTitle": "User",
    "name": "PostApiSecureUserLinkUser"
  },
  {
    "type": "post",
    "url": "/api/secure/user/profileImg",
    "title": "update user profile image",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"UserProfile\"\n\"authorization\": \"The token\"",
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
            "field": "avatar",
            "description": "<p>The the image file.</p>"
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
    "name": "PostApiSecureUserProfileimg"
  },
  {
    "type": "post",
    "url": "/api/secure/user/search",
    "title": "Search users by username or matricule",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"User\"\n\"authorization\": \"The token\"",
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
            "field": "query",
            "description": "<p>The suername or matricule.</p>"
          },
          {
            "group": "Parameter",
            "type": "String",
            "optional": false,
            "field": "codedQuery",
            "description": "<p>The coded suername or matricule.</p>"
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
            "description": "<p>List of users</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":[{\n     \"id\": 1,\n     \"gender\": 1,\n     \"matricule\": 100001,\n     \"username\": \"username\",\n     \"profileUrl\": \"profileUrl\",\n      badges: [{\n          id: 1,\n          type: 'Sales'\n      }]\n   }]\n}",
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
          "content": "HTTP/1.1 500 Server error\n{\n   \"message\": \"Server error\",\n   \"data\":[\n         \"server_error\"\n   ]\n}\n\nHTTP/1.1 400 Bad request\n{\n   \"message\": \"Bad request\",\n   \"data\": [\n         \"bad_request\"\n   ]\n}\nHTTP/1.1 404 Bad request\n{\n   \"message\": \"Not found\",\n   \"data\": [\n         \"not_found\"\n   ]\n}",
          "type": "json"
        }
      ]
    },
    "version": "0.0.0",
    "filename": "routes/v1/users.js",
    "groupTitle": "User",
    "name": "PostApiSecureUserSearch"
  },
  {
    "type": "post",
    "url": "/api/user/membership/:numberOfMonth",
    "title": "update activate user membership",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"UserMembership\"\n\"authorization\": \"The token\"",
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
            "type": "Number",
            "optional": false,
            "field": "numberOfMonth",
            "description": "<p>The number of month.</p>"
          },
          {
            "group": "Parameter",
            "type": "Boolean",
            "optional": false,
            "field": "activateProbation",
            "description": "<p>True if it is to activate the probation,false else.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
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
            "description": "<p>The result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{ membershipExpireDate: date }\n}",
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
    "name": "PostApiUserMembershipNumberofmonth"
  },
  {
    "type": "post",
    "url": "/secure/user/block/:userId/:blockStatus",
    "title": "Block or unblock a user for circle",
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
          "content": "\"apiKey\": \"17843599-f079-4c57-bb39-d9ca8344abd\"\n\"api\": \"User\"\n\"authorization\": \"The token\"",
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
            "type": "Number",
            "optional": false,
            "field": "userId",
            "description": "<p>The user to follow.</p>"
          },
          {
            "group": "Parameter",
            "type": "Number",
            "optional": false,
            "field": "blockStatus",
            "description": "<p>Possible values: 0: unblock; 1: current user do not wanna see userId's circle; 2: current user do not want userId to see current user's circle; 3: both 1 and 2</p>"
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
            "description": "<p>result.</p>"
          }
        ]
      },
      "examples": [
        {
          "title": "Success-Response:",
          "content": "HTTP/1.1 200 OK\n{\n   \"message\":\"OK\",\n   \"data\":{}",
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
    "name": "PostSecureUserBlockUseridBlockstatus"
  }
] });
