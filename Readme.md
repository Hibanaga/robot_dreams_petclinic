# Домашнє завдання - NoSQL

### Домашнє завдання було виконано за допомогою Studio 3T який дуже добре працює з mongoDB базами
Ініціалізація:

```textmate
name: "Lesson 14 - NoSql"

services:
  mongo:
    image: mongo
    ports:
      - "27018:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: root
      CONNECTION_URL: mongodb://root:root@localhost:27018
```

1.Створення бази даних та колекцій:
* Назвіть базу даних як gymDatabase

![create_database.png](create_database.png)

* Створіть колекції: clients, memberships, workouts, trainers

2. Визначення схеми документів:
* Clients: client_id, name, age, email
* Memberships: membership_id, client_id, start_date, end_date, type
* Workouts: workout_id, description, difficulty
* Trainers: trainer_id, name, specialization


```textmate
db.createCollection("clients", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["client_id", "name", "age", "email"],
      properties: {
        client_id: { 
            bsonType: "string" 
        },
        name: { 
            bsonType: "string" 
        },
        age: { 
            bsonType: "int", 
            minimum: 0, 
            maximum: 100 
        },
        email: { 
            bsonType: "string", 
            pattern: "^.+@.+\\..+$" 
        }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});

db.clients.createIndex({ client_id: 1 }, { unique: true });
```

## Response:

```textmate
db.getCollectionInfos({ name: "clients" });

[
    {
        "name" : "clients",
        "type" : "collection",
        "options" : {
            "validator" : {
                "$jsonSchema" : {
                    "bsonType" : "object",
                    "required" : [
                        "client_id",
                        "name",
                        "age",
                        "email"
                    ],
                    "properties" : {
                        "client_id" : {
                            "bsonType" : "string"
                        },
                        "name" : {
                            "bsonType" : "string"
                        },
                        "age" : {
                            "bsonType" : "int",
                            "minimum" : 0.0,
                            "maximum" : 100.0
                        },
                        "email" : {
                            "bsonType" : "string",
                            "pattern" : "^.+@.+\\..+$"
                        }
                    }
                }
            },
            "validationLevel" : "strict",
            "validationAction" : "error"
        },
        "info" : {
            "readOnly" : false,
            "uuid" : UUID("f03157a9-c5ff-45dd-8cd6-dd063739af4f")
        },
        "idIndex" : {
            "v" : 2.0,
            "key" : {
                "_id" : 1.0
            },
            "name" : "_id_"
        }
    }
]
```


```textmate
db.createCollection("memberships", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["membership_id", "client_id", "start_date", "end_date", "type"],
      properties: {
        membership_id: { 
            bsonType: "string" 
        },
        client_id: { 
            bsonType: "string"
        },
        start_date: { 
            bsonType: "date"
        },
        end_date: { 
            bsonType: "date"
        },
        type: { 
            enum: ["default", "premium"] 
        }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
});
```

```textmate
db.getCollectionInfos({ name: "memberships" });

[
    {
        "name" : "memberships",
        "type" : "collection",
        "options" : {
            "validator" : {
                "$jsonSchema" : {
                    "bsonType" : "object",
                    "required" : [
                        "membership_id",
                        "client_id",
                        "start_date",
                        "end_date",
                        "type"
                    ],
                    "properties" : {
                        "membership_id" : {
                            "bsonType" : "string"
                        },
                        "client_id" : {
                            "bsonType" : "string"
                        },
                        "start_date" : {
                            "bsonType" : "date"
                        },
                        "end_date" : {
                            "bsonType" : "date"
                        },
                        "type" : {
                            "enum" : [
                                "default",
                                "premium"
                            ]
                        }
                    }
                }
            },
            "validationLevel" : "strict",
            "validationAction" : "error"
        },
        "info" : {
            "readOnly" : false,
            "uuid" : UUID("8ecfc9ae-4ee2-4cfe-a653-3a66acf7b4f0")
        },
        "idIndex" : {
            "v" : 2.0,
            "key" : {
                "_id" : 1.0
            },
            "name" : "_id_"
        }
    }
]
```


```textmate
db.createCollection("workouts", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["workout_id", "description", "difficulty"],
            properties: {
                workout_id: {
                    bsonType: "string"
                },
                description: {
                    bsonType: "string"
                },
                difficulty: {
                    enum: [ "low", "medium", "high" ]
                }
            }
        }
    },
    validationLevel: "strict",
    validationAction: "error",
});

db.workouts.createIndex({ workout_id: 1 }, { unique: true });
```


```textmate
db.getCollectionInfos({ name: "workouts" });

[
    {
        "name" : "workouts",
        "type" : "collection",
        "options" : {
            "validator" : {
                "$jsonSchema" : {
                    "bsonType" : "object",
                    "required" : [
                        "workout_id",
                        "description",
                        "difficulty"
                    ],
                    "properties" : {
                        "workout_id" : {
                            "bsonType" : "string"
                        },
                        "description" : {
                            "bsonType" : "string"
                        },
                        "difficulty" : {
                            "enum" : [
                                "low",
                                "medium",
                                "high"
                            ]
                        }
                    }
                }
            },
            "validationLevel" : "strict",
            "validationAction" : "error"
        },
        "info" : {
            "readOnly" : false,
            "uuid" : UUID("ed197e7c-5ca8-4fca-a49a-b89ec0ef12db")
        },
        "idIndex" : {
            "v" : 2.0,
            "key" : {
                "_id" : 1.0
            },
            "name" : "_id_"
        }
    }
]
```



```textmate
db.createCollection("trainers", {
    validator: {
        $jsonSchema: {
            bsonType: "object",
            required: ["trainer_id", "name", "specialization"],
            properties: {
                trainer_id: {
                    bsonType: "string",
                    description: "must be unique string and is required",
                },
                name: {
                    bsonType: "string",
                    description: "must be date and is required",
                },
                specialization: {
                    enum: [ "Mage", "Rogue", "Warrior" ],
                    description: "can only be one of the enum values and is required"
                }
            }
        },
    },
    validationLevel: "strict",
    validationAction: "error",
});

db.trainers.createIndex({ trainer_id: 1 }, { unique: true });
```


```textmate
db.getCollectionInfos({ name: "trainers" });

[
    {
        "name" : "trainers",
        "type" : "collection",
        "options" : {
            "validator" : {
                "$jsonSchema" : {
                    "bsonType" : "object",
                    "required" : [
                        "trainer_id",
                        "name",
                        "specialization"
                    ],
                    "properties" : {
                        "trainer_id" : {
                            "bsonType" : "string",
                            "description" : "must be unique string and is required"
                        },
                        "name" : {
                            "bsonType" : "string",
                            "description" : "must be date and is required"
                        },
                        "specialization" : {
                            "enum" : [
                                "Mage",
                                "Rogue",
                                "Warrior"
                            ],
                            "description" : "can only be one of the enum values and is required"
                        }
                    }
                }
            },
            "validationLevel" : "strict",
            "validationAction" : "error"
        },
        "info" : {
            "readOnly" : false,
            "uuid" : UUID("215a9d90-7adc-4137-b70e-9a5df1b0d53d")
        },
        "idIndex" : {
            "v" : 2.0,
            "key" : {
                "_id" : 1.0
            },
            "name" : "_id_"
        }
    }
]
```


3. Заповнення колекцій даними:
* Додайте кілька записів до кожної колекції

### Дані було згенеровано на запиту до ChatGPT

```textmate
db.clients.insertMany([
  {
    client_id: "a1f4c8e9d1",
    name: "Albert Camus",
    age: 46,
    email: "camus.albert@example.com"
  },
  {
    client_id: "b7d8f2a3e6",
    name: "George Orwell",
    age: 46,
    email: "orwell.george@example.com"
  },
  {
    client_id: "c2a7e4d5b9",
    name: "Jane Austen",
    age: 41,
    email: "austen.jane@example.com"
  },
  {
    client_id: "d9e2f6b1a4",
    name: "Fyodor Dostoevsky",
    age: 59,
    email: "dostoevsky.fyodor@example.com"
  },
  {
    client_id: "e5b3d7c8f1",
    name: "Franz Kafka",
    age: 40,
    email: "kafka.franz@example.com"
  },
  {
    client_id: "f8a6e1d9b2",
    name: "Virginia Woolf",
    age: 59,
    email: "woolf.virginia@example.com"
  },
  {
    client_id: "a9b4c7d2e5",
    name: "Mark Twain",
    age: 74,
    email: "twain.mark@example.com"
  },
  {
    client_id: "b2d7e5a8f3",
    name: "Leo Tolstoy",
    age: 82,
    email: "tolstoy.leo@example.com"
  },
  {
    client_id: "c5f1a2d8b7",
    name: "Gabriel Garcia Marquez",
    age: 87,
    email: "marquez.gabriel@example.com"
  },
  {
    client_id: "d7b2e8f5a1",
    name: "Haruki Murakami",
    age: 75,
    email: "murakami.haruki@example.com"
  }
]);
```

```textmate
db.getCollection("clients").find({})

{
    "_id" : ObjectId("680debc6d4a801b4f0ea7e2d"),
    "client_id" : "a1f4c8e9d1",
    "name" : "Albert Camus",
    "age" : NumberInt(46),
    "email" : "camus.albert@example.com"
}
{
    "_id" : ObjectId("680debc6d4a801b4f0ea7e2e"),
    "client_id" : "b7d8f2a3e6",
    "name" : "George Orwell",
    "age" : NumberInt(46),
    "email" : "orwell.george@example.com"
}
{
    "_id" : ObjectId("680debc6d4a801b4f0ea7e2f"),
    "client_id" : "c2a7e4d5b9",
    "name" : "Jane Austen",
    "age" : NumberInt(41),
    "email" : "austen.jane@example.com"
}
{
    "_id" : ObjectId("680debc6d4a801b4f0ea7e30"),
    "client_id" : "d9e2f6b1a4",
    "name" : "Fyodor Dostoevsky",
    "age" : NumberInt(59),
    "email" : "dostoevsky.fyodor@example.com"
}
{
    "_id" : ObjectId("680debc6d4a801b4f0ea7e31"),
    "client_id" : "e5b3d7c8f1",
    "name" : "Franz Kafka",
    "age" : NumberInt(40),
    "email" : "kafka.franz@example.com"
}
{
    "_id" : ObjectId("680debc6d4a801b4f0ea7e32"),
    "client_id" : "f8a6e1d9b2",
    "name" : "Virginia Woolf",
    "age" : NumberInt(59),
    "email" : "woolf.virginia@example.com"
}
{
    "_id" : ObjectId("680debc6d4a801b4f0ea7e33"),
    "client_id" : "a9b4c7d2e5",
    "name" : "Mark Twain",
    "age" : NumberInt(74),
    "email" : "twain.mark@example.com"
}
{
    "_id" : ObjectId("680debc6d4a801b4f0ea7e34"),
    "client_id" : "b2d7e5a8f3",
    "name" : "Leo Tolstoy",
    "age" : NumberInt(82),
    "email" : "tolstoy.leo@example.com"
}
{
    "_id" : ObjectId("680debc6d4a801b4f0ea7e35"),
    "client_id" : "c5f1a2d8b7",
    "name" : "Gabriel Garcia Marquez",
    "age" : NumberInt(87),
    "email" : "marquez.gabriel@example.com"
}
{
    "_id" : ObjectId("680debc6d4a801b4f0ea7e36"),
    "client_id" : "d7b2e8f5a1",
    "name" : "Haruki Murakami",
    "age" : NumberInt(75),
    "email" : "murakami.haruki@example.com"
}
```

```textmate
db.memberships.insertMany([
  {
    membership_id: "a1f4c8e9d1",
    client_id: "a1f4c8e9d1",
    start_date: new Date("2024-01-01"),
    end_date: new Date("2025-01-01"),
    type: "premium"
  },
  {
    membership_id: "b7d8f2a3e6",
    client_id: "b7d8f2a3e6",
    start_date: new Date("2024-03-01"),
    end_date: new Date("2025-03-01"),
    type: "default"
  },
  {
    membership_id: "c2a7e4d5b9",
    client_id: "c2a7e4d5b9",
    start_date: new Date("2024-05-15"),
    end_date: new Date("2025-05-15"),
    type: "premium"
  },
  {
    membership_id: "d9e2f6b1a4",
    client_id: "d9e2f6b1a4",
    start_date: new Date("2024-06-10"),
    end_date: new Date("2025-06-10"),
    type: "default"
  }
]);
```

```textmate
{
    "_id" : ObjectId("680df067d4a801b4f0ea7e47"),
    "membership_id" : "a1f4c8e9d1",
    "client_id" : "a1f4c8e9d1",
    "start_date" : ISODate("2024-01-01T00:00:00.000+0000"),
    "end_date" : ISODate("2025-01-01T00:00:00.000+0000"),
    "type" : "premium"
}
{
    "_id" : ObjectId("680df067d4a801b4f0ea7e48"),
    "membership_id" : "b7d8f2a3e6",
    "client_id" : "b7d8f2a3e6",
    "start_date" : ISODate("2024-03-01T00:00:00.000+0000"),
    "end_date" : ISODate("2025-03-01T00:00:00.000+0000"),
    "type" : "default"
}
{
    "_id" : ObjectId("680df067d4a801b4f0ea7e49"),
    "membership_id" : "c2a7e4d5b9",
    "client_id" : "c2a7e4d5b9",
    "start_date" : ISODate("2024-05-15T00:00:00.000+0000"),
    "end_date" : ISODate("2025-05-15T00:00:00.000+0000"),
    "type" : "premium"
}
{
    "_id" : ObjectId("680df067d4a801b4f0ea7e4a"),
    "membership_id" : "d9e2f6b1a4",
    "client_id" : "d9e2f6b1a4",
    "start_date" : ISODate("2024-06-10T00:00:00.000+0000"),
    "end_date" : ISODate("2025-06-10T00:00:00.000+0000"),
    "type" : "default"
}
```


```textmate
db.workouts.insertMany([
  {
    workout_id: "w1a1f4c8e9",
    description: "Philosophical meditation and breathing exercises",
    difficulty: "low"
  },
  {
    workout_id: "w1b7d8f2a3",
    description: "Orwellian endurance running",
    difficulty: "medium"
  },
  {
    workout_id: "w1c2a7e4d5",
    description: "Regency era dance cardio",
    difficulty: "low"
  },
  {
    workout_id: "w1d9e2f6b1",
    description: "Dostoevsky deep squats and deadlifts",
    difficulty: "high"
  },
  {
    workout_id: "w1e5b3d7c8",
    description: "Kafka labyrinth obstacle course",
    difficulty: "high"
  },
  {
    workout_id: "w1f8a6e1d9",
    description: "Woolf peaceful yoga flows",
    difficulty: "low"
  },
  {
    workout_id: "w1a9b4c7d2",
    description: "Twain Mississippi river kayaking",
    difficulty: "medium"
  },
  {
    workout_id: "w1b2d7e5a8",
    description: "Tolstoy endurance horseback riding",
    difficulty: "high"
  },
  {
    workout_id: "w1c5f1a2d8",
    description: "Marquez magical realism swimming sessions",
    difficulty: "medium"
  },
  {
    workout_id: "w1d7b2e8f5",
    description: "Murakami long-distance marathon training",
    difficulty: "high"
  }
]);
```

```textmate
db.getCollection("workouts").find({})

{
    "_id" : ObjectId("680df175d4a801b4f0ea7e4b"),
    "workout_id" : "w1a1f4c8e9",
    "description" : "Philosophical meditation and breathing exercises",
    "difficulty" : "low"
}
{
    "_id" : ObjectId("680df175d4a801b4f0ea7e4c"),
    "workout_id" : "w1b7d8f2a3",
    "description" : "Orwellian endurance running",
    "difficulty" : "medium"
}
{
    "_id" : ObjectId("680df175d4a801b4f0ea7e4d"),
    "workout_id" : "w1c2a7e4d5",
    "description" : "Regency era dance cardio",
    "difficulty" : "low"
}
{
    "_id" : ObjectId("680df175d4a801b4f0ea7e4e"),
    "workout_id" : "w1d9e2f6b1",
    "description" : "Dostoevsky deep squats and deadlifts",
    "difficulty" : "high"
}
{
    "_id" : ObjectId("680df175d4a801b4f0ea7e4f"),
    "workout_id" : "w1e5b3d7c8",
    "description" : "Kafka labyrinth obstacle course",
    "difficulty" : "high"
}
{
    "_id" : ObjectId("680df175d4a801b4f0ea7e50"),
    "workout_id" : "w1f8a6e1d9",
    "description" : "Woolf peaceful yoga flows",
    "difficulty" : "low"
}
{
    "_id" : ObjectId("680df175d4a801b4f0ea7e51"),
    "workout_id" : "w1a9b4c7d2",
    "description" : "Twain Mississippi river kayaking",
    "difficulty" : "medium"
}
{
    "_id" : ObjectId("680df175d4a801b4f0ea7e52"),
    "workout_id" : "w1b2d7e5a8",
    "description" : "Tolstoy endurance horseback riding",
    "difficulty" : "high"
}
{
    "_id" : ObjectId("680df175d4a801b4f0ea7e53"),
    "workout_id" : "w1c5f1a2d8",
    "description" : "Marquez magical realism swimming sessions",
    "difficulty" : "medium"
}
{
    "_id" : ObjectId("680df175d4a801b4f0ea7e54"),
    "workout_id" : "w1d7b2e8f5",
    "description" : "Murakami long-distance marathon training",
    "difficulty" : "high"
}
```

```textmate
db.trainers.insertMany([
  {
    trainer_id: "t1a1f4c8e9",
    name: "Gandalf the Grey",
    specialization: "Mage"
  },
  {
    trainer_id: "t1b7d8f2a3",
    name: "Ezio Auditore",
    specialization: "Rogue"
  },
  {
    trainer_id: "t1c2a7e4d5",
    name: "Aragorn Elessar",
    specialization: "Warrior"
  },
  {
    trainer_id: "t1d9e2f6b1",
    name: "Merlin Ambrosius",
    specialization: "Mage"
  },
  {
    trainer_id: "t1e5b3d7c8",
    name: "Arya Stark",
    specialization: "Rogue"
  },
  {
    trainer_id: "t1f8a6e1d9",
    name: "Leonidas of Sparta",
    specialization: "Warrior"
  }
]);
```

```textmate
db.trainers.find({});

{
    "_id" : ObjectId("680df25c924c5f1328ea7e0f"),
    "trainer_id" : "t1a1f4c8e9",
    "name" : "Gandalf the Grey",
    "specialization" : "Mage"
}
{
    "_id" : ObjectId("680df25c924c5f1328ea7e10"),
    "trainer_id" : "t1b7d8f2a3",
    "name" : "Ezio Auditore",
    "specialization" : "Rogue"
}
{
    "_id" : ObjectId("680df25c924c5f1328ea7e11"),
    "trainer_id" : "t1c2a7e4d5",
    "name" : "Aragorn Elessar",
    "specialization" : "Warrior"
}
{
    "_id" : ObjectId("680df25c924c5f1328ea7e12"),
    "trainer_id" : "t1d9e2f6b1",
    "name" : "Merlin Ambrosius",
    "specialization" : "Mage"
}
{
    "_id" : ObjectId("680df25c924c5f1328ea7e13"),
    "trainer_id" : "t1e5b3d7c8",
    "name" : "Arya Stark",
    "specialization" : "Rogue"
}
{
    "_id" : ObjectId("680df25c924c5f1328ea7e14"),
    "trainer_id" : "t1f8a6e1d9",
    "name" : "Leonidas of Sparta",
    "specialization" : "Warrior"
}
```


4. Запити:
* Знайдіть всіх клієнтів віком понад 30 років

```textmate
    db.clients.find({
        age: { $gt: 30 }
    });
```

```textmate
    {
        "_id" : ObjectId("680debc6d4a801b4f0ea7e2d"),
        "client_id" : "a1f4c8e9d1",
        "name" : "Albert Camus",
        "age" : NumberInt(46),
        "email" : "camus.albert@example.com"
    }
    {
        "_id" : ObjectId("680debc6d4a801b4f0ea7e2e"),
        "client_id" : "b7d8f2a3e6",
        "name" : "George Orwell",
        "age" : NumberInt(46),
        "email" : "orwell.george@example.com"
    }
    {
        "_id" : ObjectId("680debc6d4a801b4f0ea7e2f"),
        "client_id" : "c2a7e4d5b9",
        "name" : "Jane Austen",
        "age" : NumberInt(41),
        "email" : "austen.jane@example.com"
    }
    {
        "_id" : ObjectId("680debc6d4a801b4f0ea7e30"),
        "client_id" : "d9e2f6b1a4",
        "name" : "Fyodor Dostoevsky",
        "age" : NumberInt(59),
        "email" : "dostoevsky.fyodor@example.com"
    }
    {
        "_id" : ObjectId("680debc6d4a801b4f0ea7e31"),
        "client_id" : "e5b3d7c8f1",
        "name" : "Franz Kafka",
        "age" : NumberInt(40),
        "email" : "kafka.franz@example.com"
    }
    {
        "_id" : ObjectId("680debc6d4a801b4f0ea7e32"),
        "client_id" : "f8a6e1d9b2",
        "name" : "Virginia Woolf",
        "age" : NumberInt(59),
        "email" : "woolf.virginia@example.com"
    }
    {
        "_id" : ObjectId("680debc6d4a801b4f0ea7e33"),
        "client_id" : "a9b4c7d2e5",
        "name" : "Mark Twain",
        "age" : NumberInt(74),
        "email" : "twain.mark@example.com"
    }
    {
        "_id" : ObjectId("680debc6d4a801b4f0ea7e34"),
        "client_id" : "b2d7e5a8f3",
        "name" : "Leo Tolstoy",
        "age" : NumberInt(82),
        "email" : "tolstoy.leo@example.com"
    }
    {
        "_id" : ObjectId("680debc6d4a801b4f0ea7e35"),
        "client_id" : "c5f1a2d8b7",
        "name" : "Gabriel Garcia Marquez",
        "age" : NumberInt(87),
        "email" : "marquez.gabriel@example.com"
    }
    {
        "_id" : ObjectId("680debc6d4a801b4f0ea7e36"),
        "client_id" : "d7b2e8f5a1",
        "name" : "Haruki Murakami",
        "age" : NumberInt(75),
        "email" : "murakami.haruki@example.com"
    }
```

* Перелічіть тренування із середньою складністю

```textmate
    db.workouts.find({
        difficulty: "medium", 
    });
```

```textmate
    {
        "_id" : ObjectId("680df175d4a801b4f0ea7e4c"),
        "workout_id" : "w1b7d8f2a3",
        "description" : "Orwellian endurance running",
        "difficulty" : "medium"
    }
    {
        "_id" : ObjectId("680df175d4a801b4f0ea7e51"),
        "workout_id" : "w1a9b4c7d2",
        "description" : "Twain Mississippi river kayaking",
        "difficulty" : "medium"
    }
    {
        "_id" : ObjectId("680df175d4a801b4f0ea7e53"),
        "workout_id" : "w1c5f1a2d8",
        "description" : "Marquez magical realism swimming sessions",
        "difficulty" : "medium"
    }
```

* Покажіть інформацію про членство клієнта з певним client_id

```textmate
List all memberships with client info:

db.memberships.aggregate([
    {
        $lookup: {
            from: "clients",
            localField: "client_id",
            foreignField: "client_id",
            as: "client"
        }
    },
    { $unwind: "$client" },
    {
        $project: {
          membership_id: 1,
          start_date: 1,
          end_date: 1,
          type: 1,
          "client.name": 1,
          "client.age": 1,
          "client.email": 1
        }
    }
])


Find Single memberships information with relations data:

db.memberships.aggregate([
    {
        $match: { client_id: "a1f4c8e9d1" }
    },
    {
        $lookup: {
            from: "clients",
            localField: "client_id",
            foreignField: "client_id",
            as: "client"
        }
    },
    { $unwind: "$client" },
    {
        $project: {
          membership_id: 1,
          client_id: 1,
          start_date: 1,
          end_date: 1,
          type: 1,
          "client.name": 1,
          "client.age": 1,
          "client.email": 1
        }
    }
])
```

