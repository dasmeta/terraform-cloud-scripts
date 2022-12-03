#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ -z "${1}" ]; then
  echo "Usage: $0 <path_to_content_directory> <organization>/<workspace>"
  exit 0
fi

ORG_NAME="$(cut -d'/' -f1 <<<"$1")"
WORKSPACE_NAME="$(cut -d'/' -f2 <<<"$1")"

WORKSPACE_DATA='{
                  "data": {
                    "attributes": {
                      "name": "${WORKSPACE_NAME}",
                      "resource-count": 0,
                      "updated-at": "2017-11-29T19:18:09.976Z"
                    },
                    "type": "workspaces"
                  }
                }'

data=$(echo $WORKSPACE_DATA | jq --arg workspace_name "${WORKSPACE_NAME}" '.data.attributes.name = $workspace_name')

http_code_workspace=`curl -s -o /dev/null -w "%{http_code}" \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data "${data}" \
  https://app.terraform.io/api/v2/organizations/$ORG_NAME/workspaces`


if [ $? -eq 0 ]; then
  echo -e "${GREEN}[ OK ]${NC} Workspace ${WORKSPACE_NAME} created"
fi
