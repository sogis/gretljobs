SET search_path TO ${dbSchema};

DELETE FROM t_ili2db_dataset;

DELETE FROM t_ili2db_basket WHERE t_id != 1;

WITH 

bfs_nr AS (
    SELECT DISTINCT 
        bfs_nr::text AS bfs_nr_txt
    FROM
        mopublic_gemeindegrenze
),

dataset AS (
    INSERT INTO 
        t_ili2db_dataset(
            t_id,
            datasetname 
        )
    SELECT 
        nextval('t_ili2db_seq'),
        bfs_nr_txt
    FROM
        bfs_nr
    RETURNING *
),

topic AS (
    SELECT 
        topic
    FROM 
        t_ili2db_basket
    WHERE 
        t_id = 1
)

INSERT INTO 
    t_ili2db_basket(
        t_id,
        dataset,
        topic,
        t_ili_tid,
        attachmentkey
    )
SELECT 
    nextval('t_ili2db_seq') AS t_id,
    ds.t_id,
    topic,
    bfs_nr_txt AS t_ili_tid,
    bfs_nr_txt AS attachmentkey
FROM 
    bfs_nr bfs
JOIN
    dataset ds ON bfs.bfs_nr_txt = ds.datasetname
CROSS JOIN 
    topic
;