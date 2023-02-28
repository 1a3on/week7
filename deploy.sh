#!/usr/bin/env sh

# abort on errors
set -e

# build
npm run build

# navigate into the build output directory
cd dist

# place .nojekyll to bypass Jekyll processing
echo > .nojekyll

# if you are deploying to a custom domain
# echo 'www.example.com' > CNAME

git init
git checkout -B main
git add -A
git commit -m 'deploy'

# if you are deploying to https://1a3on.github.io
# git push -f git@github.com:1a3on/1a3on.github.io.git main

# if you are deploying to https://1a3on.github.io/week7
git push -f https://github.com/1a3on/week7.git main:gh-pages

cd -