SELECT results.id,
  results.event_id,
  events.date,
  results.distance,
  rank() OVER (PARTITION BY results.event_id, results.distance ORDER BY results."time") AS "position",
  results.person_id,
  results."time",
  CASE
    WHEN results.person_id IS NOT NULL
      AND events.date = min(events.date) OVER (PARTITION BY results.person_id ORDER BY events.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
    THEN 1
    ELSE NULL
  END AS first_timer,
  min(results."time") OVER (PARTITION BY results.person_id, results.distance ORDER BY events.date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS fastest_time_to_date
FROM results
  JOIN events ON results.event_id = events.id
ORDER BY events.date;
