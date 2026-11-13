# Skill validation report: OCI Agent Shipyard

**Date:** 2026-11-13 · **Scope:** seven repository skills · **Author:** L. Saetta

The seven skills of [OCI Agent Shipyard](https://github.com/luigisaetta/oci-agent-shipyard)
passed two complementary checks: NVIDIA SkillEvaluator's deterministic
documentation-quality assessment and the Agent Skills reference format
validator. Following small documentation improvements, every skill achieved
grade A in SkillEvaluator; every skill also passed `skills-ref validate`.

## 1. NVIDIA SkillEvaluator

[SkillEvaluator](https://github.com/NVIDIA/SkillEvaluator) is an open-source
framework with three levels: static validation and security checks; semantic
overlap analysis; and live agent evaluation comparing tasks with and without
a skill. Its support status is experimental. See the
[NVIDIA documentation](https://docs.nvidia.com/skills/skillevaluator/).

We executed **only `quality-check`**, a deterministic documentation-quality
check within Tier 1. This does not execute the complete Tier 1 security suite
or Tiers 2 and 3. No LLM, API key, Docker workload, or OCI operation was needed.

The local setup was macOS arm64, Python 3.13.18, and SkillEvaluator **0.9.0**,
installed separately from the project. The source revision was
[`f62ab6e`](https://github.com/NVIDIA/SkillEvaluator/commit/f62ab6e248fb857ab7b7d87ba78b2f7fc1fcc884).
We used the packaged default configuration: pass threshold 70/100 and
grade A from 90/100. The composite weights were correctness 35%,
discoverability 25%, reliability 25%, and efficiency 15%; these labels describe
static heuristics, not observed operational performance.

## 2. Findings, changes, and results

The baseline identified missing author/tag metadata and troubleshooting
sections across all seven skills. Other findings concerned descriptions,
reference chains, resource documentation, heading names, Windows paths, and
the size of `oci-agent-new`.

We implemented only the agreed first-priority changes: `metadata.author`,
operation-specific `metadata.tags` stored as strings, and three concise
troubleshooting cases per skill. Existing commands, descriptions, authorization
boundaries, and Bash/PowerShell workflows were preserved.

| Skill | Baseline | After changes | Final grade |
| --- | ---: | ---: | :---: |
| `oci-agent-build` | 87.2 | 92.0 | A |
| `oci-agent-deploy` | 86.0 | 90.8 | A |
| `oci-agent-new` | 88.5 | 93.2 | A |
| `oci-agent-push` | 90.8 | 95.5 | A |
| `oci-agent-teardown` | 87.5 | 92.2 | A |
| `oci-agent-ui` | 92.2 | 97.0 | A |
| `oci-agent-verify-deployment` | 87.5 | 92.2 | A |

All seven evaluations exited 0. The existing 17 skill tests and the local
skill-creator structural validator also passed. JSON, HTML, and Markdown
reports were retained outside the project; reproducibility details and their
locations are recorded in [Spec 030](../specs/030-skill-metadata-and-troubleshooting.md).

## 3. Agent Skills specification and reference validation

We reviewed the [Agent Skills specification](https://agentskills.io/specification)
and checked the seven skills' structure, YAML frontmatter, name/folder match,
description lengths, and string-valued metadata. Descriptions remained within
the standard's 1,024-character limit. Metadata is optional; the standard shows
version information under `metadata.version`, rather than requiring a top-level
`version` field. Evaluator recommendations therefore require interpretation.

We then ran the official repository's
[`skills-ref` reference implementation](https://github.com/agentskills/agentskills/tree/83021e2be457a9b6679148719c1f6074f0ad975e/skills-ref),
version **0.1.0**, revision `83021e2`, in a temporary Python 3.11.17 environment:

```bash
skills-ref validate skills/<skill-name>
```

**All seven returned `Valid skill` and exit code 0.** The validator checks
frontmatter and naming constraints; the repository describes it as a
demonstration library. The README badge consequently says
**“Agent Skills — skills-ref validated”**, linked to the recorded evidence.

## 4. Interpretation and limits

The evidence supports format validation and improved static documentation
quality. It does not establish security certification, agent effectiveness,
or OCI runtime compatibility. Windows-path warnings were retained because
PowerShell support is intentional. Longer descriptions and reference chains
remain review opportunities; `oci-agent-new` exceeds the recommended token
budget under the evaluator's character-based estimate. The skills also depend
on the surrounding Shipyard scripts and resources. Behavioral evaluation and
live OCI verification remain separate activities.
