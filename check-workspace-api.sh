#!/bin/bash

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

if [ -z "${1}" ]; then
  echo "Usage: $0 <organization>/<workspace>"
  exit 0
fi

ORG_NAME="$(cut -d'/' -f1 <<<"$1")"
WORKSPACE_NAME="$(cut -d'/' -f2 <<<"$1")"

function checkOrg() {

  http_code_org=`curl -s -o /dev/null -w "%{http_code}"\
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request GET \
  https://app.terraform.io/api/v2/organizations/$1`

 if [ ${http_code_org} -eq "404" ]; then
    echo -e "${YELLOW}[ NOT FOUND ]${NC} organization not found"
    exit 1;
else
    echo -e "${GREEN}[ OK ]${NC} organization found"
 fi
}
checkOrg $ORG_NAME

function checkWorkspace() {
  http_code_workspace=`curl -s -o /dev/null -w "%{http_code}" \
    --header "Authorization: Bearer $TOKEN" \
    --header "Content-Type: application/vnd.api+json" \
    https://app.terraform.io/api/v2/organizations/$1/workspaces/$2`

  if [ ${http_code_workspace} -eq "404" ]; then
      echo -e "${YELLOW}[ NOT FOUND ]${NC} workspace not found"
      exit 2;
  else
      echo -e "${GREEN}[ OK ]${NC} workspace found"
  fi
}
checkWorkspace $ORG_NAME $WORKSPACE_NAME
