#!/bin/bash

USED_PERCENT=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if [ "$USED_PERCENT" -gt 80 ]
then
	echo "Warnung: Platte fast voll!"
else
	echo "Alles OK"
fi
