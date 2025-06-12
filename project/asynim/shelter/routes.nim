import views

template shelterRoutes*() =
    router shelterRoutes:
      get "/api/v1/shelter":
        shelterApiView()
      get "/api/v1/shelter/@section/@id":
        cond @"section" in ["manager", "staff", "pet"]
        resp await detailShelterObjectApiView(dbShelter, @"section", @"id")
      post "/api/v1/shelter/@section/create":
        cond @"section" in ["manager", "staff", "pet"]
        resp createShelterObjectApiView()