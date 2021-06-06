#!/bin/bash

[[ -z "$VAGRANT_CLOUD_TOKEN" ]] && echo "No auth token found" && exit 1
# setup auth
AUTH_HEADER="Authorization: Bearer $VAGRANT_CLOUD_TOKEN"
# read box
BASE_URL="https://app.vagrantup.com/api/v1/box/zigford"

get_box_prev_ver() {
    local box_name=$1
    [[ -z "$box_name" ]] && echo "no box name" && exit 1
    curl -s --header $AUTH_HEADER \
    https://app.vagrantup.com/api/v1/box/zigford/$box_name |
    jq -r '.versions[0].version'
}

add_to_ver() {
    local oldver=$1
    local type=$2
    local major="${oldver%%.*}"
    local minor="${oldver#$major.*}"
    minor="${minor%%.*}"
    local patch="${oldver#$major.$minor.}"
    patch="${patch%%.*}"
    local build="${oldver#$major.$minor.$patch}"
    build="${build#.}"
    if [ "$oldver" == "null" ]; then echo "1.0.0"
    else
        case "$type" in
            major)   major=$((major+1));;
            minor)   minor=$((minor+1));;
            patch)   patch=$((patch+1));;
            build)   build=$((build+1));;
        esac
        echo $major.$minor.$patch.$build
    fi
}

add_provider_to_ver() {
    local box_ver_url=$1
    local provider=$2
    echo "Creating new provider for $box_ver_url" >&2
    curl -s --header "$AUTH_HEADER" \
         --header "Content-Type: application/json" \
         "${box_ver_url}/providers" \
         --data "{ \"provider\": { \"name\": \"$provider\" } }" \
         > /dev/null
}

create_new_ver_url() {
    local box_name=$1
    local newver=$2
    echo "Creating new version $newver" >&2
    curl -s --header "$AUTH_HEADER" \
         --header "Content-Type: application/json" \
         https://app.vagrantup.com/api/v1/box/zigford/$box_name/versions \
         --data "{ \"version\": { \"version\": \"$newver\" } }" |
    jq -r '.release_url' | sed 's/\/\w\+$//'
}

upload_box() {
    local box="$1"
    local box_name="$2"
    local ver="$3"
    local ver_url=${BASE_URL}/$box_name/version/$ver
    local prov_url=${ver_url}/provider/libvirt/upload
    new_ver_url=$(create_new_ver_url "$box_name" "$newver")
    add_provider_to_ver "$new_ver_url" libvirt
    response=$(curl -s --header "$AUTH_HEADER" $prov_url)
    # Extract the upload URL from the response (requires the jq command)
    upload_path=$(echo "$response" | jq -r .upload_path)
    curl $upload_path --request PUT --upload-file "$box"
    if [[ $? == 0 ]]; then
        curl --header "$AUTH_HEADER" "$new_ver_url" --request PUT
    else
        error_m "Something went wrong"
    fi
}

do_stuff() {
    local box="$1"
    local box_name="$2"
    local update="$3"
    oldver=$(get_box_prev_ver "$box_name")
    newver=$(add_to_ver "$oldver" $update)
    printf "Uploading $box as $box_name ver $oldver, "
    printf "with new version $newver\n"
    if [[ -n "$dry_run" ]]; then
        echo "Dry run, skipping upload"
        exit 0
    fi
    upload_box "$box" "$box_name" "$newver"

}

# get_box_prev_ver gentoo-openrc
usage() {
    echo "By Jesse Harris"
    echo ""
    echo "${0##*/} [options] box_file_name.box"
    echo ""
    echo "Options"
    echo "-b, --box         specify the name of the box"
    echo "-u, --update      specify major, minor, patch update"
    echo "-n, --dry-run     dont do any work"
    echo ""
}

error_m() {
    local msg="$1"
    RED="\e[31m"
    ENDCOLOR="\e[0m"
    echo ""
    echo -e "${RED}${msg}${ENDCOLOR}"
    echo ""
    exit 1
}

main() {
    local box
    local name
    local update
    while [[ $# != 0 ]]; do
        case "$1" in
            --box-name|-b)  shift;name=$1;    shift;;
            --update|-u)    shift;update=$1;  shift;;
            --help|-h)      usage;            shift;;
            --dry-run|-n)   dry_run=y;        shift;;
            *)              box="$1";         shift;;
        esac
    done
    
    # validate params
    [[ -z "$box" ]] || [[ ! -f "$box" ]] &&
        error_m "Please specify box file"
    update="${update:-major}"
    name="${name:-$box}"
    name="${name%.*}"
    do_stuff "$box" "$name" "$update"
}


[[ "$BASH_SOURCE" == "$0" ]] && main "$@"
