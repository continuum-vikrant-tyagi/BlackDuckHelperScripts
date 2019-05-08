#!/bin/bash

access_token=<api_token>
web_url=<api_url>
projectId=<projectId>
versionId=<versionId>


function authenticate()
{
        response=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: token $access_token" "$web_url/api/tokens/authenticate")
        bearer_token=$(echo "${response}" | jq --raw-output '.bearerToken')
}

function getProjectVersionComponents()
{
        components=$(curl --insecure -X GET --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" "$web_url/api/projects/$projectId/versions/$versionId/components")
        echo $components
}

authenticate
echo "=========================Components============================"
getProjectVersionComponents
echo "==============================================================="