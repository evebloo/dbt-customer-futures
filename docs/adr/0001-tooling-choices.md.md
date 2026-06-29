# ADR 0001 — Tooling choices

**Status:** Accepted
**Date:** 2026-06-29

## Context

This repo is a public practice project to build fluency in dbt and the canonical analytics-engineering pattern. It must:

- Run entirely on portable open data (the Olist Kaggle dataset).
- Be reproducible by anyone with `uv` and Python 3.11+ — no proprietary infra, no cloud accounts.
- Follow the standard layered modelling pattern (`source → staging → marts → tests → docs`).
- Be small enough to defend every line cold in an interview.

## Decision

| Concern | Choice | Why |
|---|---|---|
| Warehouse | **DuckDB** (`dbt-duckdb`) | Zero infra. File-based. Free. The default for portable dbt portfolio repos. BigQuery comes in a separate repo (`bq-patterns-playground`) where the point *is* BQ-specific patterns. |
| Python env | **uv** | Fast, lockfile-based, single tool for venv + deps. Also a Tier 4 ramp item — using it here closes that gap in passing. |
| dbt version | **dbt-core 1.11+** | Latest stable. |
| Repo layout | **`dbt/` subfolder, not flattened** | Clean separation between the dbt project and the Python package. Avoids `tests/` collision between dbt and pytest. Defensible: "the dbt project and the Python package are independent components." |
| Profile location | **`profiles.yml` at repo root** | Reproducible — anyone cloning the repo gets the same profile. Trade-off: every dbt command needs `--project-dir dbt --profiles-dir .`. The Makefile hides that. |
| Task runner | **Makefile** | One-line aliases for the common dbt commands. Self-documenting via `make help`. No new dependency. |
| Python layout | **`src/`-layout package + `tests/`** | Modern Python standard. Forces explicit installs, prevents implicit path imports. |
| Data | **Not committed** | Olist CSVs are 100MB+ and freely available from Kaggle. README documents how to download. Keeps the repo small. |

## Alternatives considered

- **BigQuery as the warehouse.** Would require a personal GCP project, billing setup, and `gcloud` auth — friction that adds nothing to the dbt-pattern learning goal. Deferred to a separate repo.
- **Flatten dbt to repo root.** Cleaner for a dbt-only repo, but this repo has a Python bolt-on. Flattening would create a `tests/` collision (dbt data tests vs. pytest) and muddle the two component boundaries.
- **Poetry instead of uv.** uv is faster, simpler, and on the ramp anyway.
- **Pre-commit hooks.** Skipped for now — will add when the repo has enough Python code to justify the overhead.

## Consequences

- Every dbt invocation goes through the Makefile (or types out `--project-dir dbt --profiles-dir .`).
- Anyone cloning needs `uv` installed — common enough to be reasonable.
- DuckDB-specific SQL (e.g. `READ_CSV_AUTO`) may need adaptation if this is ever ported to another warehouse — but that's not a goal.