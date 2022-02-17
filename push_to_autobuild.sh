#!/bin/bash
# exit when any command fails
set -e

echo "================================================================="
echo "=== commit and load to github for autopublisher ==="
echo "================================================================="

echo "================================================================="
echo "=== remove all mkdown from docs directory ==="
echo "================================================================="

ls docs/*.md && rm docs/*.md
ls docs/*.md && echo 'done!'

echo "================================================================="
echo "=== rename the 'input/fsh' folder to 'input/_fsh'  ==="
echo "================================================================="
trap "echo '=== rename the input/_fsh folder to input/fsh  ==='; mv input/_fsh input/fsh" EXIT
[[ -d input/fsh ]] && mv input/fsh input/_fsh

git status

echo "================================================================="
echo "=== hit 'a' to commit and push all including untracked files ===="
echo "=== else 'c' for only tracked file or ctrl-c to exit ==="
echo "================================================================="

read var1

echo "================================================================="
echo "==================== you typed '$var1' ============================"
echo "================================================================="

if [ $var1 == "c" ]; then
  git commit -a
  git push
elif [ $var1 == "a" ]; then
  git add .
  git commit
  git push
fi
