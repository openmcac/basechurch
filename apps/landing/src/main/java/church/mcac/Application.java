package church.mcac;

import redis.clients.jedis.Jedis;

import static spark.Spark.get;

public class Application {
  public static void main(String[] args) {
    Jedis jedis = new Jedis(System.getenv().get("REDIS_HOST"));

    if (Environment.isDevelopment()) {
      jedis.set("basechurch:index:current", "CURRENT_REVISION");
      jedis.set("basechurch:index:CURRENT_REVISION", "<html><body><h1>Latest Hello World</h1></body></html>");
      jedis.set("basechurch:index:secret", "<html><body><h1>Secret Hello World</h1></body></html>");
    }

    get("*", LandingController.indexRoute(jedis));
  }
}
