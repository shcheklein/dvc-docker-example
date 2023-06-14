#!/bin/bash

set -eux

git clone https://x-access-token:$STUDIO_GIT_TOKEN@github.com/shcheklein/dvc-docker-example workdir
cd workdir/inside/clone
git config --local user.name "Ivan Shcheklein"
git config --local user.email "shcheklein@gmail.com"
dvc exp run --pull --allow-missing --message 'Docker Experiment'
dvc exp push origin HEAD

