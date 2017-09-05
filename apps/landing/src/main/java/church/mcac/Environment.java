package church.mcac;

public enum Environment {
  TEST, DEVELOPMENT, STAGING, PRODUCTION;

  public static boolean isDevelopment() {
    return Environment.fromEnvironmentVariable(System.getenv("ENVIRONMENT")) == Environment.DEVELOPMENT;
  }

  public static boolean isProduction() {
    return Environment.fromEnvironmentVariable(System.getenv("ENVIRONMENT")) == Environment.PRODUCTION;
  }

  public static Environment fromEnvironmentVariable(String envVar) {
    switch (envVar.toLowerCase()) {
      case "test":
        return TEST;
      case "development":
        return DEVELOPMENT;
      case "staging":
        return STAGING;
      case "production":
        return PRODUCTION;
      default:
        return DEVELOPMENT;
    }
  }
}
