#!/bin/bash

#[[ -z "$VAGRANT_CLOUD_TOKEN" ]] && echo "No auth token found" && exit 1
# setup auth
AUTH_HEADER="Authorization: Bearer $VAGRANT_CLOUD_TOKEN"
# read box

get_box_prev_ver() {
    local box_name=$1
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
    newver=$(add_to_ver "$oldver" major)
    echo "Creating new version $newver"
    curl --header "$AUTH_HEADER" \
         --header "Content-Type: application/json" \
         https://app.vagrantup.com/api/v1/box/zigford/$box_name/versions \
         --data "{ 'version': { 'version': '$newver' } }"
}

new_ver gentoo-openrc
