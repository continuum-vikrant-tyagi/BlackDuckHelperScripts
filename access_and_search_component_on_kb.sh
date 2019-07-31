#!/bin/bash

access_token=<api access token>
web_url=<blackduck url>
search_query=apache


function authenticate()
{
        response=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: token $access_token" "$web_url/api/tokens/authenticate")
        bearer_token=$(echo "${response}" | jq --raw-output '.bearerToken')
}

function getComponent()
{
        component=$(curl --insecure -X GET --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" "$web_url/api/search/components?q=$search_query")
        echo $component
}

authenticate
echo "============================Projects==========================="
getComponent
echo "==============================================================="