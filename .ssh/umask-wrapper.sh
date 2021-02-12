#!/bin/sh

umask 0027
exec /bin/sh -c "${SSH_ORIGINAL_COMMAND:-$SHELL}"
