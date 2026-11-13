#!/usr/bin/env bash
set -euo pipefail

# Clean up previous runs if any
rm -rf pool.git client tmp_init

# Initialize bare repository with factory as default branch
git init --bare -b factory pool.git

# Seed initial factory branch and derived branches via a temporary clone
# All branches are identical.
git clone pool.git tmp_init
cd tmp_init
git checkout -b factory
git commit --allow-empty -m "Initial empty commit"
git branch slfo-main
git branch slfo-1.3
git push origin factory slfo-main slfo-1.3
cd ..
rm -rf tmp_init

# Clone pool.git into client
git clone pool.git client
cd client

# Make a change on a feature branch and merge into factory with --no-ff (emulate PR)
git checkout factory
git checkout -b feature/change-1
echo "Feature update $(date)" > feature.txt
git add feature.txt
git commit -m "feat: add feature file"

# Emulate PR into factory
git checkout factory
git merge --no-ff feature/change-1 -m "Merge pull request #1 from feature/change-1 into factory"
git push origin factory

# Emulate PR based on factory into slfo-main
git checkout slfo-main
git merge --no-ff factory -m "Merge pull request #2 from factory into slfo-main"
git push origin slfo-main

# Emulate PR based on factory into slfo-1.3
git checkout slfo-1.3
git merge --no-ff factory -m "Merge pull request #3 from factory into slfo-1.3"
git push origin slfo-1.3


# 2nd change


# Make a change on a feature branch and merge into factory with --no-ff (emulate PR)
git checkout factory
git checkout -b feature/change-2
echo "Feature update $(date)" > feature.txt
git add feature.txt
git commit -m "feature #2"

# Emulate PR into factory
git checkout factory
git merge --no-ff feature/change-2 -m "Merge pull request #4 from feature/change-2 into factory"
git push origin factory

# Emulate PR based on factory into slfo-main
git checkout slfo-main
git merge --no-ff factory -m "Merge pull request #5 from factory into slfo-main"
git push origin slfo-main

# Emulate PR based on factory into slfo-1.3
git checkout slfo-1.3
git merge --no-ff factory -m "Merge pull request #6 from factory into slfo-1.3"
git push origin slfo-1.3


cd ..
echo "Setup and PR simulation completed successfully."
