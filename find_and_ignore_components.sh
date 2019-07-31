#!/bin/bash

# Globals
access_token=
web_url=
version_id=
component_name=
component_version=

function authenticate()
{
        response=$(curl --insecure -X POST --header "Content-Type:application/json" --header "Authorization: token $access_token" "$web_url/api/tokens/authenticate")
        bearer_token=$(echo "${response}" | jq --raw-output '.bearerToken')
}

function findAndIgnoreComponent()
{
        # Find all components in a BOM
        components=$(curl --insecure -X GET --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" "$web_url/api/v1/releases/$version_id/component-bom-entries")
        
        # Find the component using name and version
        componentToIgnore=$(echo "$components" | jq -c --arg component "$component_name" --arg version "$component_version" '.items[] | select(.projectName==$component and .releaseVersion==$version)')
        
        # Check if we found the component we are looking for
        if [ -z "$componentToIgnore" ]
        then
                # Failed log and exit
                echo "FAILED: Component $component_name version $component_version not found"
                exit
        else
                # Found component set the ignore flag to true
                result=$(echo "$componentToIgnore" | jq -c '.ignored |= true' | jq '[.]')

                # Send the updated component information  
                out=$(curl --insecure -X PUT --header "Content-Type:application/json" --header "Authorization: bearer $bearer_token" -d "$result" "$web_url/api/v1/releases/$version_id/component-bom-entries")
                if [ "$out" -eq "1" ]
                then
                        # Success 
                        echo "SUCCESS: Ignored component $component_name version $component_version"
                fi
        fi
}

################ MAIN ##################

# Get inputs
# As long as there is at least one more argument, keep looping
while [[ $# -gt 0 ]]; do
    key="$1"
    case "$key" in
        # component name to ignore arg passed as space
        -c|--component-name)
        shift
        component_name="$1"
        ;;
        # component version to ignore arg passed as space
        -cv|--component-version)
        shift
        component_version="$1"
        ;;
        # component version to ignore arg passed as space
        -v|--project-version-id)
        shift
        version_id="$1"
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
findAndIgnoreComponent

##############################################