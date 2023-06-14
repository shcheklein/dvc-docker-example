#!/bin/bash

set -eux

cd workdir/inside/mount
dvc exp run --pull --allow-missing --message 'Docker Experiment'

