package church.mcac;

import redis.clients.jedis.Jedis;
import spark.Request;
import spark.Response;
import spark.Route;

import java.util.Optional;

public class LandingController {
  private Jedis jedis;

  private LandingController(Jedis jedis) {
    this.jedis = jedis;
  }

  public static Route indexRoute(Jedis jedis) {
    return new LandingController(jedis).getIndex();
  }

  public Route getIndex() {
    return (Request request, Response response) -> {
      return fetchLandingPageContents(request);
    };
  }

  private String fetchLandingPageContents(Request request) {
    return jedis.get(fetchRevisionKey(request));
  }

  private String fetchRevisionKey(Request request) {
    String revision = Optional.ofNullable(request.queryParams("revision"))
        .filter(s -> !s.isEmpty())
        .orElse(getCurrentRevision());

    return String.format("basechurch:index:%s", revision);
  }

  private String getCurrentRevision() {
    return jedis.get("basechurch:index:current");
  }
}
