#!/bin/bash

if [ -z "${1}" ]; then
  echo "Usage: $0 <path_to_content_directory> <organization>/<workspace>"
  exit 0
fi

ORG_NAME="$(cut -d'/' -f1 <<<"$1")"
WORKSPACE_NAME="$(cut -d'/' -f2 <<<"$1")"

http_code=$(curl -s -o /dev/null -w "%{http_code}" \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/${ORG_NAME}/workspaces/${WORKSPACE_NAME})

if [ ${http_code} -eq "404" ]; then
    echo "workspace not found"
else
    echo "workspace found"
fi