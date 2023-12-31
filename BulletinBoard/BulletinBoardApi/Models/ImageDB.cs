﻿using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;
using MongoDB.Bson.Serialization.IdGenerators;

namespace BulletinBoardApi.Models
{
    public class ImageDB
    {
        [BsonId(IdGenerator = typeof(ObjectIdGenerator))]
        public ObjectId? _id { get; set; }
        public string Image64 { get; set; }
    }
}
