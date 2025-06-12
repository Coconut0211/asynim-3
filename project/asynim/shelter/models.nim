import norm/[postgres, model]

type
  Post* = enum
    NONE, Директор, Бухгалтер, Ветеринар
  Person* = ref object of Model
    firstname*: string
    lastname*: string
    birthDate*: int64
  Manager* = ref object of Person
    post*: Post
  Staff* = ref object of Person
    uid*: int
  Pet* = ref object of Model
    name*: string
    age*: int 

proc newManager*(firstname: string = "", lastname: string = "",
                birthDate: int64 = 0, post: Post = NONE): Manager =
  Manager(
    firstname: firstname,
    lastname: lastname,
    birthDate: birthDate,
    post: post
  )

proc newStaff*(firstname: string = "", lastname: string = "",
                birthDate: int64 = 0, uid: int = 0): Staff =
  Staff(
    firstname: firstname,
    lastname: lastname,
    birthDate: birthDate,
    uid: uid
  )

proc newPet*(name: string = "", age: int = 0,): Pet =
  Pet(
    name: name,
    age: age
  )

proc initShelter*(db: DbConn) =
  db.createTables(newManager())
  db.createTables(newStaff())
  db.createTables(newPet())
