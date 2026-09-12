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
GROUP BY t.name
ORDER BY total DESC;

