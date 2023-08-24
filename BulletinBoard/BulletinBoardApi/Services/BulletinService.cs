using BulletinBoardApi.Models;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using static System.Net.Mime.MediaTypeNames;

namespace BulletinBoardApi.Services
{
    public class BulletinService
    {
        private readonly IMongoCollection<ImageDB> _imagesCollection;

        public BulletinService(
            IOptions<SettingsDB> settings)
        {
            var mongoClient = new MongoClient(
                settings.Value.ConnectionString);

            var mongoDatabase = mongoClient.GetDatabase(
                settings.Value.DatabaseName);

            _imagesCollection = mongoDatabase.GetCollection<ImageDB>(
                settings.Value.ImagesCollectionName);
        }

        public async Task<List<ImageDB>> GetAsync() =>
            await _imagesCollection.Find(_ => true).ToListAsync();

        public async Task<ImageDB?> GetAsync(string id) =>
            await _imagesCollection.Find(x => x._id.Equals(id)).FirstOrDefaultAsync();

        public async Task CreateAsync(ImageDB newImage) =>
            await _imagesCollection.InsertOneAsync(newImage);

        public async Task UpdateAsync(string id, ImageDB updatedImage) =>
            await _imagesCollection.ReplaceOneAsync(x => x._id.Equals(id), updatedImage);

        public async Task RemoveAsync(string id) =>
            await _imagesCollection.DeleteOneAsync(x => x._id.Equals(id));
    }
}
