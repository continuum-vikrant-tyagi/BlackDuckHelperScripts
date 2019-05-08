#!/bin/bash

access_token=<Api token>
web_url=<hub url>


function authenticate()
{
        response=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: token $access_token" "$web_url/api/tokens/authenticate")
        bearer_token=$(echo "${response}" | jq --raw-output '.bearerToken')
}

function getLicenseTerms()
{
        terms=$(curl --insecure -X GET --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" "$web_url/api/license-terms?limit=100")
        echo $terms
}

authenticate
echo "============================License============================"
getLicenseTerms
echo "==============================================================="