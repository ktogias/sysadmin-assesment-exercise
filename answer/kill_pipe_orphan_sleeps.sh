#!/bin/bash

PIDS_TO_KILL=$(pidof sleep)

echo ${PIDS_TO_KILL[@]}
