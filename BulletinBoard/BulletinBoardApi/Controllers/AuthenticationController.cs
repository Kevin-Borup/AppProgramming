using BulletinBoardApi.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
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
        IConfiguration configuration;
        public AuthenticationController(IConfiguration configuration)
        {
            this.configuration = configuration;
        }


        [HttpPost("Login")]
        public IActionResult Login([FromBody] Login userLogin)
        {
            IActionResult response = Unauthorized();

            if (userLogin != null)
            {
                if (userLogin.Username.Equals("TestName") && userLogin.Password.Equals("TestPass"))
                {
                    var issuer = configuration["Jwt:Issuer"];
                    var audience = configuration["Jwt:Audience"];
                    var key = Encoding.UTF8.GetBytes(configuration["Jwt:Key"]);
                    var signingCredentials = new SigningCredentials(
                                            new SymmetricSecurityKey(key),
                                            SecurityAlgorithms.HmacSha512Signature
                                        );

                    var expires = DateTime.UtcNow.AddMinutes(15);

                    //var subject = new ClaimsIdentity(new[]
                    //{
                    //new Claim(ClaimTypes.Role, "User")
                    //});

                    var tokenDescriptor = new SecurityTokenDescriptor
                    {
                        Expires = DateTime.UtcNow.AddMinutes(10),
                        Issuer = issuer,
                        Audience = audience,
                        SigningCredentials = signingCredentials
                    };

                    var tokenHandler = new JwtSecurityTokenHandler();
                    var token = tokenHandler.CreateToken(tokenDescriptor);
                    var jwtToken = tokenHandler.WriteToken(token);

                    return Ok(new Token { FullToken = jwtToken });
                }
            }

            return response;
        }
    }
}
