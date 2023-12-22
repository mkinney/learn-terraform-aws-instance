#!/bin/bash

# Path parameters
export event_id="$1"
echo "checking event:${event_id}"
# Curl command
curl -X GET "https://api.datadoghq.com/api/v1/events/${event_id}" \
-H "Accept: application/json" \
-H "DD-API-KEY: ${DD_API_KEY}" \
-H "DD-APPLICATION-KEY: ${DD_APP_KEY}"
