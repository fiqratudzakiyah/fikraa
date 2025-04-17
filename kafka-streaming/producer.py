import time
import json
from kafka import KafkaProducer
import random
import string

# Fungsi untuk generate ID acak
def random_string(length=10):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

# Kafka Producer setup
producer = KafkaProducer(
    bootstrap_servers='kafka-broker:9092',  # Kafka broker
    value_serializer=lambda v: json.dumps(v).encode('utf-8')  # Serialize JSON
)

# Nama topic
topic = 'event_topic'

while True:
    # Generate event acak
    event = {
        'id': random_string(),
        'message': 'This is a random event',
        'timestamp': time.time()
    }

    # Kirim event ke Kafka
    producer.send(topic, event)
    print(f"Event sent: {event}")

    # Delay 5 detik
    time.sleep(5)
