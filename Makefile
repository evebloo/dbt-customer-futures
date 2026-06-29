.PHONY: help debug deps seed build test docs clean fmt py-test

DBT := uv run dbt
DBT_FLAGS := --project-dir dbt --profiles-dir .

help:
	@echo "Targets:"
	@echo "  debug    - dbt debug (verify profile + connection)"
	@echo "  deps     - dbt deps (install dbt packages)"
	@echo "  seed     - dbt seed (load CSVs from dbt/seeds/)"
	@echo "  build    - dbt build (run + test everything)"
	@echo "  test     - dbt test (run data tests only)"
	@echo "  docs     - dbt docs generate + serve"
	@echo "  clean    - dbt clean (remove target/ and dbt_packages/)"
	@echo "  fmt      - ruff format the Python package"
	@echo "  py-test  - pytest for the Python package"

debug:
	$(DBT) debug $(DBT_FLAGS)

deps:
	$(DBT) deps $(DBT_FLAGS)

seed:
	$(DBT) seed $(DBT_FLAGS)

build:
	$(DBT) build $(DBT_FLAGS)

test:
	$(DBT) test $(DBT_FLAGS)

docs:
	$(DBT) docs generate $(DBT_FLAGS)
	$(DBT) docs serve $(DBT_FLAGS)

clean:
	$(DBT) clean $(DBT_FLAGS)

fmt:
	uv run ruff format src tests

py-test:
	uv run pytest
