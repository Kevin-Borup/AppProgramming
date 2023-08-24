using Microsoft.AspNetCore.Mvc;
using WebApi_Datagrid.Models;
using WebApp_FlutterDatagrid1.Services;

namespace WebApi_Datagrid.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class FlutDatagridController : ControllerBase
    {
        private readonly ImagesService _imageService;

        public FlutDatagridController(ImagesService imagesService) => 
            _imageService = imagesService;

        [HttpGet]
        public async Task<List<Image>> Get() => await _imageService.GetAsync();

        [HttpPost]
        public async Task<IActionResult> Post(Image newImage)
        {
            await _imageService.CreateAsync(newImage);

            return CreatedAtAction(nameof(Get), new {id = newImage._id}, newImage);
        }
    }
}