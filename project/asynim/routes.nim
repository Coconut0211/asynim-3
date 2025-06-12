import school/routes
import shop/routes
import shelter/routes
import views

template baseRoutes*() =
  router baseRoutes:
    get "/":
      resp indexView()
    get "/api/v1/":
      baseApiView()
    error Http403:
      deniedView()
    error Http404:
      notFoundView()

template getRoutes*() =
  baseRoutes()
  schoolRoutes()
  shopRoutes()
  shelterRoutes()
