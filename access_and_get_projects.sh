#!/bin/bash

access_token=<token>
web_url=<url>

function authenticate()
{

        response=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: token $access_token" "$web_url/api/tokens/authenticate")

        bearer_token=$(echo "${response}" | jq --raw-output '.bearerToken')
}

function getProjects()
{
        projects=$(curl --insecure -X GET --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" "$web_url/api/projects")
        echo $projects
}

authenticate
getProjects