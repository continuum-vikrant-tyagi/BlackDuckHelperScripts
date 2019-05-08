#!/bin/bash

access_token=ZTAwZDM1MTktMjM2Mi00NTI0LWIzZTgtNTc4NDhlOWQxYmI5OjYzYjU4NzEyLWVmNTMtNDRkOS1hZmIzLWU5OTI5MzEzOWU2ZA==
web_url=https://imp-docker03.dc1.lan


function authenticate()
{
        response=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: token $access_token" "$web_url/api/tokens/authenticate")
        bearer_token=$(echo "${response}" | jq --raw-output '.bearerToken')
}

function getLicenseTerms()
{
        projects=$(curl --insecure -X GET --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" "$web_url/api/license-terms?limit=100")
        echo $projects
}

authenticate
echo "============================Projects==========================="
getLicenseTerms
echo "==============================================================="

pause