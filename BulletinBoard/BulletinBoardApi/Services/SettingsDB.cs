namespace BulletinBoardApi.Services
{
    public class SettingsDB
    {
        public string ConnectionString { get; set; } = null!;
        public string DatabaseName { get; set; } = null!;
        public string ImagesCollectionName { get; set; } = null!;
        public string BoardCollectionName { get; set; } = null!;
    }
}
