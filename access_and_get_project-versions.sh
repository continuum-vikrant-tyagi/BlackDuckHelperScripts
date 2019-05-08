#!/bin/bash

access_token=<api access token>
web_url=<blackduck url>
projectId=<project id>


function authenticate()
{
        response=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: token $access_token" "$web_url/api/tokens/authenticate")
        bearer_token=$(echo "${response}" | jq --raw-output '.bearerToken')
}

function getProjectVersions()
{
        projects=$(curl --insecure -X GET --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" "$web_url/api/projects/$projectId/versions")
        echo $projects
}

authenticate
echo "======================Project Versions========================="
getProjectVersions
echo "==============================================================="