#!/bin/bash
# Complete script for API-driven runs.

# 1. Define Variables

if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 <path_to_content_directory> <organization>/<workspace>"
  exit 0
fi

CONTENT_DIRECTORY="$1"
ORG_NAME="$(cut -d'/' -f1 <<<"$2")"
WORKSPACE_NAME="$(cut -d'/' -f2 <<<"$2")"

./create-workspace-api.sh ${ORG_NAME}/${WORKSPACE_NAME} &> /dev/null

# 2. Create the File for Upload

UPLOAD_FILE_NAME="./content-$(date +%s).tar.gz"
tar -zcvf "$UPLOAD_FILE_NAME" -C "$CONTENT_DIRECTORY" .

# 3. Look Up the Workspace ID
echo https://app.terraform.io/api/v2/organizations/$ORG_NAME/workspaces/$WORKSPACE_NAME

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
