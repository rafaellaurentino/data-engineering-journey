/*

Find the single track that appears on the most playlists 
what does that suggest about "playlist-friendly" songs?

*/

SELECT
    t.name,
    COUNT(DISTINCT(pt.playlist_id)) total
FROM track t
JOIN playlist_track pt
    ON t.track_id = pt.track_id
GROUP BY t.name, t.track_id
ORDER BY total DESC;


/*
to get only the track that appears on the most playlists we gonna do a dense_rank.
And why not a rank? When multiple tracks share the exact same top score 
(like the tie at 5 playlists in our dataset), both functions will assign rank 1 to 
all of those top tracks. However, the difference lies in how they number the items 
that come after the tie: 

DENSE_RANK() assigns sequential ranks without skipping numbers (1, 1, 1, 2, 3).

RANK() skips rank positions based on the number of tied rows (1, 1, 1, 4, 5).

DENSE_RANK() ensures that every rank integer corresponds to 
a distinct score tier, keeping your ranking logic consistent regardless of how many 
ties occur at the top.

So basically we could yes, use a rank here and we´d have the same result but If we 
ever expand our query to fetch the "Top 3 highest playlist counts" 
(WHERE rnk <= 3), DENSE_RANK() guarantees you will actually get tiers 1, 2, and 3. 
RANK() would skip straight to rank 42 after a 41-way tie at rank 1, completely 
breaking your WHERE rnk <= 3 filter.
*/

WITH RankedTracks AS (
    SELECT
        t.track_id,
        t.name,
        COUNT(DISTINCT pt.playlist_id) AS total,
        DENSE_RANK() OVER (ORDER BY COUNT(DISTINCT pt.playlist_id) DESC) as rnk
    FROM track t
    JOIN playlist_track pt ON t.track_id = pt.track_id
    GROUP BY t.track_id, t.name
)
SELECT track_id, name, total, rnk
FROM RankedTracks


/*

What Makes a Song "Playlist-Friendly"
Functional Utility: It serves a specific activity or mood—such as studying, working, 
sleeping, driving, or relaxing—rather than demanding active, full-attention listening.

Low Friction & High Blendability: It transitions smoothly between other tracks without
 sudden, jarring shifts in volume, tempo, or genre.

Universal & Non-Intrusive Appeal: It relies less on controversial lyrics or polarizing
 vocals, making it easy to play in background settings, public spaces, or shared environments.

High Replay Value: It avoids fatigue over repeated listens, encouraging users to leave
the track in their personal libraries or auto-generated queues indefinitely.