using Microsoft.Extensions.Options;
using MongoDB.Driver;
using ScrumboardApi.Models;

namespace ScrumboardApi.Services
{
    public class ScrumboardService
    {
        private readonly IMongoCollection<CardModel> _cardsCollection;

        public ScrumboardService(IOptions<SettingsDB> settings)
        {
            var mongoClient = new MongoClient(settings.Value.ConnectionString);
            var mongoDatabase = mongoClient.GetDatabase(settings.Value.DatabaseName);
            _cardsCollection = mongoDatabase.GetCollection<CardModel>(settings.Value.CardsCollectionName);
        }

        public async Task<List<CardModel>> GetCardMdlsAsync() =>
            await _cardsCollection.Find(_ => true).ToListAsync();

        public async Task CreateCardMdlAsync(CardModel newCardMdl) =>
            await _cardsCollection.InsertOneAsync(newCardMdl);

        public async Task UpdateCardMdlAsync(string id, CardModel updatedCardMdl) =>
            await _cardsCollection.ReplaceOneAsync(x => x.id.Equals(id), updatedCardMdl);

        public async Task RemoveCardMdlAsync(string id) =>
            await _cardsCollection.DeleteOneAsync(x => x.id.Equals(id));

        public async Task RemoveAllCardMdlsAsync() =>
            await _cardsCollection.DeleteManyAsync(Builders<CardModel>.Filter.Empty);
    }
}
