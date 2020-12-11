#!/bin/bash

filter_infinity_sleep_process_ids () {
    local ALL_PIDS="$@"
    INFINITY_SLEEP_PIDS=()
    for PID in ${ALL_PIDS[@]};
    do
        INFINITY_SLEEP_PIDS+=( $PID )
    done
}

SLEEP_PIDS=($(pidof sleep))
filter_infinity_sleep_process_ids "${SLEEP_PIDS[@]}"

echo ${SLEEP_PIDS[@]}
echo ${INFINITY_SLEEP_PIDS[@]}
