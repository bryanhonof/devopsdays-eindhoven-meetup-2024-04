#!/usr/bin/env bash

set -euo pipefail

function main() {
	hello | cowsay -T tongue | lolcat
}

main "$@"
