-- Run on PRIMARY. Inserts a stable synthetic marker for demonstration.
-- The verification shell additionally inserts a unique timestamped marker.
INSERT INTO public.replication_probe(probe_id)
VALUES('CRESCENT_LAB_FIXED_PROBE') ON CONFLICT(probe_id) DO NOTHING;
SELECT probe_id,inserted_at FROM public.replication_probe ORDER BY inserted_at DESC LIMIT 10;
