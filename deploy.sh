#!/bin/bash

set -xeuo pipefail

echo "Deploying..."
echo "Make sure your google compute SSH identity is added. If not, use:"
echo "   ssh-add ~/.ssh/google_compute_engine" 

cd site
jekyll build
rsync -av _site dougrichardson.org:/home/doug
