# Spec 030: Skill metadata and troubleshooting

Status: implemented; structural checks and local quality evaluation passed.
Date: 2026-11-13.

## Problem

SkillEvaluator 0.9.0 quality-check reports missing author and tag metadata and
unrecognized troubleshooting sections in all seven repository skills. Five
skills score below its A threshold of 90. The scores are deterministic
documentation heuristics, not evidence of agent behavior or OCI compatibility.

## Scope and intended behavior

Implement priority 1 only in the seven `skills/oci-agent-*/SKILL.md` files:

* Add `metadata.author: "L. Saetta"` and `metadata.tags` as a comma-separated
  string of three to five stable platform, domain, and operation keywords.
  Use `oci` and `hosted-applications` consistently; distinguish each operation.
* Add a concise `## Troubleshooting` table with symptom, cause, and action,
  summarizing existing prerequisites, exit codes, and recovery guidance.
  Preserve approval requirements, stop conditions, secret handling, and scope.

## Non-goals

No version field, description shortening, Purpose/resources sections,
reference restructuring, script changes, new dependencies, installation changes,
or remote operations. Keep Bash and PowerShell guidance intact. Do not remove
valid content to satisfy evaluator heuristics. No behavioral benchmark is run.

## Assumptions and prerequisites

The existing lifecycle contracts remain authoritative: Specs 001, 002, 003,
005, 011, 018, and 029, with their amendments. The project Conda environment
is used for structural checks. The separately installed SkillEvaluator 0.9.0
environment runs quality-check; it needs no API key for this command.

The [Agent Skills specification](https://agentskills.io/specification), reviewed
2026-11-13, defines optional metadata as a string-to-string mapping. Author and
tags are descriptive metadata, not new invocation or authorization controls.
SkillEvaluator's top-level version recommendation is outside this change.

## Acceptance criteria

1. All seven skills contain the agreed author and operation-specific tags.
2. Each has a troubleshooting table grounded in existing instructions, with
   no new commands, permissions, retry behavior, or unsupported remedies.
3. Existing names, descriptions, workflow sections, references, templates,
   scripts, and shell support are preserved.
4. Structural validation and relevant existing skill tests pass.
5. Rerun quality-check on all seven skills and record actual before/after
   scores. A scores are expected, but do not override content correctness.

## Verification approach

Run the skill-creator quick validator and the existing skill-content tests
offline. Review the diff and local links. Run SkillEvaluator 0.9.0 with its
packaged default quality configuration (threshold 70), saving JSON, HTML, and
Markdown reports outside this repository. Compare with the 2026-11-13 baseline:
build 87.2, deploy 86.0, new 88.5, push 90.8, teardown 87.5, ui 92.2,
verify-deployment 87.5. No cloud credentials or tool `.env` content is needed.

## Verification results

2026-11-13, macOS arm64:

* Added the agreed metadata and three troubleshooting cases per skill; no
  existing instructions or descriptions changed. Updated the root changelog.
* Project Conda Python 3.11.17: `pytest -q tests/test_skills.py` passed all
  17 tests, including local references and existing authorization invariants.
* The skill-creator `scripts/quick_validate.py` passed for all seven skills,
  using the same project interpreter. `git diff --check` passed. Manual diff
  review confirmed that existing workflow and shell instructions are intact.
* SkillEvaluator 0.9.0, separate Conda Python 3.13.18, packaged default quality
  configuration and threshold 70: all seven quality-check commands exited 0.
  Author, tags, and troubleshooting findings are absent from the new reports.

| Skill | Baseline | After priority 1 | Grade |
| --- | --- | --- | --- |
| oci-agent-build | 87.2 | 92.0 | A |
| oci-agent-deploy | 86.0 | 90.8 | A |
| oci-agent-new | 88.5 | 93.2 | A |
| oci-agent-push | 90.8 | 95.5 | A |
| oci-agent-teardown | 87.5 | 92.2 | A |
| oci-agent-ui | 92.2 | 97.0 | A |
| oci-agent-verify-deployment | 87.5 | 92.2 | A |

External reports are retained in the evaluator checkout's
`reports/oci-agent-shipyard-priority1-20261113-172807/`, with one subdirectory
per skill containing `skillevaluator-quality.json`, `.html`, and `.md`.
Reproduce from that checkout using the installed `skillevaluator` environment:

```bash
conda run --no-capture-output -n skillevaluator skillevaluator quality-check \
  /path/to/oci-agent-shipyard/skills/oci-agent-build \
  -r json -r html -r markdown -o /path/to/external-reports/oci-agent-build
```

Repeat for each skill. Existing version, description, reference, resource,
Purpose-heading, and Windows-path findings were deliberately retained.
The new skill's size estimate increased from 5048 to 5220 characters/4 tokens;
the existing size penalty remains unchanged. These results establish static
documentation quality under this evaluator configuration only. Full security
scanning, agent behavior, and remote OCI execution were not evaluated.
