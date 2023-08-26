using BulletinBoardApi.Models;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using static System.Net.Mime.MediaTypeNames;

namespace BulletinBoardApi.Services
{
    public class BulletinService
    {
        private readonly IMongoCollection<ImageDB> _imagesCollection;
        private readonly IMongoCollection<ImageModelDB> _boardCollection;

        public BulletinService(
            IOptions<SettingsDB> settings)
        {
            var mongoClient = new MongoClient(
                settings.Value.ConnectionString);

            var mongoDatabase = mongoClient.GetDatabase(
                settings.Value.DatabaseName);

            _imagesCollection = mongoDatabase.GetCollection<ImageDB>(
                settings.Value.ImagesCollectionName);

            _boardCollection = mongoDatabase.GetCollection<ImageModelDB>(
                settings.Value.BoardCollectionName);
        }
        //ImgMdl
        public async Task<List<ImageModelDB>> GetImgMdlsAsync() =>
            await _boardCollection.Find(_ => true).ToListAsync();
        
        public async Task CreateImgMdlAsync(ImageModelDB newImgMdl) =>
            await _boardCollection.InsertOneAsync(newImgMdl);

        public async Task UpdateImgMdlAsync(string id, ImageModelDB updatedImgMdl) =>
            await _boardCollection.ReplaceOneAsync(x => x._id.Equals(id), updatedImgMdl);

        public async Task RemoveImgMdlAsync(string id) =>
            await _boardCollection.DeleteOneAsync(x => x._id.Equals(id));

        public async Task RemoveAllImgMdlsAsync() =>
            await _boardCollection.DeleteManyAsync(Builders<ImageModelDB>.Filter.Empty);

        //Img
        public async Task<List<ImageDB>> GetImgsAsync() =>
            await _imagesCollection.Find(_ => true).ToListAsync();

        public async Task CreateImgAsync(ImageDB newImage)
        {
            try
            {
                await _imagesCollection.InsertOneAsync(newImage);
            }
            catch (Exception e)
            {
                if (e.InnerException != null && e.InnerException.Message.Contains("Code : 11000"))
                {
                    await Console.Out.WriteLineAsync("Duplicate insert | Code: 11000");
                    //Duplicate image, won't be added.
                }
                else
                {
                    throw;
                }
            }

        }

        public async Task RemoveImgAsync(string id) =>
            await _imagesCollection.DeleteOneAsync(x => x._id.Equals(id));

        public async Task RemoveAllImgsAsync() =>
            await _imagesCollection.DeleteManyAsync(Builders<ImageDB>.Filter.Empty);
    }
}
