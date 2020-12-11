#!/bin/sh


_TAG=FAKESMS_START`shuf -i 2000-99999999999 -n 1`FAKESMS_END

sleep infinity | ./runner.sh $_TAG &


