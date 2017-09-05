package church.mcac;

import redis.clients.jedis.Jedis;
import spark.Request;

import java.util.Optional;

public interface LandingPageStore {
  public String getFromRevision(Optional<String> revision);

  public static LandingPageStore defaultImplementation(Jedis jedis, Environment environment) {
    return new LandingPageStoreImpl(jedis, environment);
  }
}

class LandingPageStoreImpl implements LandingPageStore {
  private Jedis jedis;
  private Environment environment;

  LandingPageStoreImpl(Jedis jedis, Environment environment) {
    this.jedis = jedis;
    this.environment = environment;

    if (environment == Environment.DEVELOPMENT) {
      seedDevelopmentData();
    }
  }

  @Override
  public String getFromRevision(Optional<String> revision) {
      return jedis.get(fetchRevisionKey(revision));
  }

  private String fetchRevisionKey(Optional<String> optionalRevision) {
    String revision = optionalRevision.
        filter(s -> !s.isEmpty()).
        orElse(getCurrentRevision());

    return String.format("basechurch:index:%s", revision);
  }

  private String getCurrentRevision() {
    return jedis.get("basechurch:index:current");
  }

  private void seedDevelopmentData() {
    jedis.set("basechurch:index:current", "CURRENT_REVISION");
    jedis.set("basechurch:index:CURRENT_REVISION", "<html><body><h1>Latest Hello World V2</h1></body></html>");
    jedis.set("basechurch:index:secret", "<html><body><h1>Secret Hello World</h1></body></html>");
  }
}
