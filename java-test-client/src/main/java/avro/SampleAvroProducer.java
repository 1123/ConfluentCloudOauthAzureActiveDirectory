package io.confluent.examples.clients.basicavro;

import io.confluent.kafka.serializers.AbstractKafkaSchemaSerDeConfig;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerConfig;
import org.apache.kafka.clients.producer.ProducerRecord;
import org.apache.kafka.common.serialization.StringSerializer;
import io.confluent.kafka.serializers.KafkaAvroSerializer;
import org.apache.kafka.common.errors.SerializationException;

import java.util.Properties;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.io.FileInputStream;
import java.io.InputStream;

@Slf4j
public class SampleAvroProducer {

    private static final String TOPIC = "transactions";
    private static String configFile;

    @SuppressWarnings("InfiniteLoopStatement")
    public static void main(final String[] args) throws IOException {
        InputStream stream = Thread.currentThread().getContextClassLoader().getResourceAsStream("client.properties");
        Properties properties = new Properties();
        properties.load(stream);
        properties.put(ProducerConfig.ACKS_CONFIG, "all");
        properties.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG, StringSerializer.class);
        properties.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG, KafkaAvroSerializer.class);

        try (KafkaProducer<String, Payment> producer = new KafkaProducer<String, Payment>(properties)) {

            for (long i = 0; i < 10; i++) {
                final String orderId = "id" + Long.toString(i);
                final Payment payment = new Payment(orderId, 1000.00d);
                final ProducerRecord<String, Payment> record = new ProducerRecord<String, Payment>(TOPIC, payment.getId().toString(), payment);
                producer.send(record);
                Thread.sleep(1000L);
            }

            producer.flush();
            log.info("Successfully produced 10 messages to a topic called {}", TOPIC);

        } catch (final SerializationException e) {
            e.printStackTrace();
        } catch (final InterruptedException e) {
            e.printStackTrace();
        }

    }

}