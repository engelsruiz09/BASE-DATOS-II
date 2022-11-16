using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.IO;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using ProyectoBDD.Models;

namespace ProyectoBDD.Controllers
{
    public class PasajerosController : Controller
    {
        private ProyectoBDDEntities db = new ProyectoBDDEntities();

        // GET: Pasajeros
        public ActionResult Index()
        {
            var pasajero = db.Pasajero.Include(p => p.TipoPasajero);
            return View(pasajero.ToList());
        }

        [HttpPost]
        public ActionResult Index(HttpPostedFileBase file)
        {
            try
            {
                if (file.ContentLength > 0)
                {
                    string fileName = Path.GetFileName(file.FileName);
                    string filePath = Path.Combine(Server.MapPath("~/Uploads"), fileName);
                    file.SaveAs(filePath);
                    db.SP_INGRESAR_CLIENTE_BULK(filePath);
                }
                ViewBag.Message = "Carga exitosa";
                return RedirectToAction("Index");
            }
            catch (Exception)
            {
                ViewBag.Message = "Carga fallida";
                return RedirectToAction("Index");
            }
        }

        // GET: Pasajeros/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Pasajero pasajero = db.Pasajero.Find(id);
            if (pasajero == null)
            {
                return HttpNotFound();
            }
            return View(pasajero);
        }

        // GET: Pasajeros/Create
        public ActionResult Create()
        {
            ViewBag.idTipoPasajero = new SelectList(db.TipoPasajero, "idTipoPasajero", "Tipo");
            return View();
        }

        // POST: Pasajeros/Create
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "idPasajero,idTipoPasajero,Nombres,Apellidos,Pasaporte,FechaNacimiento")] Pasajero pasajero)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    db.SP_INGRESAR_CLIENTE(pasajero.idTipoPasajero, pasajero.Nombres, pasajero.Apellidos, pasajero.Pasaporte, pasajero.FechaNacimiento);
                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    int i = ex.InnerException.Message.IndexOf("Transaction");
                    ViewData["Error"] = ex.InnerException.Message.Substring(0, i);
                }
            }

            ViewBag.idTipoPasajero = new SelectList(db.TipoPasajero, "idTipoPasajero", "Tipo", pasajero.idTipoPasajero);
            return View(pasajero);
        }

        // GET: Pasajeros/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Pasajero pasajero = db.Pasajero.Find(id);
            if (pasajero == null)
            {
                return HttpNotFound();
            }
            ViewBag.idTipoPasajero = new SelectList(db.TipoPasajero, "idTipoPasajero", "Tipo", pasajero.idTipoPasajero);
            return View(pasajero);
        }

        // POST: Pasajeros/Edit/5
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "idPasajero,idTipoPasajero,Nombres,Apellidos,Pasaporte,FechaNacimiento")] Pasajero pasajero)
        {
            if (ModelState.IsValid)
            {
                db.Entry(pasajero).State = EntityState.Modified;
                db.SaveChanges();
                db.SP_INGRESAR_TRANLOG("Commit", "Update", "Pasajero");
                return RedirectToAction("Index");
            }
            ViewBag.idTipoPasajero = new SelectList(db.TipoPasajero, "idTipoPasajero", "Tipo", pasajero.idTipoPasajero);
            return View(pasajero);
        }

        // GET: Pasajeros/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Pasajero pasajero = db.Pasajero.Find(id);
            if (pasajero == null)
            {
                return HttpNotFound();
            }
            return View(pasajero);
        }

        // POST: Pasajeros/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            Pasajero pasajero = db.Pasajero.Find(id);
            db.Pasajero.Remove(pasajero);
            db.SaveChanges();
            db.SP_INGRESAR_TRANLOG("Commit", "Delete", "Pasajero");
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
