#!/usr/bin/env sh
set -e

case $@ in
  json)
    exec bundle exec rake json
    ;;
  js)
    exec bundle exec rake js
    ;;
  preview)
    exec bundle exec rake preview
    ;;
  *)
    exec "$@"
esac
