# Research workflow: Deep tier (six phases)

**CRITICAL: Execute ALL 6 phases in strict order (1→2→3→4→5→6). NEVER skip any phase.**

All phase outputs live under `./research-output/{slug}/workspace/`. The reading bundle is `./research-output/{slug}/publish/`.

Scripts are relative to the skill: `python scripts/<name>.py` (or `skills/research/scripts/` from this repo).

## Phase 1: Frontier

### Objective

Identify the **latest breakthroughs** and trending directions before broadening the search.

### Output location

`workspace/phase1_frontier/`

### Steps

1. **Search** (save JSONL under `workspace/phase1_frontier/search_results/`):
   - Semantic Scholar with recent year range and `--top-conferences` when available
   - arXiv for last 3–6 months
   - WebSearch: `"{topic} NeurIPS accepted"`, `"{topic} ICML oral"` (use results to refine queries)
2. **Merge** into a working set; note counts in `frontier.md`.
3. **Write** `workspace/phase1_frontier/frontier.md`:
   - Key recent papers (title, venue, one-line summary)
   - Trending directions (3–5 themes)
   - Active research groups

### Gate → Phase 2

`frontier.md` exists and lists ≥10 papers.

---

## Phase 2: Survey

### Objective

Build a landscape of **35–80 relevant papers**.

### Output location

`workspace/phase2_survey/`

### Steps

1. Run broader searches (2023–present typical); save to `workspace/phase2_survey/search_results/`:
   - Semantic Scholar (`--peer-reviewed-only` where appropriate)
   - arXiv, OpenAlex, optional CrossRef
2. **Merge and deduplicate**:

```bash
python scripts/paper_db.py merge \
  --inputs workspace/phase1_frontier/search_results/*.jsonl workspace/phase2_survey/search_results/*.jsonl \
  --output workspace/paper_db.jsonl
```

3. **Filter** to 35–80 papers:

```bash
python scripts/paper_db.py filter \
  --input workspace/paper_db.jsonl -o workspace/paper_db.jsonl \
  --min-score 0.80 --max-papers 70 \
  --keywords <topic keywords>
```

4. Cluster by theme; write `workspace/phase2_survey/survey.md`.

### Gate → Phase 3

`survey.md` exists AND `workspace/paper_db.jsonl` has 35–80 papers.

---

## Phase 3: Deep dive

**MANDATORY.** Read 8–15 papers in full (open access only).

### Output location

`workspace/phase3_deep_dive/`

1. Select papers → `selection.md` with rationale.
2. Download OA PDFs:

```bash
python scripts/download_papers.py --jsonl workspace/paper_db.jsonl \
  --output-dir workspace/phase3_deep_dive/papers/ --sort-by-citations --max-downloads 15
```

3. Read via `Read` on PDF or `WebFetch` on `https://ar5iv.labs.arxiv.org/html/{arxiv_id}`.
4. Structured notes per [note-format.md](note-format.md) → `deep_dive.md`.

### Gate → Phase 4

`deep_dive.md` has detailed notes for ≥8 papers (methodology + experiments filled in).

---

## Phase 4: Code and tools

**MANDATORY.** Map open-source implementations.

### Output location

`workspace/phase4_code/code_repos.md` (≥3 repositories with URL, stars, language, last updated).

### Gate → Phase 5

`code_repos.md` exists with ≥3 repos.

---

## Phase 5: Synthesis

Requires Phase 3 and 4 complete.

### Output location

`workspace/phase5_synthesis/synthesis.md`, `workspace/phase5_synthesis/gaps.md`

Taxonomy, comparative tables, timeline, gap analysis (templates in [note-format.md](note-format.md)).

### Gate → Phase 6

Both synthesis files exist and are substantive.

---

## Phase 6: Compile to publish

Verify all prior phase files exist. Then:

```bash
python scripts/bibtex_manager.py --jsonl workspace/paper_db.jsonl --output publish/references.bib
python scripts/compile_report.py --topic-dir ./research-output/{slug}/
python scripts/paper_db.py stats --input workspace/paper_db.jsonl
```

Edit `publish/report.md` for reading: remove internal scaffolding, add TOC and executive summary per [note-format.md](note-format.md#publish-report-template-reading-bundle).

**Do not** leave phase checklists or raw statistics blocks in `publish/` unless the user wants them.
