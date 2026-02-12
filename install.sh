#!/bin/bash

set -euo pipefail # activate secure running of script

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

source "$SCRIPT_DIR/config.sh"
source "$SCRIPT_DIR/scripts/partition.sh"