#!/usr/bin/env bash
# .github/scripts/gen-forms.sh — (re)build the request issue forms from THIS repo's config.json.
#
# Per-school model: a repo carries exactly ONE config.json (its own school), so only that school's
# course forms are ever generated — cross-school pollution is impossible. Wipes all request-*.yml,
# then writes one request-<course>.yml per course (dropdown = that course's assignment keys).
# register/myrepos/config.yml are course-agnostic and left untouched.
#
# THE single generator — run by both:
#   - ops/cfg.sh                        (local, after editing a school's config.json)
#   - .github/workflows/sync-forms.yml  (server, on config.json push)
# One implementation → local and server never drift.
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CONFIG="$ROOT/config.json"
TPL="$ROOT/.github/ISSUE_TEMPLATE"

# a config-less repo (the template itself) just has no request forms
if [ ! -f "$CONFIG" ]; then
  echo "gen-forms: no config.json here — clearing request forms (template/uninitialized repo)"
  rm -f "$TPL"/request-*.yml
  exit 0
fi
jq -e . "$CONFIG" >/dev/null || { echo "gen-forms: config.json is not valid JSON" >&2; exit 1; }

rm -f "$TPL"/request-*.yml
jq -r '.courses | keys_unsorted[]' "$CONFIG" | while read -r course; do
  up="$(printf '%s' "$course" | tr '[:lower:]' '[:upper:]')"
  out="$TPL/request-$course.yml"
  {
    printf 'name: Request a %s repo\n' "$up"
    printf 'description: Get your personal repo for a %s assignment. Register first if you have not.\n' "$up"
    printf 'title: "request-%s: "\n' "$course"
    printf 'body:\n'
    printf '  - type: markdown\n    attributes:\n      value: |\n'
    printf '        ### Request your %s assignment repo\n' "$up"
    printf '        Pick the assignment. Your GitHub username is captured automatically.\n'
    printf '        Not registered yet? Open the **Register** form first.\n'
    printf '  - type: dropdown\n    id: assignment\n    attributes:\n'
    printf '      label: Assignment\n'
    printf '      description: (Auto-generated from config.json — do not hand-edit.)\n'
    printf '      options:\n'
    jq -r --arg c "$course" '.courses[$c].assignments | keys_unsorted[] | "        - " + .' "$CONFIG"
    printf '    validations:\n      required: true\n'
  } > "$out"
  n="$(jq -r --arg c "$course" '.courses[$c].assignments | length' "$CONFIG")"
  printf 'gen-forms: generated %s  (%s assignments)\n' "request-$course.yml" "$n"
done

echo "gen-forms: done."
