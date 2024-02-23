#!/bin/bash
. ~/.bashrc

# if any commands fail, throw an error
set -e

# print the current user's information
me=$(whoami)
echo "INFO Hello, $me!"

echo "INFO Shell $SHELL"

echo "INFO Job URL $JOB_URL"

echo "INFO Current Agent $NODE_NAME"

echo "INFO Currently directory $PWD"

# Git version
git_version=$(git --version | awk '{print $3}')
echo "INFO Git version: $git_version"

echo "========================"
echo "INFO List all ENVs: "
pyenv versions
