#!/bin/bash

DATUM=$(date +%Y-%m-%d)

tar -czf backup-$DATUM.tar.gz ~/Dokumente
