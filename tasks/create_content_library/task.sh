#!/bin/bash -e

echo "**** Executing create_content_library ****"

validate_all_arguments() {
    MISSING_VARIABLES=""

    VARIABLES=($(env | grep "GOVC_*\|CONTENT_*\|AUTO_*\|DOWNLOAD_*"))
    for var in ${VARIABLES[@]}; do
        KEY=$(echo ${var} | cut -d "=" -f1)
        VALUE=$(echo ${var} | cut -d "=" -f2)
        if [[ -z "${VALUE}" ]]; then
            MISSING_VARIABLES+="${KEY} "
        fi
    done

    if [[ ! -z "${MISSING_VARIABLES}" ]]; then
        echo "The values are missing for these variables: ${MISSING_VARIABLES}"
        exit 1
    fi
}

create_content_library() {
    echo "Create content library: ${CONTENT_LIBRARY_NAME}"

    EXISTS=$(govc library.ls | grep ${CONTENT_LIBRARY_NAME})
    if [[ -z "${EXISTS}" ]]; then
        govc library.create -sub=${CONTENT_LIBRARY} \
            -sub-autosync=${AUTO_SYNC} \
            -sub-ondemand=${DOWNLOAD_ON_DEMAND} \
            ${CONTENT_LIBRARY_NAME}
    else
        echo "Skipping creation"
    fi
}

validate_all_arguments
create_content_library

echo "**** Done executing create_content_library ****"