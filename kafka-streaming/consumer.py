from kafka import KafkaConsumer
import json

# Kafka Consumer setup
consumer = KafkaConsumer(
    'event_topic',  # Topic yang sama dengan Producer
    bootstrap_servers='localhost:9092',
    value_deserializer=lambda m: json.loads(m.decode('utf-8')),
    group_id='event-group'
)

print("Waiting for events...")

for message in consumer:
    print(f"Event received: {message.value}")
    
