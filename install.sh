#!/bin/bash
# install.sh

set -euo pipefail # activate secure running of script

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Starting subscripts"

source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/scripts/partition.sh"