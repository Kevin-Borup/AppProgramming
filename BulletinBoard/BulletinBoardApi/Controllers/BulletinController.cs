using BulletinBoardApi.Models;
using BulletinBoardApi.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using MongoDB.Driver;

namespace BulletinBoardApi.Controllers
{
    [Authorize(Roles ="User")]
    [ApiController]
    [Route("api/[controller]")]
    public class BulletinController : ControllerBase
    {
        private readonly BulletinService _bulletinService;

        public BulletinController(BulletinService bulletinService) =>
            _bulletinService = bulletinService;

        //ImgMdl

        [HttpGet("ImgMdl")]
        public async Task<List<ImageModelDB>> GetImgMdl() => await _bulletinService.GetImgMdlsAsync();

        [HttpPost("ImgMdl")]
        public async Task<IActionResult> PostImgMdl(ImageModelDB newImgMdl)
        {
            await _bulletinService.CreateImgMdlAsync(newImgMdl);

            return CreatedAtAction(nameof(GetImgMdl), new { id = newImgMdl._id }, newImgMdl);
        }

        [HttpPut("ImgMdl")]
        public async Task<IActionResult> UpdateImgMdl(ImageModelDB updatedImgMdl)
        {
            await _bulletinService.UpdateImgMdlAsync(updatedImgMdl._id.ToString(), updatedImgMdl);

            return Ok();
        }

        [HttpDelete("ImgMdl/{id}")]
        public async Task<IActionResult> DeleteImgMdl(string id)
        {
            await _bulletinService.RemoveImgMdlAsync(id);

            return Ok();
        }

        [HttpDelete("ImgMdlAll")]
        public async Task<IActionResult> DeleteAllImgMdls()
        {
            await _bulletinService.RemoveAllImgMdlsAsync();

            return Ok();
        }

        //Img

        [HttpGet("Img")]
        public async Task<List<ImageDB>> GetImg() => await _bulletinService.GetImgsAsync();

        [HttpPost("Img")]
        public async Task<IActionResult> PostImg(ImageDB newImage)
        {
            await _bulletinService.CreateImgAsync(newImage);

            return CreatedAtAction(nameof(GetImg), new { id = newImage._id }, newImage);
        }

        [HttpDelete("Img/{id}")]
        public async Task<IActionResult> DeleteImg(string id)
        {
            await _bulletinService.RemoveImgAsync(id);

            return Ok();
        }

        [HttpDelete("ImgAll")]
        public async Task<IActionResult> DeleteImgsAll()
        {
            await _bulletinService.RemoveAllImgsAsync();

            return Ok();
        }
    }
}
