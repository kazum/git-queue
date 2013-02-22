#!/bin/bash

./test.sh | perl -pe 's/[0-9a-f]{7}/XXXXXXX/' | diff - test.out
