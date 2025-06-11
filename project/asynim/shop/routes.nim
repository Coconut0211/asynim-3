import views

template shopRoutes*() =
    router shopRoutes:
      get "/api/v1/shop":
        shopApiView()
      get "/api/v1/shop/@section/@id":
        cond @"section" in ["staff", "cash", "good"]
        resp await detailShopObjectApiView(dbShop, @"section", @"id")
      post "/api/v1/shop/@section/create":
        cond @"section" in ["staff", "cash", "good"]
        resp createShopObjectApiView()