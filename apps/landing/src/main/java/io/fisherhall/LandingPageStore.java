package io.fisherhall;

import redis.clients.jedis.Jedis;

import java.util.Optional;

public interface LandingPageStore {
  public String getFromRevision(Optional<String> revision);

  public static LandingPageStore defaultImplementation(Jedis jedis, io.fisherhall.Environment environment) {
    return new LandingPageStoreImpl(jedis, environment);
  }
}

class LandingPageStoreImpl implements LandingPageStore {
  private Jedis jedis;

  LandingPageStoreImpl(Jedis jedis, io.fisherhall.Environment environment) {
    this.jedis = jedis;

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
