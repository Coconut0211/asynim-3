import asyncdispatch
import strutils, sequtils, json
import norm/[postgres]
import models
import ../[constants, utils]

template shopApiView*() =
  var content: JsonNode = newJObject()
  let staff = dbShop.selectAll(Staff)
  let goods = dbShop.selectAll(Good)
  let cash = dbShop.selectAll(Cash)
  content["staff"] = %* staff.mapIt(%*{"id": it.id, "lastname": it.lastName})
  content["good"] = %* goods.mapIt(%*{"id": it.id, "title": it.title})
  content["cash"] = %* cash.mapIt(%*{"id": it.id, "number": it.number})
  resp content

proc detailShopObjectApiView*(db: DbConn, section, objectId: string): Future[JsonNode] {.async.} =
  result = newJObject()
  if section == "staff":
    let item = db.select(Staff, "\"Staff\".id = $1" % $objectId.parseInt)[0]
    result["firstname"] = %* item.firstName
    result["lastname"] = %* item.lastName
    result["birthDate"] = %* item.birthDate.toStr
    result["post"] = %* item.post
    result["id"] = %* item.id
  elif section == "good":
    let item = db.select(Good, "\"Good\".id = $1" % $objectId.parseInt)[0]
    result = %* item
    result["endDate"] = %* item.endDate.toStr
  elif section == "cash":
    let item = db.select(Cash, "\"Cash\".id = $1" % $objectId.parseInt)[0]
    result = %* item

template createShopObjectApiView*(): untyped =
  let data = request.body.parseJson
  if data.hasKey("birthDate"):
    data["birthDate"] = %(data["birthDate"].getStr.toUnix)
  if data.hasKey("endDate"):
    data["endDate"] = %(data["endDate"].getStr.toUnix)
  case @"section":
  of "cash":
    data["id"] = %(dbShop.count(Cash) + 1)
    var item = data.to(Cash)
    dbShop.insert(item, force=true)
  of "staff":
    data["id"] = %(dbShop.count(Staff) + 1)
    var item = data.to(Staff)
    dbShop.insert(item, force=true)
  of "good":
    data["id"] = %(dbShop.count(Good) + 1)
    var item = data.to(Good)
    dbShop.insert(item, force=true)
  %*{"status": "OK"}