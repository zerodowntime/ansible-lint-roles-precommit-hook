#!/bin/bash
#
# Pre-commit hook that wraps ansible lint.
#
# Pre-commit can list only directories as submodules. 
# Effectively it is unable to pass role or dir with playbooks to check
# This script extracts dir from given files are puts them into set

POSITIONAL=()
LINT_ARGS=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -c)
    LINT_ARGS+=("$1")
    LINT_ARGS+=("$2")
    shift # past argument
    shift # past argument
    ;;
    --force-color)
    LINT_ARGS+=("$1")
    shift # past argument
    ;;
    --nocolor)
    LINT_ARGS+=("$1")
    shift # past argument
    ;;
    *)    # unknown option
    # echo $1
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

for file in "$@"; do
    if [[ $file == *"/tasks/"* ]]; then
      role_dirs="$role_dirs ${file%/tasks/*}"
    fi
done 
role_dirs=$(echo "$role_dirs" | tr ' ' '\n' | sort | uniq)

echo "Running ansible-lint" "${LINT_ARGS[@]}"
echo "Checking roles:"
echo "$role_dirs"  

ansible-lint "${LINT_ARGS[@]}" $role_dirs

exit $?
