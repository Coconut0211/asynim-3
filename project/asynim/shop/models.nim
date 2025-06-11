import norm/[postgres, model]

type
  Post* = enum
    NONE, Кассир, Уборщик, Консультант, Менеджер, Директор

  Staff* = ref object of Model
    firstName*: string
    lastName*: string
    birthDate*: int64
    post*: Post

  Good* = ref object of Model
    title*: string
    price*: float
    endDate*: int64
    discount*: float
    count*: int64

  Cash* = ref object of Model
    number*: int
    free*: bool
    totalCash*: float

proc newGood*(title: string = "", price: float = 0,
                endDate: int64 = 0, discount: float = 0, count: int64 = 0): Good =
  Good(
    title: title,
    price: price,
    endDate: endDate,
    discount: discount,
    count: count
  )

proc newStaff*(firstname: string = "", lastname: string = "",
                birthDate: int64 = 0, post: Post = NONE): Staff =
  Staff(
    firstname: firstname,
    lastname: lastname,
    birthDate: birthDate,
    post: post
  )

proc newCash*(number: int = 0, free: bool = true,
                totalCash: float = 0): Cash =
  Cash(
    number: number,
    free: free,
    totalCash: totalCash
  )

proc initShop*(db: DbConn) =
  db.createTables(newGood())
  db.createTables(newStaff())
  db.createTables(newCash())
