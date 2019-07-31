#!/bin/bash

access_token=""
web_url=""
tokenId=""
json='{"name":"Alert","scopes":["read"],"_meta":{"allow":["DELETE","POST","GET","PUT"],"href":"https://$web_url/api/current-user/tokens/$tokenId","links":[]}}'


# As long as there is at least one more argument, keep looping
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        # Scan file arg passed as space
        -t|--token-id)
        shift
        tokenId="$1"
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

function getTokens()
{
        result=$(curl --insecure -X GET --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" "$web_url/api/current-user/tokens/$tokenId")
        echo "$result"
}

function updateToken()
{
        result=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" -d "$json" "$web_url/api/current-user/tokens/$tokenId")
        echo "$result"
}


authenticate
echo "===========================TOKENS=============================="
getTokens
echo "==============================================================="
echo "======================UPDATING TOKEN==========================="
updateToken
echo "==============================================================="