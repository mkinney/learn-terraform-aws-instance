#!/bin/bash

# Curl command
curl -X POST "https://api.datadoghq.com/api/v1/events" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-d @- << EOF
{
  "title": "Example-Event",
  "text": "A text message.",
  "tags": [
    "test:ExampleEvent"
  ]
}
EOF

