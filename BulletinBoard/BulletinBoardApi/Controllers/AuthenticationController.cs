using BulletinBoardApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace BulletinBoardApi.Controllers
{
    [ApiController]
    [Route("api/Bulletin/[controller]")]
    public class AuthenticationController : Controller
    {
        public IActionResult Login(Login userLogin)
        {
            if (userLogin == null)
            {
                return Unauthorized();
            } else if (userLogin.Username.Equals("TestName") && userLogin.Password.Equals("TestPass"))
            {
                var secretKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes("RandomSecretKey"));
                var creds = new SigningCredentials(secretKey, SecurityAlgorithms.HmacSha512);
                var tokenOptions = new JwtSecurityToken(
                    issuer: "https://localhost:32773",
                    audience: "https://localhost:32773",
                    claims: new List<Claim>(),
                    expires: DateTime.Now.AddMinutes(15),
                    signingCredentials: creds
                );
                var tokenString = new JwtSecurityTokenHandler().WriteToken(tokenOptions);
                return Ok(new AccessToken { Token = tokenString });
            } else
            {
                return Unauthorized();
            }
        }
    }
}
