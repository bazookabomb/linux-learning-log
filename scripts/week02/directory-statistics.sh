#!/bin/bash

echo "Ordner: $1"
echo "Dateien:"

find "$1" -type f | wc -l
