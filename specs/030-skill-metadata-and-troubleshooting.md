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

## Agent Skills format validation

2026-11-13 follow-up scope: expose the completed reference-validator check
through a README badge labeled `Agent Skills | skills-ref validated`, linking
to this evidence. This is a static badge for an observed local check, not a
CI status or an independent certification. No CI workflow, dependency, or skill
content change is included. Acceptance: the badge renders in the existing badge
group and its link resolves to this section; the wording describes only the
validation actually performed.

All seven skills passed the `skills-ref validate` CLI with exit code 0, using
skills-ref 0.1.0 from the official
[reference implementation](https://github.com/agentskills/agentskills/tree/83021e2be457a9b6679148719c1f6074f0ad975e/skills-ref),
commit `83021e2be457a9b6679148719c1f6074f0ad975e`, under Python 3.11.17 in an
isolated temporary virtual environment. Each invocation printed `Valid skill`.
The project files and Python environments were not modified by validation.

To reproduce, clone that repository, check out the recorded commit, create a
virtual environment with Python 3.11 or later, and install its `skills-ref`
subdirectory as documented in its README. From the shipyard checkout, run with
that environment active:

```bash
for skill in skills/oci-agent-*; do
  skills-ref validate "$skill" || exit
done
```

The validator checks frontmatter parsing, allowed fields, required name and
description, naming conventions and folder-name match, and compatibility-field
constraints when present. It does not establish operational behavior, security,
or OCI compatibility. The published
[Agent Skills specification](https://agentskills.io/specification) remains the
format authority; the reference implementation describes itself as a
demonstration library.

Badge verification (2026-11-13): Shields.io returned the badge SVG successfully;
its accessible label is `Agent Skills: skills-ref validated`. Reviewed the
README target file and section anchor, and `git diff --check` passed. This is
a documentation-only change; no Python source, skill, or remote OCI operation
changed.
