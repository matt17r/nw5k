SELECT        results.id
              ,event_id
              ,events.date
              ,results.distance
              ,RANK() OVER (PARTITION BY event_id, distance ORDER BY time) AS position
              ,person_id
              ,results.time
              ,CASE WHEN person_id IS NOT NULL AND events.date=MIN(date) OVER (PARTITION BY person_id ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) THEN true END AS first_timer
              ,MIN(time) OVER (PARTITION BY person_id, distance ORDER BY date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS fastest_time_to_date
FROM          results
  INNER JOIN  events
          ON  results.event_id = events.id
ORDER BY      date;
