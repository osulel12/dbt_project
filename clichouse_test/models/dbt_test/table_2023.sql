SELECT *
FROM {{ source('click_source', 'test_1') }}
WHERE period = 2023


