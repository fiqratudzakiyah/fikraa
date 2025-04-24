import time
import json
from kafka import KafkaProducer
import random
from datetime import datetime, timezone

# Fungsi untuk generate ID acak
def random_string(length=10):
    return ''.join(random.choices(string.ascii_letters + string.digits, k=length))

# Kafka Producer setup
producer = KafkaProducer(
    bootstrap_servers='kafka-broker:29092',  # Kafka broker yang dijalankan di Docker
    value_serializer=lambda v: json.dumps(v).encode('utf-8')  # Serialize JSON
)


topic = 'assignment'  

while True:
    # Generate event pembelian acak
    event = {
        'user_id': random.randint(1, 100),
        'amount': random.randint(10, 1000),
        'timestamp': datetime.now(timezone.utc).isoformat()  # Timestamp saat event dibuat
    }

    # Kirim event ke Kafka
    producer.send(topic, event)
    print(f"Sent: {event}")

    # Delay 2 detik untuk simulasi pengiriman data secara berkala
    time.sleep(2)
