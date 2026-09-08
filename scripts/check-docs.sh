#!/usr/bin/env bash
# Check that public headers under include/ride/ have a @brief comment.
# Passes when no headers exist yet (Phase 0). Enforces docs from Phase 1 onward.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HEADER_DIR="${ROOT}/include/ride"

failed=0
count=0

while IFS= read -r -d '' header; do
  count=$((count + 1))
  if ! grep -q '@brief' "${header}"; then
    echo "error: missing @brief in ${header#"${ROOT}/"}"
    failed=1
  fi
done < <(find "${HEADER_DIR}" \( -name '*.hpp' -o -name '*.h' \) -type f -print0 | sort -z)

if [[ "${count}" -eq 0 ]]; then
  echo "check-docs: no public headers under include/ride/ — skipping"
  exit 0
fi

if [[ "${failed}" -ne 0 ]]; then
  echo "check-docs: failed — add Doxygen @brief to public headers in include/ride/"
  exit 1
fi

echo "check-docs: ok (${count} header(s))"
exit 0
