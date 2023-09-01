using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson.Serialization.IdGenerators;

namespace ScrumboardApi.Models
{
    public class CardModel
    {
        [BsonId(IdGenerator = typeof(ObjectIdGenerator))]
        public ObjectId? id { get; set; }
        public string ColumnId { get; set; }
        public string Title { get; set; }
        public string Text { get; set; }
        public string Date { get; set; }
    }
}
