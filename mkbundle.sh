#!/bin/sh

rm -f bundle.tbz
tar jcvf bundle.tbz --exclude=.git* bundle/

