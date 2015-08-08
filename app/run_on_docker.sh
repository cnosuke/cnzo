#!/bin/bash
cd /app && RBENV_ROOT=~/.rbenv RBENV_VERSION=2.2.2 ~/.rbenv/bin/rbenv exec bundle exec unicorn -E production -c config/unicorn.rb
