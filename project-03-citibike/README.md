# Citi Bike: Where Should Bikes Be Rebalanced Overnight?

**Project 3 in my learning path toward a career in Data Engineering.** A SQL investigation of about 5 million bike-share trips: which stations run out of bikes, when the demand peaks, and where the operations team should move bikes overnight.

---

## Summary

I analyzed 4,982,855 Citi Bike trips from August 31 to September 30, 2026, using SQL on DuckDB. Departures peak at 17h and 18h on weekdays, and a small group of stations loses more bikes than it receives, day after day. The five stations with the largest month deficit are E 39 St & Lexington Ave, E 33 St & Park Ave, Willoughby Ave & Hall St, E 39 St & 2 Ave and E 51 St & 2 Ave. [FILL IN: one sentence with the number that confirms they are consistent, for example "each one is in deficit on X% of the days"].

## Business context

Citi Bike is a bike-share system where riders pick up a bike at one station and return it at another. Because people ride mostly in one direction at some hours, some stations fill up while others run empty. The operations team moves bikes between stations at night, but needs a rule to decide which stations to serve first. In this project I take the role of the data person on the team: find which stations lose bikes, show that it is not a one-day accident, and recommend five stations for overnight rebalancing.

## Data

- **Source:** [Citi Bike system data](https://citibikenyc.com/system-data). Check the usage terms on that page.
- **Period and size:** August 31 to September 30, 2026. 4,982,855 trips in 5 CSV files, 13 columns per trip.
- Every row is one trip: bike type, start and end time, start and end station (name, id, latitude, longitude) and rider type (member or casual).

| Table or view | Rows | Description |
| --- | --- | --- |
| `trips_raw` | 4,982,855 | the 5 CSV files loaded as they came, never changed |
| `trips_clean` | 4,981,785 | view over `trips_raw` without invalid trips |
| `stations` | 2,501 | one row per station id, with the most common name and average coordinates |
| `station_net_flow` | [FILL IN] | view: arrivals minus departures per station for the month |
| `station_daily_flow` | [FILL IN] | view: arrivals minus departures per station and per day |

## Tools

- **SQL on DuckDB:** runs the analysis on about 5 million rows locally, without a server.
- **Jupyter Notebook with SQL magic:** keeps each query next to its business question and conclusion.
- **Git and GitHub:** version control.

## Business questions

| # | Question | Technique |
| --- | --- | --- |
| 1 | What is the net flow per station, and which stations are consistently in deficit or surplus? | CTEs, `FULL JOIN`, daily net flow with `UNION ALL` |
| 2 | What are the busiest hours, overall and weekday vs weekend? | `EXTRACT`, average per day, `FILTER` |
| 3 | Which 10 stations have the highest total volume (starts + ends)? | `UNION ALL`, `GROUP BY` |
| 4 | Do members and casual riders differ in duration or patterns? | mean and median, `OVER (PARTITION BY ...)` |
| 5 | What is the average duration, and are there outliers that suggest bad data? | `QUANTILE_CONT`, raw vs clean comparison |
| 6 | What are the most common routes, and is the pattern commuter or leisure? | route profile, baseline comparison |
| 7 | Which 5 stations should receive bikes overnight? | combined criteria from Q1, Q2 and Q3 |

## Approach

1. Load the 5 CSV files into one table, `trips_raw`, with the station ids forced to text (otherwise DuckDB reads `6364.10` as the number `6364.1` and loses the zero).
2. Check the raw data for invalid trips and missing stations, and decide what to remove.
3. Create `trips_clean`, a view that keeps the raw data untouched.
4. Answer each question in a notebook cell, followed by a conclusion that uses only numbers from the query.

## Results

**1. Net flow.** The stations that lose the most bikes over the month are E 39 St & Lexington Ave (-640), E 33 St & Park Ave (-613), Willoughby Ave & Hall St (-493), E 39 St & 2 Ave (-492) and E 51 St & 2 Ave (-478). [FILL IN: how many stations are consistent deficits, surpluses and mixed (80% of days rule), and the % of days in deficit of the stations above].

**2. Busiest hours.** The busiest hours are 17h (484,123 departures, 9.7% of the month), 18h (453,018) and 16h (371,007). On weekdays there are two peaks, around 8h and around 17h to 18h. [FILL IN: the weekend shape from the per-day table].

**3. Busiest stations.** W 21 St & 6 Ave has the highest volume (34,636 starts plus ends), followed by Pier 61 at Chelsea Piers (33,762) and E 17 St & Broadway (30,583). None of the stations with the biggest deficit is in the top 10 by volume.

**4. Members vs casual.** Members make 81.2% of the trips (4,047,045), casual riders 18.8% (934,740). Casual trips are longer: 18.5 minutes on average against 11.9 for members. [FILL IN: median minutes]. Both groups prefer electric bikes (71.6% of member trips and 77.0% of casual trips).

**5. Duration and outliers.** The average clean trip lasts 13.1 minutes. [FILL IN: raw average, p95, p99 and max]. No trip is shorter than 60 seconds or ends before it starts, and 1,070 trips (0.02%) last more than 24 hours.

**6. Routes.** The top route is a round trip at Central Park S & 6 Ave (2,138 trips), and 87.7% of them are casual riders, which points to leisure. Vernon Blvd & 50 Ave and 55 Ave & Center Blvd are connected in both directions (987 and 917 trips), and 93% to 95% of those trips are members. [FILL IN: weekday and commute-hour shares compared with the baseline].

**7. Rebalancing.** [FILL IN: the final 5 stations from the Q7 table, with the % of days in deficit and the weekday morning departures of each].

## Recommendations

1. [FILL IN: bring bikes overnight to the 5 stations from Question 7, ready before the morning peak at 8h.]
2. [FILL IN: review the consistent-deficit stations monthly, since the pattern is stable.]
3. [FILL IN: investigate why electric bikes are the ones that end trips without a station.]

## Data quality and decisions

| Rule | Rows removed | Why |
| --- | --- | --- |
| End time before or equal to start time | 0 | A trip cannot end before it starts |
| Duration under 60 seconds | 0 | Usually a false start. The provider already removes these |
| Duration over 24 hours | 1,070 | Usually a lost or unreturned bike |

- Total removed: 1,070 rows (0.02%), leaving 4,981,785.
- Missing stations: 2,917 trips without a start station and 12,404 without an end station. They are almost all electric bikes (2,917 and 12,338), which can be locked outside a dock. These trips are kept for hours, riders and duration, and excluded from the station questions.
- Station id and name: [FILL IN: result of the id vs name comparison and the decision to group by name].

## Limitations

- Only one month of data, so there is no seasonality and the conclusions may not hold in winter.
- The analysis shows association, not causation.
- The dock capacity of each station is unknown, so a deficit cannot be compared with the number of docks.
- September 7 (Labor Day) is counted as a weekday although it behaves like a holiday.
- August 31 is a partial day, so per-day analyses use only September 1 to 30.

## What I learned

- **Check the data type when loading.** Station ids with a trailing zero were read as numbers and lost the zero. Forcing them to text fixed it.
- **Check problems on the raw data, not on the clean data.** My first outlier check ran on the clean view and returned zero by construction.
- **Compare per-day averages, not totals.** A month has more weekdays than weekend days, so totals favor weekdays.
- **A missing value is not a station.** The null group appeared as an "unknown" station until I excluded it from the joins.
- **"Consistent" needs a daily view.** A month total can hide a station that is in deficit only a few days.

## Repository structure

```
project-03-citibike/
├── README.md
├── data/            # the 5 CSV files, not committed
├── database/        # local DuckDB file, not committed
└── notebooks/
    ├── create_DB.ipynb   # loads the CSV files into DuckDB
    └── queries.ipynb     # cleaning and the 7 business questions
```

---

*Part of a series of SQL and data engineering projects I am building on my path toward a career in Data Engineering. Feedback is very welcome.*