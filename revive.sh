#!/bin/sh

##  For some reason, my stuff crashes and I want it back.......
docker ps -a | sed 's/\s\+/ /g' | cut -d' ' -f1 |xargs docker restart
