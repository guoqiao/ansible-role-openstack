#!/bin/bash -x
# User-Data Shell Script for CloudInit

echo 0 > /proc/sys/kernel/yama/ptrace_scope
echo 0 > /proc/sys/kernel/perf_event_paranoid
mount / -o remount,rw,nobarrier
/etc/init.d/rng-tools start
