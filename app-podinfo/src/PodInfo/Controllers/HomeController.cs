using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using PodInfo.Models;

namespace PodInfo.Controllers
{
    public class HomeController : Controller
    {
        public IActionResult Index()
        {
            ViewBag.BackgroundColor = Environment.GetEnvironmentVariable("BACKGROUNDCOLOR") ?? "white"; ;
            ViewBag.ApplicationName = Environment.GetEnvironmentVariable("APPLICATIONNAME") ?? "PodInfo";

            ViewBag.PodName = Environment.GetEnvironmentVariable("HOSTNAME");

            return View(Request);
        }

        public IActionResult env()
        {
            ViewBag.BackgroundColor = Environment.GetEnvironmentVariable("BACKGROUNDCOLOR") ?? "white"; ;
            ViewBag.ApplicationName = Environment.GetEnvironmentVariable("APPLICATIONNAME") ?? "PodInfo";

            ViewBag.PodName = Environment.GetEnvironmentVariable("HOSTNAME");

            return View(Environment.GetEnvironmentVariables());
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }
    }
}
