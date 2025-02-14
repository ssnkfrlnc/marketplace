#!/bin/bash

# Apply schema validation to all usecase collections
mongosh application_name --eval '
  db.getCollectionNames().forEach(coll => {
    if (coll !== "versions") {
      db.runCommand({
        "collMod": coll,
        "validator": { "$jsonSchema": $(cat usecase.schema.json) }
      })
    }
})'

# Apply schema validation to versions collection
mongosh application_name --eval '
  db.getCollectionNames().forEach(coll => {
    if (coll == "versions") {
        db.runCommand({
            "collMod": "versions",
            "validator": { "$jsonSchema": '$(cat versions.schema.json)' }
        })
    }
})'
