#!/bin/bash -e

echo "**** Executing disable-tkg ****"

validate_all_arguments() {
    MISSING_VARIABLES=""

    VARIABLES=($(env | grep "GOVC*\|CLUSTER_*"))
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

disable_workload_cluster() {
   echo "**** Executing disable_workload_cluster ****"
   govc namespace.cluster.disable -cluster "${CLUSTER_NAME}"
}

validate_all_arguments
disable_workload_cluster

echo "**** Done executing disable-tkg ****"