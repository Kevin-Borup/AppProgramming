using BulletinBoardApi.Models;
using BulletinBoardApi.Services;
using Microsoft.AspNetCore.Mvc;

namespace BulletinBoardApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BulletinController : ControllerBase
    {
        private readonly BulletinService _bulletinService;

        public BulletinController(BulletinService bulletinService) =>
            _bulletinService = bulletinService;

        [HttpGet]
        public async Task<List<ImageDB>> Get() => await _bulletinService.GetAsync();

        [HttpPost]
        public async Task<IActionResult> Post(ImageDB newImage)
        {
            await _bulletinService.CreateAsync(newImage);

            return CreatedAtAction(nameof(Get), new { id = newImage._id }, newImage);
        }

        [HttpPut]
        public async Task<IActionResult> Update(ImageDB updatedImage)
        {
            await _bulletinService.UpdateAsync(updatedImage._id.ToString(), updatedImage);

            return Ok();
        }
    }
}
