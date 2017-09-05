package church.mcac;

import redis.clients.jedis.Jedis;

import static spark.Spark.get;

public class Application {
  public static void main(String[] args) {
    Jedis jedis = new Jedis(System.getenv().get("REDIS_HOST"));
    Environment environment = Environment.fromEnvironmentVariable(System.getenv("ENVIRONMENT"));
    LandingPageStore landingPageStore = LandingPageStore.defaultImplementation(jedis, environment);

    get("*", new LandingController(landingPageStore).indexRoute);
  }
}
