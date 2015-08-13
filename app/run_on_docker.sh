#!/bin/bash
cd /app && bundle exec unicorn -E production -c config/unicorn.rb
