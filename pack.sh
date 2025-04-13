#!/bin/bash

command -v zip > /dev/null
if [ $? -ne 0 ]; then
    echo Command zip not found. Please make sure zip package is installed.
    exit 1
fi

FILENAME=huber.orgue
if [ -f "${FILENAME}" ]; then
    rm -f "${FILENAME}"
fi
cd Organ
zip -0 -r "../${FILENAME}" *
cd ..
echo
echo DONE
echo