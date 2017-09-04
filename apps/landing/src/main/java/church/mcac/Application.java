package church.mcac;

import redis.clients.jedis.Jedis;

import static spark.Spark.get;

public class Application {
  public static void main(String[] args) {
    Jedis jedis = new Jedis(System.getenv().get("REDIS_HOST"));
    jedis.set("basechurch:index:__development__", "<html><body><h1>Hello world</h1></body></html>");

    get("/", LandingController.indexRoute(jedis));
  }
}
