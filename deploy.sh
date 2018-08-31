#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit

echo "Deploying..."
echo "Make sure your google compute SSH identity is added. If not, use:"
echo "   ssh-add ~/.ssh/google_compute_engine" 
echo "   ssh-add ~/.ssh/google_compute_engine_PERSONAL"

cd site
jekyll build
rsync -av _site dougrichardson.org:/home/doug
