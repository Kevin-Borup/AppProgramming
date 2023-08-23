using MongoDB.Bson.Serialization.Attributes;

namespace WebApi_Datagrid.Models
{
    public class Image
    {
        [BsonId]
        public int Id { get; set; }
        public string Image64 { get; set; }
        public string Name { get; set; }
        public int Width { get; set; }
        public int Height { get; set; }
        public int Size { get; set; }

        public string FileType { get; set; }
    }
}
