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

get_pipe_pids (){
    local PIPE_LS="$1"
    PIPE_PIDS=()
    for WORD in $PIPE_LS;
    do
        local PID=$(echo $WORD | sed '/\/proc\/\([0-9]*\)\/fd.*/!d;s//\1/')
        if [ "$PID" != "" ]; then
            PIPE_PIDS+=( $PID )
        fi
    done
}

contains_runner_pid (){
    local PIDS="$@"
    for PID in ${PIDS[@]}; do
        local COMMAND=$(ps -p "$PID" -o args --no-headers)
        local MATCH=$(echo $COMMAND | sed '/.*\(runner\.sh\ FAKESMS_START.*FAKESMS_END\)/!d;s//\1/')
        if [ "$MATCH" != "" ]; then
            echo "1"
            return 0
        fi
    done
    echo "0"
}

filter_to_kill_process_ids (){
    local ALL_PIDS="$@"
    TO_KILL_PIDS=()
    for PID in ${ALL_PIDS[@]};
    do
        local PIPE=$(readlink -f /proc/"$PID"/fd/1)
        local PIPE_PART=$(echo $PIPE | sed 's/.*\(pipe:.*\)/\1/' )
        local PIPE_LS="$((find /proc -type l | xargs ls -l | fgrep "$PIPE_PART") 2>/dev/null)"
        get_pipe_pids "$PIPE_LS"
        if [ "$(contains_runner_pid "${PIPE_PIDS[@]}")" != "1" ]; then
            TO_KILL_PIDS+=( $PID )
        fi;
    done
}

SLEEP_PIDS=($(pidof sleep))
filter_infinity_sleep_process_ids "${SLEEP_PIDS[@]}"
filter_to_kill_process_ids "${INFINITY_SLEEP_PIDS[@]}"

echo ${SLEEP_PIDS[@]}
echo ${INFINITY_SLEEP_PIDS[@]}
echo ${TO_KILL_PIDS[@]}
