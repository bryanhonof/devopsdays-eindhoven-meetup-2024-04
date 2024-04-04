#!/usr/bin/env bash

set -euo pipefail

function main() {
	local -r tfplan=".tmp.tfplan"

	pushd "$(git rev-parse --show-toplevel)/terraform" >/dev/null
	{
		tofu plan -out="${tfplan}" >/dev/null
		tofu show -json "${tfplan}" | tf-summarize -tree
		rm "${tfplan}"
	}
	popd >/dev/null
}

main "$@"
