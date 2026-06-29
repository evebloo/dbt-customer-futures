# dbt-customer-futures

A dbt + DuckDB repo modelling **customer futures** (next-order, churn risk, lifetime value) on the public [Olist Brazilian e-commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).

Built to practice the canonical analytics-engineering pattern — `source → staging → marts → tests → schema docs → README` — on portable open data.

## Why this repo exists

- Practice the dbt modelling pattern end-to-end on data I can publish.
- Pair it with a small Python package (`src/customer_futures/`) for the bits that don't belong in SQL (OOP modelling, pytest, type hints).
- Ship public artifacts (ADRs, AI usage log, README) that demonstrate judgment, not just code.

See [`docs/adr/`](docs/adr/) for the architectural decisions and the reasoning behind each one.

## Repo layout

```
.
├── dbt/                 # dbt project (DuckDB target)
│   ├── dbt_project.yml
│   ├── models/
│   │   ├── staging/
│   │   └── marts/
│   ├── seeds/
│   ├── tests/
│   ├── macros/
│   └── snapshots/
├── src/customer_futures/  # Python package (OOP + pytest bolt-on)
├── tests/                 # pytest for the Python package
├── data/raw/              # Olist CSVs (downloaded from Kaggle, not committed)
├── docs/adr/              # Architecture Decision Records
├── profiles.yml           # dbt profile (target=dev, DuckDB)
├── pyproject.toml         # uv project
└── Makefile               # task runner (see `make help`)
```

## Setup

Requires [`uv`](https://github.com/astral-sh/uv) and Python 3.11+.

```bash
# Install dependencies
uv sync

# Verify dbt connection
make debug
```

If `make debug` reports `All checks passed!`, you're set up.

## Data

The Olist dataset is not committed to the repo. To get it:

1. Download from [Kaggle](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce).
2. Unzip into `data/raw/`.
3. Run `make seed` (TBD seed config will load CSVs from `data/raw/` into DuckDB).

## Common commands

```bash
make debug   # verify dbt profile + connection
make seed    # load Olist CSVs into DuckDB
make build   # run all models + tests
make test    # run data tests only
make docs    # generate + serve dbt docs
make py-test # run pytest for the Python package
```