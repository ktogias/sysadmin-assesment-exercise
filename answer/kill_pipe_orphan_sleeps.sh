#!/bin/bash

SLEEP_INFINITY_COMMAND="sleep infinity"

filter_infinity_sleep_process_ids () {
    local ALL_PIDS="$@"
    INFINITY_SLEEP_PIDS=()
    for PID in ${ALL_PIDS[@]};
    do
        local COMMAND=$(ps -p "$PID" -o args --no-headers)
        if [ "$COMMAND" = "$SLEEP_INFINITY_COMMAND" ]; then
            INFINITY_SLEEP_PIDS+=( $PID )
        fi
    done
}

filter_to_kill_process_ids (){
    local ALL_PIDS="$@"
    TO_KILL_PIDS=()
    for PID in ${ALL_PIDS[@]};
    do
        TO_KILL_PIDS+=( $PID )
    done
}

SLEEP_PIDS=($(pidof sleep))
filter_infinity_sleep_process_ids "${SLEEP_PIDS[@]}"
filter_to_kill_process_ids "${INFINITY_SLEEP_PIDS[@]}"

echo ${SLEEP_PIDS[@]}
echo ${INFINITY_SLEEP_PIDS[@]}
echo ${TO_KILL_PIDS[@]}
