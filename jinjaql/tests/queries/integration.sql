{% query 'create_artists', connection_string='test_db.sqlite' %}
    CREATE TABLE artists (
        id INTEGER NOT NULL, 
        name VARCHAR(50), 
        age INTEGER,
        instrument VARCHAR(50), 
        PRIMARY KEY (id)
    );
{% endquery %}

{% query 'drop_artists', connection_string='test_db.sqlite' %}
    DROP TABLE artists
{% endquery %}

{% query 'insert_artist', connection_string='test_db.sqlite' %}
    INSERT INTO artists
    VALUES ({{ id|guards.integer }}, {{ name|guards.string }}, {{ age|guards.integer }}, {{ instrument|guards.string }})
{% endquery %}

{% sql 'get_artists', connection_string='test_db.sqlite' %}
    SELECT name, age, instrument
    FROM artists
    WHERE id = {{ id }}
{% endsql %}

{% sql 'simple_tmpl', connection_string='test_db.sqlite' %}
    {{ var }}
{% endsql %}
