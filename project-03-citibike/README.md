# Citi Bike: Where Should Bikes Be Rebalanced Overnight?

**Project 3 in my learning path toward a career in Data Engineering.** A SQL investigation of about 5 million bike-share trips: which stations lose the most bikes, when the demand peaks, and where the operations team should move bikes overnight.

---

## Summary

I analyzed 4,982,855 Citi Bike trips from August 31 to September 30, 2026, using SQL on DuckDB. Departures peak at 17h and 18h, and on weekdays there is a second peak at 8h. Out of 2,313 stations with at least 20 active days, 13 lose bikes on at least 80% of the days. The five with the largest month deficit are E 39 St & Lexington Ave (-640), E 33 St & Park Ave (-613), Willoughby Ave & Hall St (-493), E 39 St & 2 Ave (-492) and E 51 St & 2 Ave (-478). Each of them is in deficit on 83% to 100% of the days, and I recommend them for overnight rebalancing.

## Business context

Citi Bike is a bike-share system where riders pick up a bike at one station and return it at another. Because people ride mostly in one direction at some hours, some stations fill up while others lose bikes. The operations team moves bikes between stations at night, but needs a rule to decide which stations to serve first. In this project I take the role of the data person on the team: find which stations lose bikes, show that it is not a one-day accident, and recommend five stations for overnight rebalancing.

## Data

- **Source:** [Citi Bike system data](https://citibikenyc.com/system-data). Check the usage terms on that page.
- **Period and size:** August 31 to September 30, 2026. 4,982,855 trips in 5 CSV files, 13 columns per trip.
- Every row is one trip: bike type, start and end time, start and end station (name, id, latitude, longitude) and rider type (member or casual).

| Table or view | Rows | Description |
| --- | --- | --- |
| `trips_raw` | 4,982,855 | the 5 CSV files loaded as they came, never changed |
| `trips_clean` | 4,981,785 | view over `trips_raw` without invalid trips |
| `stations` | 2,501 | one row per station id, with the most common name and average coordinates |
| `station_net_flow` | one row per station | view: arrivals minus departures for the month |
| `station_daily_flow` | one row per station and day | view: arrivals minus departures per day, September 1 to 30 |

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
4. Group station questions by **station name**, because 1,121 trips have an end station name but no id, and no trip has an id without a name.
5. Answer each question in a notebook cell, followed by a conclusion that uses only numbers from the query.

## Results

**1. Net flow.** The stations that lose the most bikes over the month are E 39 St & Lexington Ave (-640), E 33 St & Park Ave (-613), Willoughby Ave & Hall St (-493), E 39 St & 2 Ave (-492) and E 51 St & 2 Ave (-478). The biggest surplus is Greenwich St & W Houston St (+605). To check that this is not a one-day accident, I looked at each day of September: 13 stations are consistent deficits (a deficit on at least 80% of their days), 3 are consistent surpluses and 2,297 are mixed. All five stations above are consistent deficits: they lose bikes on 83% to 100% of their active days.

**2. Busiest hours.** The busiest hours are 17h (484,123 departures, 9.7% of the month), 18h (453,018) and 16h (371,007). On weekdays there are two peaks: about 13,400 departures per day at 8h and about 18,400 at 17h. On weekends there are no rush-hour peaks: departures rise slowly from 6h and stay on a plateau of about 8,800 to 10,000 per hour between 12h and 18h, with the maximum at 15h (10,007).

**3. Busiest stations.** W 21 St & 6 Ave has the highest volume (34,636 starts plus ends), followed by Pier 61 at Chelsea Piers (33,762) and E 17 St & Broadway (30,583). None of the 10 stations with the biggest deficit in Question 1 is in the top 10 by volume, so a busy station is not necessarily a station that loses bikes.

**4. Members vs casual.** Members make 81.2% of the trips (4,047,045) and casual riders 18.8% (934,740). Casual trips are longer: 18.5 minutes on average against 11.9 for members (medians: 12.7 and 8.9). Both groups prefer electric bikes (71.6% of member trips and 77.0% of casual trips). Casual riders ride longer on classic bikes (22.0 minutes on average) than on electric ones (17.4), while members ride about the same on both (11.7 and 12.0). Members are more commute-oriented: 50.2% of their trips are in commute hours (7 to 9h and 16 to 19h) and 18.8% on weekends, against 42.5% and 28.3% for casual riders.

**5. Duration and outliers.** The average clean trip lasts 13.1 minutes (median 9.5). In the raw data, no trip is shorter than 60 seconds or ends before it starts, and the longest one lasts about 25 hours, so there are no multi-day trips. The 1,070 trips (0.02%) longer than 24 hours were removed, which moved the average from 13.4 to 13.1 minutes and left the median unchanged. Some long trips remain below the limit: 7,744 above 2 hours, 1,614 above 6 hours and 569 above 12 hours, so outliers are rare but not gone. In the clean data, p95 is 33.5 minutes and p99 is 58.2 minutes.

**6. Routes.** Of the 20 most common routes, 10 are round trips (the same station at the start and at the end), but round trips are only 2.0% of all trips (101,559). Nine of the 10 round trips look like leisure: for example Central Park S & 6 Ave (2,138 trips, the top route), where 87.7% of the riders are casual. These nine have a commute-hour share below the 48.8% baseline and 10% to 25% of members, against 81.2% in all trips. The exception is Eastern Pkwy & Kingston Ave (814 trips): 94.3% on weekdays and 93.9% members, but only 29.6% in commute hours, which does not fit either pattern. The other 10 routes go from one station to another and look like commuting: 84% to 98% members, and between 77% and 89% of the trips on weekdays (baseline 79.4%). The clearest cases are S 4 St & Wythe Ave to N 6 St & Bedford Ave (62.4% in commute hours) and N 6 St & Bedford Ave to S 2 St & Kent Ave (62.6%).

**7. Rebalancing.** I chose stations with a negative month net flow, a deficit on at least 70% of the days and at least 2,000 movements in the month. Of the stations that pass these filters, the five with the largest deficit are:

| Station | Month net flow | Net flow as % of volume | Days in deficit | Weekday departures, 6h to 9h |
| --- | --- | --- | --- | --- |
| E 39 St & Lexington Ave | -640 | -4.5% | 83.3% | 1,561 |
| E 33 St & Park Ave | -613 | -7.9% | 100.0% | 845 |
| Willoughby Ave & Hall St | -493 | -4.6% | 83.3% | 1,334 |
| E 39 St & 2 Ave | -492 | -4.5% | 88.9% | 1,094 |
| E 51 St & 2 Ave | -478 | -4.4% | 86.7% | 1,102 |

## Recommendations

1. Bring bikes overnight to the five stations above, so they are stocked before the morning peak at 8h. Each of them has between 845 and 1,561 weekday departures between 6h and 9h.
2. Review the 13 consistent-deficit stations every month, and check whether the list changes in other months, since this analysis covers only September.
3. Ask why electric bikes end trips without a station: 12,338 of the 12,404 trips without an end station (99.5%) are electric, and those trips are missing from every station analysis.

## Data quality and decisions

| Rule | Rows removed | Why |
| --- | --- | --- |
| End time before or equal to start time | 0 | A trip cannot end before it starts |
| Duration under 60 seconds | 0 | Usually a false start. The provider already removes these |
| Duration over 24 hours | 1,070 | Usually a lost or unreturned bike |

- Total removed: 1,070 rows (0.02%), leaving 4,981,785.
- Missing stations: 2,917 trips without a start station and 12,404 without an end station. They are almost all electric bikes (2,917 and 12,338), which can be locked outside a dock. These trips are kept for hours, riders and duration, and excluded from the station questions.
- Station id and name: 1,121 trips have an end station name but no end id, and no trip has an id without a name. For this reason station questions use the name. The cost is that 62 names are linked to more than one id and 1 id to more than one name, so a few stations may be merged or split.

## Limitations

- Only one month of data, so there is no seasonality and the conclusions may not hold in winter.
- The analysis shows association, not causation.
- Net flow is calculated from trips only. The data does not include bikes the operations team already moved during the day, or the number of bikes in each station, so a deficit does not prove that a station was empty.
- The dock capacity of each station is unknown, so a deficit cannot be compared with the number of docks.
- I did not check whether the 62 names with several ids are the same physical place, so a few stations may be counted together.
- Trips without a station (about 0.3% of the trips) are not counted in the station questions.
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