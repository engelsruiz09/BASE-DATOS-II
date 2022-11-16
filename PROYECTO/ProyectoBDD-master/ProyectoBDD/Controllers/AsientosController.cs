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
    public class AsientosController : Controller
    {
        private ProyectoBDDEntities db = new ProyectoBDDEntities();

        // GET: Asientos
        public ActionResult Index()
        {
            var asiento = db.Asiento.Include(a => a.Avion).Include(a => a.TipoAsiento);
            return View(asiento.ToList());
        }

        // GET: Asientos/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Asiento asiento = db.Asiento.Find(id);
            if (asiento == null)
            {
                return HttpNotFound();
            }
            return View(asiento);
        }

        // GET: Asientos/Create
        public ActionResult Create()
        {
            ViewBag.idAvion = new SelectList(db.Avion, "idAvion", "Compañia");
            ViewBag.idTipoAsiento = new SelectList(db.TipoAsiento, "idTipoAsiento", "Tipo");
            return View();
        }

        // POST: Asientos/Create
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "idAsiento,idAvion,idTipoAsiento,Cantidad")] Asiento asiento)
        {
            if (ModelState.IsValid)
            {
                db.Asiento.Add(asiento);
                db.SaveChanges();
                db.SP_INGRESAR_TRANLOG("Commit", "Insert", "Asiento");
                return RedirectToAction("Index");
            }

            ViewBag.idAvion = new SelectList(db.Avion, "idAvion", "Compañia", asiento.idAvion);
            ViewBag.idTipoAsiento = new SelectList(db.TipoAsiento, "idTipoAsiento", "Tipo", asiento.idTipoAsiento);
            return View(asiento);
        }

        // GET: Asientos/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Asiento asiento = db.Asiento.Find(id);
            if (asiento == null)
            {
                return HttpNotFound();
            }
            ViewBag.idAvion = new SelectList(db.Avion, "idAvion", "Compañia", asiento.idAvion);
            ViewBag.idTipoAsiento = new SelectList(db.TipoAsiento, "idTipoAsiento", "Tipo", asiento.idTipoAsiento);
            return View(asiento);
        }

        // POST: Asientos/Edit/5
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "idAsiento,idAvion,idTipoAsiento,Cantidad")] Asiento asiento)
        {
            if (ModelState.IsValid)
            {
                db.Entry(asiento).State = EntityState.Modified;
                db.SaveChanges();
                db.SP_INGRESAR_TRANLOG("Commit", "Update", "Asiento");
                return RedirectToAction("Index");
            }
            ViewBag.idAvion = new SelectList(db.Avion, "idAvion", "Compañia", asiento.idAvion);
            ViewBag.idTipoAsiento = new SelectList(db.TipoAsiento, "idTipoAsiento", "Tipo", asiento.idTipoAsiento);
            return View(asiento);
        }

        // GET: Asientos/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Asiento asiento = db.Asiento.Find(id);
            if (asiento == null)
            {
                return HttpNotFound();
            }
            return View(asiento);
        }

        // POST: Asientos/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Asiento asiento = db.Asiento.Find(id);
            db.Asiento.Remove(asiento);
            db.SaveChanges();
            db.SP_INGRESAR_TRANLOG("Commit", "Delete", "Asiento");
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
    }
}
