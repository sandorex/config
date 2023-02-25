#/bin/bash
#
# autocommit.sh - script that automatically commits the config

git commit -m "A $(hostname) ($(date))"
