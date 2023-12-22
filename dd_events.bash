#!/bin/bash

# Curl command
curl -X GET "https://api.datadoghq.com/api/v2/events" \
-H "Accept: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}"
