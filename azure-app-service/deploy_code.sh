RG_NAME="$1"
WEBAPP_NAME="$2"
STORAGE_ACCOUNT_NAME="$3"
ARTIFACT="$4"


# install az
curl -sL https://aka.ms/InstallAzureCLIDeb | bash


# login to azure
az login --identity -u $ARM_CLIENT_ID


# generate sas token
file_share_name="$(cut -d'/' -f1 <<<"$ARTIFACT")"
echo "file_share_name: $file_share_name"

end=`date -u -d "30 minutes" '+%Y-%m-%dT%H:%MZ'`
sas=`az storage share generate-sas -n $file_share_name --account-name $STORAGE_ACCOUNT_NAME --https-only --permissions r --expiry $end -o tsv`
echo "sas: $sas"

url="https://$STORAGE_ACCOUNT_NAME.file.core.windows.net/$ARTIFACT?$sas"
echo "url with sas: $url"


# deploy code
az webapp config appsettings set --resource-group "$RG_NAME" --name "$WEBAPP_NAME" --settings WEBSITE_RUN_FROM_PACKAGE="$url"