#!/usr/bin/env bash
set -e
cd "$(dirname "$0")"
[ -d node_modules/express ] || npm install
printf 'Open http://localhost:5000\n'
npm start
