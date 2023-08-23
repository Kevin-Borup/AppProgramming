using Microsoft.Extensions.Options;
using MongoDB.Driver;
using WebApi_Datagrid.Models;

namespace WebApp_FlutterDatagrid1.Services
{
    public class ImagesService
    {
        private readonly IMongoCollection<Image> _imagesCollection;

        public ImagesService(
            IOptions<FlutterDatagridDatabaseSettings> flutterDatagridDatabaseSettings)
        {
            var mongoClient = new MongoClient(
                flutterDatagridDatabaseSettings.Value.ConnectionString);

            var mongoDatabase = mongoClient.GetDatabase(
                flutterDatagridDatabaseSettings.Value.DatabaseName);

            _imagesCollection = mongoDatabase.GetCollection<Image>(
                flutterDatagridDatabaseSettings.Value.ImagesCollectionName);
        }

        public async Task<List<Image>> GetAsync() =>
            await _imagesCollection.Find(_ => true).ToListAsync();

        public async Task<Image?> GetAsync(string id) =>
            await _imagesCollection.Find(x => x._id.Equals(id)).FirstOrDefaultAsync();

        public async Task CreateAsync(Image newImage) =>
            await _imagesCollection.InsertOneAsync(newImage);

        public async Task UpdateAsync(string id, Image updatedImage) =>
            await _imagesCollection.ReplaceOneAsync(x => x._id.Equals(id), updatedImage);

        public async Task RemoveAsync(string id) =>
            await _imagesCollection.DeleteOneAsync(x => x._id.Equals(id));
    }
}
