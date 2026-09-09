/*
What are the top 10 best-selling tracks by revenue,
and which artist do they belong to?
*/

-- Let´s see how is the track table and take a look if how we can a JOIN with it

SELECT 
    *
FROM track;

--Okay, so valuable information from this table are: track name, composer and unit price
--BUt we need retrive tracks, revenue and who wrote them

--Let´s take a look at the aritst table

SELECT
    *
FROM artist;
--Okay, so our only possibly way to make a join is with the artist_id


SELECT
    *
FROM invoice_line;
--i´m checking this table ´cause it´s table resposable for the revenue.
--good news, we have the track_id, the unit_price and the quantity, with that we can figure out each track revenue



/*
So, to answer that question about what are the the top 10 tracks by revenue and
which artist the belongs to we need to make a join with following tables: invoice_line
track, album and artist
*/

SELECT 
    t.name AS TrackName,
    ar.name AS ArtistName,
    SUM(il.unit_price * il.quantity) AS Revenue
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN album a ON t.album_id = a.album_id
JOIN artist ar ON a.artist_id = ar.artist_id
GROUP BY t.track_id, t.name, ar.name
ORDER BY Revenue DESC
LIMIT 10;

--with that we have our answer