/* Usage:
  1. Save this file as init-usecase-collections.js
  2. Run: mongosh your_db_name --file init-usecase-collections.js
  3. Create new collections using: createUsecaseCollection("new_usecase_name")
*/
// Initialize sample usecase collection with validation
const usecaseSchema = {
    $jsonSchema: {
      bsonType: "object",
      required: ["_id", "payload", "file_type"],
      properties: {
        _id: { bsonType: "string" },
        payload: { bsonType: "binData" },
        file_type: {
          bsonType: "string",
          enum: ["json", "yaml", "xml"]
        }
      },
      additionalProperties: false
    }
  };

  // Create sample usecase collection
  const sampleCollectionName = "sample_usecase";
  db.createCollection(sampleCollectionName, {
    validator: { $jsonSchema: usecaseSchema.$jsonSchema }
  });

  // Insert sample document with JSON payload
  const samplePayload = BinData(0, "eyJ0ZXN0IjogImRhdGEifQ=="); // Base64 encoded '{"test": "data"}'
  db.getCollection(sampleCollectionName).insertOne({
    _id: "v1.0.0",
    payload: samplePayload,
    file_type: "json"
  });

  // Validation test function
  function testValidation(collectionName) {
    try {
      db.getCollection(collectionName).insertOne({
        _id: "invalid_doc",
        file_type: "json"
      });
    } catch (e) {
      print(`Validation working: ${e.errmsg}`);
    }
  }

  // Test the schema validation
  testValidation(sampleCollectionName);

  // Helper function to create new usecase collections
  function createUsecaseCollection(collectionName) {
    db.createCollection(collectionName, {
      validator: { $jsonSchema: usecaseSchema.$jsonSchema }
    });
    print(`Created collection '${collectionName}' with schema validation`);
  }

// Versions collection init
const versionsCollection = db.getCollection("versions");

// Create unique index to enforce single document
versionsCollection.createIndex(
  { "singleton_lock": 1 },
  { unique: true, name: "single_document_lock" }
);

// Initial document structure
const initialDocument = {
  _id: new ObjectId(),
  applications: [],
  singleton_lock: 1 // Constant value for unique index
};

// Upsert the initial document
versionsCollection.updateOne(
  { singleton_lock: 1 },
  { $setOnInsert: initialDocument },
  { upsert: true }
);
