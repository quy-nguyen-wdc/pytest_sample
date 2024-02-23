#!/bin/bash
. ~/.bashrc

# Clone git repo and run test

pyenv global $pyenv

if [ -d "venv" ]; then
	echo "INFO venv folder exists in the current directory."
    source venv/bin/activate
else
	echo "INFO venv folder doesn't exist in the current directory."
    python3 -m venv venv
    source venv/bin/activate

echo "INFO The environment for Python is ready"
pip install --upgrade pip
pip install -r requirements.txt

fi

echo "INFO Run Pytest"
echo "==========================="
pytest

echo "INFO Done!!"
