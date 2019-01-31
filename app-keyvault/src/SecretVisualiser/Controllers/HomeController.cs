using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using SecretVisualiser.Models;

namespace SecretVisualiser.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }

        [HttpPost]
        public IActionResult GetSecrets()
        {
            var model = new SecretsViewModel();
            DirectoryInfo dirInfo = new DirectoryInfo("/kvmnt");
            var files = dirInfo.GetFiles();

            foreach (var file in files)
            {
                model.Secrets.Add(new Secret(file.Name, System.IO.File.ReadAllText(file.FullName)));
            }
            
            return View("Index", model);
        }        

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
