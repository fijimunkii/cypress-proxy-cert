#!/usr/bin/env bash

set -e
set -u
set -o pipefail

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
mkdir -p $DIR/cert

if [ -z ${S3_BUCKET+x} ]; then
  echo "missing S3_BUCKET env for sync_cert"
else
  aws s3 sync s3://$S3_BUCKET/cert $DIR/cert >/dev/null || echo "cert sync failed"
fi
