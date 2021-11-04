#!/bin/sh -l

cd /bg_version_up
bundle install
bundle exec ruby main.rb $INPUT_TOKEN $INPUT_REPO $INPUT_CURRENT_VERSION $INPUT_NEXT_VERSION
