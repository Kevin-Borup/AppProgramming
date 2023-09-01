using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using ScrumboardApi.Models;
using ScrumboardApi.Services;

namespace ScrumboardApi.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    [Authorize]
    public class ScrumboardController : ControllerBase
    {
        private readonly ScrumboardService _scrumboardService;

        public ScrumboardController(ScrumboardService scrumboardService) => _scrumboardService = scrumboardService;

        [HttpGet("CardMdl")]
        public async Task<List<CardModel>> GetCardMdl() => await _scrumboardService.GetCardMdlsAsync();

        [HttpPost("CardMdl")]
        public async Task<IActionResult> PostCardMdl(CardModel newCardMdl)
        {
            await _scrumboardService.CreateCardMdlAsync(newCardMdl);

            return CreatedAtAction(nameof(GetCardMdl), new { id = newCardMdl.id }, newCardMdl);
        }

        [HttpPut("CardMdl")]
        public async Task<IActionResult> UpdateCardMdl(CardModel updatedCardMdl)
        {
            await _scrumboardService.UpdateCardMdlAsync(updatedCardMdl.id.ToString(), updatedCardMdl);

            return Ok();
        }

        [HttpDelete("CardMdl/{id}")]
        public async Task<IActionResult> DeleteCardMdl(string id)
        {
            await _scrumboardService.RemoveCardMdlAsync(id);

            return Ok();
        }

        [HttpDelete("CardMdlAll")]
        public async Task<IActionResult> DeleteAllCardMdls()
        {
            await _scrumboardService.RemoveAllCardMdlsAsync();

            return Ok();
        }
    }
}
