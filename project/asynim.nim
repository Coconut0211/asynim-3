import os
import jester
import norm/postgres
import asynim/[routes]
import asynim/school/[models]
import asynim/shelter/[models]
import asynim/shop/[models]

when isMainModule:
  let dbHost = getEnv("DB_HOST")
  let dbUser = getEnv("POSTGRES_USER")
  let dbPass = getEnv("POSTGRES_PASSWORD")

  sleep(2_500)
  let dbSchool = open(dbHost, dbUser, dbPass, "asynim_school")
  let dbShelter = open(dbHost, dbUser, dbPass, "asynim_shelter")
  let dbShop = open(dbHost, dbUser, dbPass, "asynim_shop")
  
  dbSchool.initSchool()
  dbShelter.initShelter()
  dbShop.initShop()

  getRoutes()
  settings = newSettings(port = Port(8080))

  var server = initJester(settings)
  server.register(baseRoutes.matcher) 
  server.register(schoolRoutes.matcher)
  server.register(shopRoutes.matcher)
  server.register(shelterRoutes.matcher)

  server.register(baseRoutes.errorHandler)
  server.serve()

  dbSchool.close()
