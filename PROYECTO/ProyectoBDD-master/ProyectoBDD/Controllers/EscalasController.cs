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
    public class EscalasController : Controller
    {
        private ProyectoBDDEntities db = new ProyectoBDDEntities();
        public static int idVuelo;

        // GET: Escalas
        public ActionResult Index()
        {
            var escala = db.Escala.Include(e => e.Vuelo);
            return View(escala.ToList());
        }

        [HttpPost]
        public ActionResult Index(FormCollection collection)
        {
            try
            {
                idVuelo = Convert.ToInt32(collection["idVuelo"]);
                return RedirectToAction("Search");
            }
            catch (Exception)
            {
                return View();
            }
        }

        // GET: Escalas/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Escala escala = db.Escala.Find(id);
            if (escala == null)
            {
                return HttpNotFound();
            }
            return View(escala);
        }

        // GET: Escalas/Create
        public ActionResult Create()
        {
            ViewBag.idVuelo = new SelectList(db.Vuelo, "idVuelo", "idVuelo");
            return View();
        }

        // POST: Escalas/Create
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "idEscala,idVuelo,Destino,FechaHora")] Escala escala)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    db.SP_INGRESAR_ESCALA(escala.idVuelo, escala.Destino, escala.FechaHora);
                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    int i = ex.InnerException.Message.IndexOf("Transaction");
                    ViewData["Error"] = ex.InnerException.Message.Substring(0, i);
                }
            }

            ViewBag.idVuelo = new SelectList(db.Vuelo, "idVuelo", "idVuelo", escala.idVuelo);
            return View(escala);
        }

        // GET: Escalas/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Escala escala = db.Escala.Find(id);
            if (escala == null)
            {
                return HttpNotFound();
            }
            ViewBag.idVuelo = new SelectList(db.Vuelo, "idVuelo", "idVuelo", escala.idVuelo);
            return View(escala);
        }

        // POST: Escalas/Edit/5
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "idEscala,idVuelo,Destino,FechaHora")] Escala escala)
        {
            if (ModelState.IsValid)
            {
                db.Entry(escala).State = EntityState.Modified;
                db.SaveChanges();
                db.SP_INGRESAR_TRANLOG("Commit", "Update", "Escala");
                return RedirectToAction("Index");
            }
            ViewBag.idVuelo = new SelectList(db.Vuelo, "idVuelo", "idVuelo", escala.idVuelo);
            return View(escala);
        }

        // GET: Escalas/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Escala escala = db.Escala.Find(id);
            if (escala == null)
            {
                return HttpNotFound();
            }
            return View(escala);
        }

        // POST: Escalas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Escala escala = db.Escala.Find(id);
            db.Escala.Remove(escala);
            db.SaveChanges();
            db.SP_INGRESAR_TRANLOG("Commit", "Delete", "Escala");
            return RedirectToAction("Index");
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
            return View(db.SP_VUELO_ESCALAS(idVuelo).ToList());
        }
    }
}
