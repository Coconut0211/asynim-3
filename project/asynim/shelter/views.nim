import asyncdispatch
import strutils, sequtils, json
import norm/[postgres]
import models
import ../[constants, utils]

template shelterApiView*() =
  var content: JsonNode = newJObject()
  let staff = dbShelter.selectAll(Staff)
  let manager = dbShelter.selectAll(Manager)
  let pet = dbShelter.selectAll(Pet)
  content["staff"] = %* staff.mapIt(%*{"id": it.id, "lastname": it.lastname})
  content["manager"] = %* manager.mapIt(%*{"id": it.id, "lastname": it.lastname})
  content["pet"] = %* pet.mapIt(%*{"id": it.id, "name": it.name})
  resp content

proc detailShelterObjectApiView*(db: DbConn, section, objectId: string): Future[JsonNode] {.async.} =
  result = newJObject()
  if section == "staff":
    let item = db.select(Staff, "\"Staff\".id = $1" % $objectId.parseInt)[0]
    result = %* item
    result["birthDate"] = %* item.birthDate.toStr
  elif section == "manager":
    let item = db.select(Manager, "\"Manager\".id = $1" % $objectId.parseInt)[0]
    result["firstname"] = %* item.firstname
    result["lastname"] = %* item.lastname
    result["birthDate"] = %* item.birthDate.toStr
    result["post"] = %* item.post
    result["id"] = %* item.id
  elif section == "pet":
    let item = db.select(Pet, "\"Pet\".id = $1" % $objectId.parseInt)[0]
    result = %* item

template createShelterObjectApiView*(): untyped =
  let data = request.body.parseJson
  if data.hasKey("birthDate"):
    data["birthDate"] = %(data["birthDate"].getStr.toUnix)
  case @"section":
  of "manager":
    data["id"] = %(dbShelter.count(Manager) + 1)
    var item = data.to(Manager)
    dbShelter.insert(item, force=true)
  of "staff":
    data["id"] = %(dbShelter.count(Staff) + 1)
    var item = data.to(Staff)
    dbShelter.insert(item, force=true)
  of "pet":
    data["id"] = %(dbShelter.count(Pet) + 1)
    var item = data.to(Pet)
    dbShelter.insert(item, force=true)
  %*{"status": "OK"}