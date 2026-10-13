# Research tiers

## Choosing a tier

| Situation | Tier |
|-----------|------|
| Single API, doc page, or spec answers the question | **Quick** |
| Topic survey, mixed academic + web, no thesis-length review | **Standard** |
| Systematic literature review, gap analysis, 35+ paper corpus | **Deep** |

Escalate **Quick → Standard** when sources disagree or the question spans multiple domains.  
Escalate **Standard → Deep** when the user needs exhaustive related work, reproducibility mapping, or publication-quality survey.

## Quick

**Goal**: Correct answer from primary sources fast.

**Outputs**

- `publish/report.md` (required)
- `workspace/sources.jsonl` (optional)

**Quality**

- Every factual claim has a URL or file path citation.
- Prefer official docs and specs over blog posts.

## Standard

**Goal**: Balanced landscape with evidence-backed synthesis.

**Outputs**

- `workspace/paper_db.jsonl` (~15–35 papers after filter)
- `workspace/synthesis.md` (working synthesis)
- `workspace/search_results/*.jsonl` (optional)
- `publish/report.md`, `publish/references.bib`

**Reading requirement**

- Full-text read of **3–5** open-access papers (not abstract-only).

**Academic workflow**

1. Expand query to 2–4 variants.
2. Run Semantic Scholar (primary), arXiv (recent), OpenAlex (breadth); optional CrossRef.
3. `paper_db.py merge` then filter/rank.
4. WebSearch for docs, standards, and key implementations.

**Ranking weights** (manual or heuristic): citations 0.3, recency 0.3, venue 0.2, relevance 0.2.

## Deep

**Goal**: Six-phase systematic review; paths live under `workspace/`.

**Paper corpus**: 35–80 in `workspace/paper_db.jsonl`.  
**Deep read**: 8–15 papers; ≥8 with methodology and experiments in `deep_dive.md`.  
**Code**: ≥3 repositories in `phase4_code/code_repos.md`.

Do not compile to `publish/` until Phase 5 gates pass. See [workflow-phases.md](workflow-phases.md).

## Venue quality tiers

**Tier 1:** NeurIPS, ICML, ICLR, ACL, EMNLP, NAACL, CVPR, ICCV, ECCV, KDD, AAAI, IJCAI, SIGIR, WWW  
**Tier 2:** AISTATS, UAI, COLT, COLING, EACL, WACV, JMLR, TACL  
**Tier 3:** Workshops, arXiv — mark `(preprint)` when not peer-reviewed
