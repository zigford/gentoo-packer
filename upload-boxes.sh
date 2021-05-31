#!/bin/bash

#[[ -z "$VAGRANT_CLOUD_TOKEN" ]] && echo "No auth token found" && exit 1
# setup auth
AUTH_HEADER="Authorization: Bearer $VAGRANT_CLOUD_TOKEN"
# read box

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

new_ver() {
    local box_name=$1
    oldver=$(get_box_prev_ver "$box_name")
    newver=$(add_to_ver "$oldver" patch)
    echo "Creating new version $newver" >&2
    curl -s --header "$AUTH_HEADER" \
         --header "Content-Type: application/json" \
         https://app.vagrantup.com/api/v1/box/zigford/$box_name/versions \
         --data "{ \"version\": { \"version\": \"$newver\" } }" |
    jq -r '.release_url' | sed 's/\/\w\+$//'
}

new_provider() {
    local box_ver_url=$1
    local provider=$2
    echo "Creating new provider for $box_ver_url" >&2
    curl -s --header "$AUTH_HEADER" \
         --header "Content-Type: application/json" \
         "${box_ver_url}/providers" \
         --data "{ \"provider\": { \"name\": \"$provider\" } }"
}

upload_box() {
    response=$(curl \
            --header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" \
             https://app.vagrantup.com/api/v1/box/myuser/test/version/1.2.3/provider/virtualbox/upload)

    # Extract the upload URL from the response (requires the jq command)

    upload_path=$(echo "$response" | jq .upload_path)

    # Perform the upload

    curl $upload_path --request PUT --upload-file virtualbox-1.2.3.box


}

ver_url=$(new_ver gentoo-openrc)
new_provider $ver_url libvirt

# get_box_prev_ver gentoo-openrc


