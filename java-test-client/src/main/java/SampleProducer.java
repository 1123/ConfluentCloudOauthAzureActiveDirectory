import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;
import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.util.concurrent.ExecutionException;

@Data
@AllArgsConstructor
@ToString
@NoArgsConstructor
class Person {
    String firstname;
    String lastname;
}

public class SampleProducer {

    public static void main(String ... args) throws IOException, ExecutionException, InterruptedException {
        InputStream stream = Thread.currentThread().getContextClassLoader().getResourceAsStream("client.properties");
        Properties properties = new Properties();
        properties.load(stream);
        try (KafkaProducer<String, Person> kafkaProducer = new KafkaProducer<>(properties)) {
            var result = kafkaProducer.send(
                    new ProducerRecord<>("person-topic", "id1", new Person("John", "Doe"))
            );
            result.get();
        }
    }
}
