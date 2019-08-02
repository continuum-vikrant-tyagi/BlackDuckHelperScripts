#!/bin/bash

access_token=""
web_url=""
project_id=""
project_version_id=""


function authenticate()
{
        response=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: token $access_token" "$web_url/api/tokens/authenticate")
        bearer_token=$(echo "${response}" | jq --raw-output '.bearerToken')
}

function deleteProjectVersion()
{
        result=$(curl --insecure -X DELETE --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" "$web_url/api/projects/$project_id/versions/$project_version_id")
        if [ "$result" -eq "204" ]
        then
                # Fail 
                echo "FAILED: Could not delete project version. Check user permissions"
        else
                # Success
                echo "Project version with project id: $project_id and version id: $project_version_id deleted successfully"
        fi
}

################ MAIN ##################

# Get inputs
# As long as there is at least one more argument, keep looping
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        # component name to ignore arg passed as space
        -p|--project-id)
        shift
        project_id="$1"
        ;;
        # component name to ignore arg passed as space
        -p|--project-version-id)
        shift
        project_version_id="$1"
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

# Start
authenticate
deleteProjectVersion

##############################################