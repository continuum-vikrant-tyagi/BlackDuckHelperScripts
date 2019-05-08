#!/bin/bash

access_token=<api access token>
web_url=<blackduck url>
versionId=<version id of project>

function authenticate()
{
        response=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: token $access_token" "$web_url/api/tokens/authenticate")
        bearer_token=$(echo "${response}" | jq --raw-output '.bearerToken')
}

function createNoticesReport()
{
        echo "Creataing notice for version id $versionId" 
        createResponse=$(curl --insecure -X POST --header 'Content-Type: application/json' --header 'Accept: application/json' --header "Authorization: bearer $bearer_token" -d '{"reportFormat": "JSON"}' "$web_url/api/versions/$versionId/license-reports")
        if [ -z "$createResponse" ]
        then
                echo "Notices file created"
        else
                echo "could not create notices file...check version id"
        fi
}

authenticate
createNoticesReport