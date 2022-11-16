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
    public class AvionesController : Controller
    {
        private ProyectoBDDEntities db = new ProyectoBDDEntities();

        // GET: Aviones
        public ActionResult Index()
        {
            var avion = db.Avion.Include(a => a.TipoAvion);
            return View(avion.ToList());
        }

        // GET: Aviones/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Avion avion = db.Avion.Find(id);
            if (avion == null)
            {
                return HttpNotFound();
            }
            return View(avion);
        }

        // GET: Aviones/Create
        public ActionResult Create()
        {
            ViewBag.idTipoAvion = new SelectList(db.TipoAvion, "idTipoAvion", "Tipo");
            return View();
        }

        // POST: Aviones/Create
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "idAvion,idTipoAvion,Compañia,Carga,Alcance")] Avion avion)
        {
            if (ModelState.IsValid)
            {
                db.Avion.Add(avion);
                db.SaveChanges();
                db.SP_INGRESAR_TRANLOG("Commit", "Insert", "Avion");
                return RedirectToAction("Index");
            }

            ViewBag.idTipoAvion = new SelectList(db.TipoAvion, "idTipoAvion", "Tipo", avion.idTipoAvion);
            return View(avion);
        }

        // GET: Aviones/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Avion avion = db.Avion.Find(id);
            if (avion == null)
            {
                return HttpNotFound();
            }
            ViewBag.idTipoAvion = new SelectList(db.TipoAvion, "idTipoAvion", "Tipo", avion.idTipoAvion);
            return View(avion);
        }

        // POST: Aviones/Edit/5
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "idAvion,idTipoAvion,Compañia,Carga,Alcance")] Avion avion)
        {
            if (ModelState.IsValid)
            {
                db.Entry(avion).State = EntityState.Modified;
                db.SaveChanges();
                db.SP_INGRESAR_TRANLOG("Commit", "Update", "Avion");
                return RedirectToAction("Index");
            }
            ViewBag.idTipoAvion = new SelectList(db.TipoAvion, "idTipoAvion", "Tipo", avion.idTipoAvion);
            return View(avion);
        }

        // GET: Aviones/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Avion avion = db.Avion.Find(id);
            if (avion == null)
            {
                return HttpNotFound();
            }
            return View(avion);
        }

        // POST: Aviones/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Avion avion = db.Avion.Find(id);
            db.Avion.Remove(avion);
            db.SaveChanges();
            db.SP_INGRESAR_TRANLOG("Commit", "Delte", "Avion");
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
