#!bin/bash

randomCount=$(jot -r 1  3 15)
M=$(yes "|" | tr -d '\n' | head -c "$randomCount")
git add .
git commit -m $M
git push origin main