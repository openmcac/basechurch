package church.mcac;

import redis.clients.jedis.Jedis;
import spark.Request;
import spark.Response;
import spark.Route;

public class LandingController {
  private Jedis jedis;

  private LandingController(Jedis jedis) {
    this.jedis = jedis;
  }

  public static Route indexRoute(Jedis jedis) {
    return new LandingController(jedis).getIndex();
  }

  private String fetchLandingPageContents() {
    return jedis.get("basechurch:index:__development__");
  }

  public Route getIndex() {
    return (Request request, Response response) -> {
      return fetchLandingPageContents();
    };
  }
}
