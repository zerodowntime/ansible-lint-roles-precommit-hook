#!/bin/bash
#
# Pre-commit hook that wraps ansible lint.
#
# Pre-commit can list only directories as submodules. 
# Effectively it is unable to pass role or dir with playbooks to check
# This script extracts dir from given files are puts them into set

EXIT_STATUS=0
for file in "$@"; do
    if [[ $file == *"/tasks/"* ]]; then
      role_dirs="$role_dirs ${file%/tasks/*}"
    fi
done 
role_dirs=$(echo "$role_dirs" | tr ' ' '\n' | sort | uniq)

echo "Checking roles:"
echo "$role_dirs"  

ansible-lint --force-color $role_dirs

exit $?
