#!/usr/bin/env bash

set -euo pipefail

function main() {
	aws sso login \
		--profile "${1:-dev}" \
		--endpoint-url "${2:-https://somewhere.awsapps.com/start/#/}" \
		--region "${3:-us-east-1}"
	eval "$(aws configure export-credentials --profile "${1:-dev}" --format env)"
}

main "$@"
