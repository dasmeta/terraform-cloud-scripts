#!/bin/bash


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


#echo -e $WORKSPACE_DATA_VALID | jq ".data.attributes.name = workspace"

data=$(echo $WORKSPACE_DATA | jq --arg workspace_name "${WORKSPACE_NAME}" '.data.attributes.name = $workspace_name')

curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data "${data}" \
  https://app.terraform.io/api/v2/organizations/$ORG_NAME/workspaces
