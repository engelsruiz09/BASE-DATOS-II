using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ProyectoBDD.Models;

namespace ProyectoBDD.Controllers
{
    public class TranLogsController : Controller
    {
        private ProyectoBDDEntities db = new ProyectoBDDEntities();
        public static DateTime fechaI;
        public static DateTime fechaF;

        // GET: TranLogs
        public ActionResult Index()
        {
            return View(db.TranLog.ToList());
        }

        [HttpPost]
        public ActionResult Index(FormCollection collection)
        {
            try
            {
                fechaI = Convert.ToDateTime(collection["fechaI"]);
                fechaF = Convert.ToDateTime(collection["fechaF"]);
                return RedirectToAction("Search");
            }
            catch (Exception)
            {
                return View();
            }
        }

        // GET: TranLogs/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            TranLog tranLog = db.TranLog.Find(id);
            if (tranLog == null)
            {
                return HttpNotFound();
            }
            return View(tranLog);
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }

        public ActionResult Search()
        {
            return View(db.SP_LOGS_FECHA(fechaI, fechaF).ToList());
        }
    }
}
