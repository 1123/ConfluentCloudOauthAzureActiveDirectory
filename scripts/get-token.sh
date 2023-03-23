set -u -e

curl \
  -X POST \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d 'client_id='$CLIENT_ID'&scope='$CLIENT_ID'/.default&client_secret='$CLIENT_SECRET'&grant_type=client_credentials' \
  https://login.microsoftonline.com/$AZURE_TENANT/oauth2/v2.0/token
