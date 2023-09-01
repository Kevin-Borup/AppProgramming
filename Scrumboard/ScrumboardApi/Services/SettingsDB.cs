namespace ScrumboardApi.Services
{
    public class SettingsDB
    {
        public string ConnectionString { get; set; } = null!;
        public string DatabaseName { get; set; } = null!;
        public string CardsCollectionName { get; set; } = null!;
    }
}
