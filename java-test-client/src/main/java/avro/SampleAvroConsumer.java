package avro;

import io.confluent.examples.clients.basicavro.Payment;
import io.confluent.kafka.serializers.KafkaAvroDeserializer;
import io.confluent.kafka.serializers.KafkaAvroDeserializerConfig;
import io.confluent.kafka.serializers.KafkaAvroSerializer;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.consumer.ConsumerConfig;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.errors.SerializationException;
import org.apache.kafka.common.serialization.StringDeserializer;
import org.apache.kafka.common.serialization.StringSerializer;
import scala.collection.immutable.Stream;

import java.io.IOException;
import java.io.InputStream;
import java.time.Duration;
import java.util.Collections;
import java.util.Properties;

@Slf4j
public class SampleAvroConsumer {

    private static final String TOPIC = "transactions";
    private static String configFile;

    @SuppressWarnings("InfiniteLoopStatement")
    public static void main(final String[] args) throws IOException {
        InputStream stream = Thread.currentThread().getContextClassLoader().getResourceAsStream("client.properties");
        Properties properties = new Properties();
        properties.load(stream);
        properties.put(ConsumerConfig.GROUP_ID_CONFIG, "transactions-consumer");
        properties.put(ConsumerConfig.KEY_DESERIALIZER_CLASS_CONFIG, StringDeserializer.class);
        properties.put(ConsumerConfig.VALUE_DESERIALIZER_CLASS_CONFIG, KafkaAvroDeserializer.class);
        properties.put(ConsumerConfig.AUTO_OFFSET_RESET_CONFIG, "earliest");
        properties.put(KafkaAvroDeserializerConfig.SPECIFIC_AVRO_READER_CONFIG, true);

        try (KafkaConsumer<String, Payment> consumer = new KafkaConsumer<String, Payment>(properties)) {
            consumer.subscribe(Collections.singleton("transactions"));
            while(true) {
                ConsumerRecords<String, Payment> polledRecords = consumer.poll(Duration.ofSeconds(10));
                log.info("Received {} records", polledRecords.count());
                polledRecords.iterator().forEachRemaining(record ->
                        log.info("record-value: {}", record.value().toString())
                );
            }
        }

    }

}