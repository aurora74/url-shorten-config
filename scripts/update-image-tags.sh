#!/usr/bin/env bash
set -euo pipefail

usage() {
  printf 'Usage: IMAGE_TAG=<tag> %s [values-file]\n' "$0" >&2
}

values_file="${1:-envs/dev/values.yaml}"

if [[ -z "${IMAGE_TAG:-}" ]]; then
  usage
  printf 'IMAGE_TAG is required.\n' >&2
  exit 2
fi

if [[ ! -f "$values_file" ]]; then
  usage
  printf 'Values file not found: %s\n' "$values_file" >&2
  exit 2
fi

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

awk -v tag="$IMAGE_TAG" '
  BEGIN {
    targets["frontend"] = 1
    targets["api"] = 1
    targets["backgroundWorker"] = 1
    targets["fraudWorker"] = 1
  }

  /^[A-Za-z][A-Za-z0-9]*:$/ {
    section = substr($0, 1, length($0) - 1)
    in_target = (section in targets)
    in_image = 0
  }

  in_target && /^  image:$/ {
    in_image = 1
  }

  in_target && in_image && /^    tag:/ {
    print "    tag: " tag
    changed[section] = 1
    next
  }

  in_target && in_image && /^  [A-Za-z][A-Za-z0-9]*:/ && $0 !~ /^  image:$/ {
    in_image = 0
  }

  { print }

  END {
    missing = 0
    for (name in targets) {
      if (!(name in changed)) {
        printf "Missing image tag for %s\n", name > "/dev/stderr"
        missing = 1
      }
    }
    if (missing) {
      exit 1
    }
  }
' "$values_file" > "$tmp_file"

mv "$tmp_file" "$values_file"
trap - EXIT

printf 'Updated workload image tags in %s to %s\n' "$values_file" "$IMAGE_TAG"
