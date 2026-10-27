use college

db.createCollection("students")

db.students.insertOne({ roll: 1, name: "Amit", dept: "Computer", marks: 85, city: "Mumbai" })

db.students.insertMany([
  { roll: 2, name: "Priya", dept: "IT", marks: 92, city: "Pune" },
  { roll: 3, name: "Rahul", dept: "Computer", marks: 67, city: "Mumbai" },
  { roll: 4, name: "Sneha", dept: "EXTC", marks: 74, city: "Nashik" },
  { roll: 5, name: "Karan", dept: "IT", marks: 55, city: "Pune", skills: ["Python", "SQL"] }
])

show collections

db.students.find()
db.students.find().pretty()
db.students.findOne({ name: "Amit" })
db.students.find({ dept: "Computer" })
db.students.find({ marks: { $gt: 70 } })
db.students.find({ $and: [{ dept: "IT" }, { marks: { $gte: 60 } }] })
db.students.find({ $or: [{ city: "Pune" }, { city: "Nashik" }] })
db.students.find({ dept: { $in: ["IT", "EXTC"] } })
db.students.find({}, { name: 1, marks: 1, _id: 0 })
db.students.find().sort({ marks: -1 })
db.students.find().sort({ marks: -1 }).limit(2)
db.students.countDocuments({ dept: "IT" })

db.students.updateOne({ name: "Rahul" }, { $set: { marks: 72 } })
db.students.updateMany({ dept: "IT" }, { $inc: { marks: 5 } })
db.students.updateOne({ name: "Sneha" }, { $set: { email: "sneha@college.edu" } })
db.students.updateOne({ name: "Karan" }, { $push: { skills: "MongoDB" } })
db.students.updateOne({ name: "Amit" }, { $unset: { city: "" } })
db.students.replaceOne({ roll: 4 }, { roll: 4, name: "Sneha Patil", dept: "EXTC", marks: 80 })
db.students.find()

db.students.aggregate([
  { $group: { _id: "$dept", avgMarks: { $avg: "$marks" }, total: { $sum: 1 } } }
])

db.students.createIndex({ roll: 1 })
db.students.getIndexes()

db.students.deleteOne({ name: "Karan" })
db.students.deleteMany({ marks: { $lt: 75 } })
db.students.find()

db.students.drop()
db.dropDatabase()
