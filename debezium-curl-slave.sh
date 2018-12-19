curl -X DELETE http://localhost:8083/connectors/jdbc-sink

curl -X POST -H "Accept:application/json" -H "Content-Type:application/json" http://localhost:8083/connectors/ -d '
{
    "name": "jdbc-sink",
    "config": {
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "tasks.max": "1",
        "topics": "clientdb.public.test",
        "connection.url": "jdbc:postgresql://pg_slave_cp:5432/connections?user=postgres&password=postgres",
        "transforms": "unwrap",
        "transforms.unwrap.type": "io.debezium.transforms.UnwrapFromEnvelope",
        "auto.create": "true",
        "insert.mode": "upsert",
        "pk.fields": "id",
        "pk.mode": "record_value"
    }
}
'

curl -X PUT -H "Accept:application/json" -H "Content-Type:application/json" http://localhost:8083/connectors/jdbc-sink/config -d '
    {
        "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
        "tasks.max": "1",
        "topics": "test",
        "connection.url": "jdbc:postgresql://pg_slave_cp:5432/connections?user=conn&password=postgres",
        "transforms": "unwrap",
        "transforms.unwrap.type": "io.debezium.transforms.UnwrapFromEnvelope",
        "auto.create": "true",
        "insert.mode": "upsert",
        "pk.fields": "OID",
        "pk.mode": "record_value"
    }
'

curl -X POST localhost:8083/connectors/jdbc-sink/restart

curl -X POST localhost:8083/connectors/jdbc-sink/tasks/0/restart
