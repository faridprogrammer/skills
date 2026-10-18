---
name: research
description: Tiered open-access research (Quick, Standard, Deep) across academic APIs, official docs, the web, and open source. Produces a read-focused Markdown bundle at publish/report.md plus optional workspace artifacts. Use for literature reviews, deep dives, API or docs facts, finding papers, or background research.
argument-hint: "[topic or question] [quick|standard|deep]"
---

# Research

Investigate a topic using **openly accessible** sources. Deliver a **reading bundle** the user can open in Obsidian (or any Markdown reader): narrative content only in `publish/`, working files in `workspace/`.

## When to use

- Literature review, survey, state of the art, related work
- Product, API, or framework questions (official docs first)
- Find papers and synthesize findings
- Deep multi-phase academic review (Deep tier)

## Start ritual

1. **Topic or question** — restate in one sentence.
2. **Tier** — Quick, Standard, or Deep. Default **Standard** if unclear.
3. **Slug** — kebab-case directory name (e.g. `long-context-agents`).
4. **Output root** — `./research-output/{slug}/` unless the repo already stores research notes elsewhere (match that convention).

Create directories:

```
research-output/{slug}/
├── workspace/     # search results, phases, JSONL (audit trail)
└── publish/       # report.md (+ references.bib) for reading
```

## Open-access policy

- **Read full text** only from open access: arXiv, ar5iv HTML, Semantic Scholar `openAccessPdf`, publisher OA links, official docs, public repos.
- **Paywalled papers** — use title, abstract, and metadata only; mark as not fully read.
- **Preprints** — cite with `(preprint)` when not peer-reviewed.
- **Web** — treat blogs and news as secondary unless they are the primary source (e.g. release notes).

## Source playbook

| Source | Tools | Tiers |
|--------|-------|-------|
| Academic | `scripts/search_semantic_scholar.py`, `search_arxiv.py`, `search_openalex.py`, `search_crossref.py`, `paper_db.py merge` | Standard, Deep |
| Official docs | `WebSearch` + `WebFetch` (vendor docs, RFCs, specs) | All |
| General web | `WebSearch` + `WebFetch` | Standard, Deep; Quick when needed |
| Open source | GitHub, Papers with Code (`WebSearch`) | Standard (encouraged), Deep (required Phase 4) |

**Scripts** — from the installed skill directory:

```bash
python scripts/search_openalex.py --query "QUERY" --max-results 20 -o workspace/results_openalex.jsonl
```

When the skill lives in this repo: `python skills/research/scripts/<script>.py` from the repo root.

**Semantic Scholar API key** (optional): set `SEMANTIC_SCHOLAR_API_KEY`; pass `--api-key` or rely on env if the script supports it.

**No Bash** — use `WebSearch` / `WebFetch` per [references/api-reference.md](references/api-reference.md).

## Execution model

| Tier | Where it runs |
|------|----------------|
| **Quick** | Inline in the main session |
| **Standard**, **Deep** | Background **Task** agent; print checkpoints when each major step finishes |

## Tier summary

See [references/tiers.md](references/tiers.md) for gates and when to escalate.

### Quick (inline)

For narrow questions with 1–3 **primary** sources (docs, spec, source code).

1. Fetch and read primary sources; follow claims to the owning document.
2. Write **`publish/report.md`** only (short): title, date, executive summary, findings, numbered references with URLs.
3. Optional: `workspace/sources.jsonl` for traceability.

### Standard (Task)

Broad topic synthesis without the full six-phase pipeline.

1. Expand the query into 2–4 search strings.
2. Run academic scripts; merge to **`workspace/paper_db.jsonl`** (target ~15–35 papers).
3. Rank: citations, recency, venue, relevance. See venue tiers in [references/tiers.md](references/tiers.md).
4. **Read full text** for top **3–5** open-access papers (ar5iv or OA PDF).
5. Web + official docs + OSS pass; capture in **`workspace/synthesis.md`**.
6. Polish into **`publish/report.md`** + **`publish/references.bib`** (`bibtex_manager.py`). No phase checklists or JSONL in `publish/`.

### Deep (Task)

Strict **6-phase** workflow; all phase outputs under **`workspace/`**. Do not skip phases or write `publish/report.md` before gates pass.

| Phase | Gate (summary) |
|-------|----------------|
| 1 → 2 | `workspace/phase1_frontier/frontier.md` with ≥10 papers |
| 2 → 3 | `workspace/phase2_survey/survey.md`, `workspace/paper_db.jsonl` with 35–80 papers |
| 3 → 4 | `workspace/phase3_deep_dive/deep_dive.md` with ≥8 full paper notes |
| 4 → 5 | `workspace/phase4_code/code_repos.md` with ≥3 repos |
| 5 → 6 | `workspace/phase5_synthesis/synthesis.md` + `gaps.md` |

After Phase 5:

```bash
python scripts/compile_report.py --topic-dir ./research-output/{slug}/
```

Then **edit** `publish/report.md` into a clean reading narrative (remove raw stats dumps and workspace scaffolding if the compiler included them). Details: [references/workflow-phases.md](references/workflow-phases.md), [references/note-format.md](references/note-format.md).

**Phase checkpoints** (Deep only):

```
✅ Phase N complete. Output: [files]. Proceeding to Phase N+1.
```

## Publish bundle (read-only reading)

`publish/report.md` must be suitable for **reading view**:

- Title, date, one-paragraph executive summary
- Table of contents (linked headings)
- Narrative sections with numbered citations `[1]`
- References section at the end
- **Exclude**: agent checklists, JSONL, merge logs, internal phase labels

## Writing style: simple English

Write the final report and reader-facing notes in clear, simple English. Keep the research accurate and precise, but make it easy to read for someone who is not a specialist.

- Prefer common words and short sentences.
- Explain technical terms the first time they appear; avoid unexplained jargon and unnecessary abbreviations.
- Put the main point first, then add the evidence and important limits.
- Use active voice and concrete examples when they improve understanding.
- Keep paragraphs focused on one idea. Use headings and bullets when they make the information easier to scan.
- Replace dense academic wording with direct wording. For example, write “The evidence is mixed” instead of “The findings demonstrate substantial heterogeneity.”
- Preserve uncertainty, disagreements, and source limitations. Simpler language must not make claims sound stronger than the evidence supports.
- Apply this style to `publish/report.md` and any reader-facing summaries. Internal workspace files may keep technical detail needed for auditability.

`publish/references.bib` when academic citations are used.

## Paper quality (Deep and Standard)

Peer-reviewed venues rank above arXiv-only preprints. Mark `(preprint)` when citing unreviewed work.

**Paper IDs**: `arxiv_id` or Semantic Scholar `paperId`.  
**Workspace citations**: `[@cite_key]` in notes; compiler maps to `[N]` in the report.

## Script reference

| Script | Purpose |
|--------|---------|
| `search_semantic_scholar.py` | S2 search, BibTeX-friendly |
| `search_arxiv.py` | Recent preprints |
| `search_openalex.py` | Broad catalog, no key |
| `search_crossref.py` | DOI metadata |
| `paper_db.py` | merge, filter, stats, tag |
| `download_papers.py` | OA PDFs from JSONL |
| `download_arxiv_source.py` | arXiv source |
| `extract_pdf.py` | PDF text (PyMuPDF) |
| `bibtex_manager.py` | `.bib` from JSONL |
| `compile_report.py` | workspace → `publish/report.md` |

## References

- [references/tiers.md](references/tiers.md) — Quick / Standard / Deep gates
- [references/workflow-phases.md](references/workflow-phases.md) — Deep phase guide
- [references/note-format.md](references/note-format.md) — Note and publish templates
- [references/api-reference.md](references/api-reference.md) — APIs and ar5iv
