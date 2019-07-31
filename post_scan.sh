#!/bin/bash

access_token=""
web_url=""
scan_file=""


# As long as there is at least one more argument, keep looping
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        # Scan file arg passed as space
        -s|--scan-file)
        shift
        scan_file="$1"
        ;;
        # access token arg passed as space
        -a|--access-token)
        shift
        access_token="$1"
        ;;
        # hub url arg passed as space
        -hu|--hub-url)
        shift
        web_url="$1"
        ;;
        *)
        # Do whatever you want with extra options
        echo "Unknown option '$key'"
        ;;
    esac
    # Shift after checking all the cases to get the next option
    shift
done


function authenticate()
{
        response=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: token $access_token" "$web_url/api/tokens/authenticate")
        bearer_token=$(echo "${response}" | jq --raw-output '.bearerToken')
        echo "authenticated"
}

function postScans()
{
        result=$(curl --insecure -X POST --header "Content-Type:application/ld+json" --header "Authorization: bearer $bearer_token" -d @$scan_file "$web_url/api/scan/data/?mode=replace")
        echo "$result"
}

authenticate
echo "=========================Posting Scan=========================="
echo "scan file: $scan_file"
postScans
echo "==============================================================="

