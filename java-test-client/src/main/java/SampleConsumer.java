import io.confluent.kafka.serializers.KafkaJsonDeserializerConfig;
import lombok.extern.slf4j.Slf4j;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.io.IOException;
import java.io.InputStream;
import java.time.Duration;
import java.util.Collections;
import java.util.Properties;
import java.util.concurrent.ExecutionException;

@Slf4j
public class SampleConsumer {

    public static void main(String ... args) throws IOException, ExecutionException, InterruptedException {
        InputStream stream = Thread.currentThread().getContextClassLoader().getResourceAsStream("client.properties");
        Properties properties = new Properties();
        properties.load(stream);
        properties.put(KafkaJsonDeserializerConfig.JSON_VALUE_TYPE, Person.class.getName());
        try (KafkaConsumer<String, Person> kafkaConsumer = new KafkaConsumer<>(properties)) {
            kafkaConsumer.subscribe(Collections.singleton("person-topic"));
            while(true) {
                ConsumerRecords<String, Person> result = kafkaConsumer.poll(Duration.ofSeconds(1));
                log.info("Received result {}", result.toString());
                result.iterator().forEachRemaining(cr -> log.info(cr.value().toString()));
            }
        }
    }
}
