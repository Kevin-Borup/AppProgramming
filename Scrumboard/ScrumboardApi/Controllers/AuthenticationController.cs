using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using ScrumboardApi.Models;
using System.IdentityModel.Tokens.Jwt;
using System.Text;

namespace ScrumboardApi.Controllers
{
    [ApiController]
    [Route("api/Scrumboard/[controller]")]
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
