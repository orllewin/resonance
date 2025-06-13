#!bin/bash

R=$(jot -r 1  3 15)
echo -----
echo $R
M=$(yes "|" | tr -d '\n' | head -c "$R")
echo -----
git add .
git commit -m $M
git push origin main