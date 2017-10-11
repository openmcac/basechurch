package io.fisherhall;

import spark.Request;
import spark.Response;
import spark.Route;

import java.util.Optional;

public class LandingController {
  private LandingPageStore store;

  public final Route indexRoute = (Request request, Response response) -> {
    return store.getFromRevision(Optional.ofNullable(request.queryParams("revision")));
  };

  public LandingController(LandingPageStore store) {
    this.store = store;
  }
}
