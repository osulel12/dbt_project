{% for year in [2021, 2022, 2023, 2024] %}
SELECT *
FROM {{ source('click_source', 'test_1') }}
WHERE period = '{{ year }}'
LIMIT 7000
{% if not loop.last %} UNION ALL {% endif %}
{% endfor %}
