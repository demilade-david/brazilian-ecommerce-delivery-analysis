# Brazilian E-Commerce Data Analysis (Olist)

An end-to-end data cleaning and exploratory analysis project using the
[Olist Brazilian E-Commerce dataset](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce),
covering 9 raw datasets and ~1 million+ rows across orders, payments,
reviews, products, and geolocation.

**Author:** Okunowo Oluwademilade David
**Date:** 2026-07-27

## Project Overview

This project takes Olist's raw, real-world transactional data through a
full pipeline: diagnosing data quality issues, cleaning and merging 9
separate tables into one order-level master table, and running a
statistically-backed exploratory analysis to answer a specific business
question — in both **Python** and **SQL**, to validate findings across tools.

**Core question investigated:** *Does delivery delay affect customer
review scores — and if so, does that effect vary by product category?*

## Key Findings

- Orders delivered **late** received an average review score of **2.27**,
  compared to **4.29** for orders delivered **early** — a drop of nearly
  2 points on a 5-point scale.
- This difference is statistically significant (ANOVA p < 0.001,
  t-test p < 0.001), not due to chance.
- The correlation between raw delay (in days) and review score is
  moderate (r = -0.267), indicating delivery timing is a meaningful but
  not sole driver of customer satisfaction.
- The effect is broadly consistent across product categories (drop
  ranging roughly 1.4–2.3 points across categories), suggesting delivery
  reliability is a near-universal driver of satisfaction rather than a
  category-specific issue.
- These findings were independently validated in PostgreSQL, producing
-  results consistent with the Python analysis.
-   📄 **Full written report:** [Report/olist report.pdf](Report/olist report.pdf) 
## Repository Structure
├── data/
│ ├── raw/ # not included — see Data Source below
│ └── cleaned/ # not included — reproducible via 01_cleaning.ipynb
├── notebooks/
│ ├── 01_cleaning.ipynb # data quality diagnosis + cleaning pipeline
│ └── 02_eda_delivery_delay.ipynb # delivery delay vs review score analysis
├── sql/
│ ├── 01_create_tables.sql # schema definitions for all tables
│ ├── 02_data_cleaning.sql # SQL-based cleaning (e.g. review deduplication)
│ └── 03_eda_analysis.sql # SQL queries validating the Python findings
└── README.md
├── reports/
│   └── olist_delivery_report.pdf     # full business report with recommendations
## Notebooks

**`01_cleaning.ipynb`** — Loads all 9 raw datasets, runs a structured
before/after data quality report on each (row counts, nulls, duplicates),
and resolves issues including duplicate reviews, contradictory order
statuses, out-of-bounds geolocation coordinates, and missing product
categories. Outputs one clean, order-level master table
(`olist_master_cleaned.csv`, not committed to this repo — see Data Source).

**`02_eda_delivery_delay.ipynb`** — Loads the cleaned master table,
calculates delivery delay per order, and tests whether delay predicts
review score using visualizations (bar chart), statistical tests (ANOVA,
t-test, Pearson correlation), and a category-level breakdown.

## SQL

**`01_create_tables.sql`** — Recreates the relational structure of the
raw dataset (orders, customers, order_items, order_payments,
order_reviews, products, product_category_name_translation) as separate
PostgreSQL tables, rather than a single flattened table — to allow
genuine joins, CTEs, and window functions.

**`02_data_cleaning.sql`** — Deduplicates `order_reviews` using a
`ROW_NUMBER() OVER (PARTITION BY ...)` window function, mirroring the
pandas cleaning logic used in the Python notebook.

**`03_eda_analysis.sql`** — Calculates delivery delay per order and
answers the same core question as the Python EDA, using joins and CTEs,
independently validating the Python findings.

## Tools & Skills Used

- **Python** — pandas, NumPy, SciPy, Matplotlib
- **SQL** — PostgreSQL, CTEs, window functions, joins, aggregations
- **Data cleaning** — null handling, duplicate detection, outlier
  detection, referential integrity checks, cross-column consistency checks
- **Statistics** — ANOVA, independent t-test, Pearson correlation
- **Data storytelling** — structured notebooks with markdown narrative,
  plain-English conclusions for non-technical readers

## Data Source

Raw CSVs and the cleaned master table are **not included** in this
repository due to file size. To reproduce this project:

1. Download the original dataset from
   [Kaggle: Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce)
2. Place the raw CSVs in `data/raw/`
3. Run `notebooks/01_cleaning.ipynb` to generate the cleaned master table
4. Run `notebooks/02_eda_delivery_delay.ipynb` for the full analysis
  results consistent with the Python analysis.
## Report

`reports/olist_delivery_report.pdf` — a full written business report covering
background, methodology, findings, statistical validation, and prioritized
recommendations, written for a non-technical business audience.

## Repository Structure
