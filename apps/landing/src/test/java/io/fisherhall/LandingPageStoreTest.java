package io.fisherhall;

import org.junit.Before;
import org.junit.Test;
import redis.clients.jedis.Jedis;

import java.util.Optional;

import static org.junit.Assert.assertEquals;

public class LandingPageStoreTest {
  private Jedis jedis;
  private LandingPageStore store;

  @Before
  public void beforeEach() {
    jedis = new Jedis("redis");
    jedis.flushAll();
    store = LandingPageStore.defaultImplementation(jedis, Environment.TEST);
  }

  @Test
  public void getFromRevision_with_no_revision() {
    jedis.set("basechurch:index:current", "CURRENT_REVISION");
    jedis.set("basechurch:index:CURRENT_REVISION", "My landing page");

    assertEquals("My landing page", store.getFromRevision(Optional.empty()));
  }

  @Test
  public void getFromRevision_with_revision() {
    jedis.set("basechurch:index:1", "v1 landing page");

    assertEquals("v1 landing page", store.getFromRevision(Optional.of("1")));
  }
}