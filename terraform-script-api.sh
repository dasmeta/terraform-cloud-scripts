#!/bin/bash
# Complete script for API-driven runs.

# 1. Define Variables

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

function askUser() {
  read -p  $'\e[33m[ ... ]\e[0m Workspace not found, create new one? [Yy]: ' choice
  if ! [[ $choice =~ ^[Yy]$ ]]
  then
      exit 1;
  fi
}

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <path_to_content_directory> <organization>/<workspace>"
  exit 0
fi

CONTENT_DIRECTORY="$1"
ORG_NAME="$(cut -d'/' -f1 <<<"$2")"
WORKSPACE_NAME="$(cut -d'/' -f2 <<<"$2")"

check-workspace-api $ORG_NAME/$WORKSPACE_NAME
echo $? > getExit

if [ $? -eq 1 ]; then
    echo 1;
elif [ $(cat getExit) -eq 2 ]; then
    askUser
fi
rm getExit

create-workspace-api ${ORG_NAME}/${WORKSPACE_NAME}

# 2. Create the File for Upload
UPLOAD_FILE_NAME="./content-$(date +%s).tar.gz"
tar -zcf "$UPLOAD_FILE_NAME" -C "$CONTENT_DIRECTORY" . &> /dev/null

{
WORKSPACE_ID=($(curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  https://app.terraform.io/api/v2/organizations/$ORG_NAME/workspaces/$WORKSPACE_NAME \
  | jq -r '.data.id'))
echo $WORKSPACE_ID
} &> /dev/null

# 4. Create a New Configuration Version
echo '{"data":{"type":"configuration-versions"}}' > ./create_config_version.json

{
UPLOAD_URL=$(curl \
  --header "Authorization: Bearer $TOKEN" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data @create_config_version.json \
  https://app.terraform.io/api/v2/workspaces/$WORKSPACE_ID/configuration-versions \
  | jq -r '.data.attributes."upload-url"')
} &> /dev/null
# 5. Upload the Configuration Content File

{
curl \
  --header "Content-Type: application/octet-stream" \
  --request PUT \
  --data-binary @"$UPLOAD_FILE_NAME" \
  $UPLOAD_URL
  }&> /dev/null

# 6. Delete Temporary Files
rm "$UPLOAD_FILE_NAME"
rm ./create_config_version.json

echo -e -n "${GREEN}[ OK ] ${NC} Plan started"