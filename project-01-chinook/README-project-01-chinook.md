# 🎵 Chinook Music Store — SQL Business Analysis

**First project in my Data Engineering learning journey.** The goal: use pure SQL to answer real business questions for a fictional digital music store, as if I were the first data hire helping the sales and management teams make decisions.

---

## 📌 Business context

Chinook is a digital music store (similar to an early iTunes). In this project, I take on the role of a data professional asked to answer two concrete business questions:

1. Which artists, genres, and tracks should the company invest in / license more of?
2. Which sales employees are actually driving revenue, ahead of upcoming contract renewals?

---

## 🗂️ Dataset

- **Chinook Database** — a widely-used sample relational database for SQL practice, modeling a real music store (customers, invoices, tracks, albums, artists, genres, employees, playlists).
- Source: [github.com/lerocha/chinook-database](https://github.com/lerocha/chinook-database)
- ~15,000 rows across 11 relational tables.

## 🛠️ Tools

- **PostgreSQL** — database engine
- **VS Code + SQLTools** — writing and running queries
- **Git & GitHub** — version control and portfolio hosting

---

## ❓ Business questions & approach

Each question was answered in its own `.sql` file under `/queries`, following the same process every time: explore the relevant tables first, identify the join path, write the query, and interpret the result in plain business language.

| # | Question | File |
|---|---|---|
| 1 | Top 10 best-selling tracks by revenue and their artists | `01_top_tracks.sql` |
| 2 | Which genre generates the most revenue vs. most units sold | `02_top_genre_revenue.sql` |
| 3 | Top 5 customers by total spend and their country | `03_top_customers.sql` |
| 4 | Which sales employee drives the most revenue | `04_employee_sales.sql` |
| 5 | Monthly revenue trend over the full dataset | `05_monthly_revenue_trend.sql` |
| 6 | Average invoice value by country | `06_avg_invoice_by_country.sql` |
| 7 | Track that appears on the most playlists | `07_most_playlisted_track.sql` |
| 8 | Ranking each employee's customers by spend (window function) | `08_employee_customer_ranking.sql` |

---

## 💡 Key findings

- **Rock is the dominant genre** in both total revenue (**$826.65**) and units sold (**835 units**) — consistent with it having the largest track catalog and broad popularity, leading in both volume and value.
- The top-selling tracks are concentrated among a small group of artists, suggesting the catalog has clear "anchor" artists worth prioritizing for licensing.
- **[CHILE]** — Country with highest average spend per order (query 06 result - AVG).
- **[Jane]** — Top 1 employee in total revenue generated (query 04), and how many clients he serves (query bonus).
- Monthly revenue stayed relatively flat across the analyzed period (no clear growth or decline trend), which suggests the business would benefit from a growth-focused initiative rather than just optimizing what already exists.
- **[...]** — Track present in more playlists (query 07) and its interpretation of what makes a song "playlist-friendly".

---

## 🧠 Skills practiced

- Multi-table `JOIN`s across 4–5 related tables
- Aggregations (`SUM`, `COUNT`, `AVG`) tied to real business metrics
- `GROUP BY` with correct grain (avoiding duplicated/inflated results)
- Window functions (`RANK() OVER (PARTITION BY ...)`) to rank values *within* a group
- CTEs (`WITH`) to structure multi-step logic
- Translating an English business question into a working SQL query, then translating the result back into a plain-language business insight

---

## 📁 Repository structure

```
project-01-chinook/
├── README.md
├── data/            # dataset source / import instructions
├── setup/           # database creation & load scripts
└── queries/         # one .sql file per business question, each documented
```

## ▶️ How to reproduce


1. Install PostgreSQL locally (or use a free hosted instance).
2. Open pgadmin4 or other hosted instance
3. create a database with the name you want, recommend use chinook
4. Run the Chinook creation script from `/setup` to build the tables and put in all the data.
5. Run any file inside `/queries` — each is self-contained and commented with the reasoning behind it.

---

## 🚀 About this project

This is the first of a series of SQL/data engineering projects I'm building while transitioning into Data Engineering. Feedback and suggestions are very welcome!
