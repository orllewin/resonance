#!/bin/bash

randomCount=$(jot -r 1  3 20)
M=$(yes "|" | tr -d '\n' | head -c "$randomCount")
git add .
git commit -m $M
git push origin main

echo https://github.com/orllewin/resonance