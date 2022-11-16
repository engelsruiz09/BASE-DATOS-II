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
    public class VuelosController : Controller
    {
        private ProyectoBDDEntities db = new ProyectoBDDEntities();

        // GET: Vuelos
        public ActionResult Index()
        {
            var vuelo = db.Vuelo.Include(v => v.Avion);
            return View(vuelo.ToList());
        }

        // GET: Vuelos/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Vuelo vuelo = db.Vuelo.Find(id);
            if (vuelo == null)
            {
                return HttpNotFound();
            }
            return View(vuelo);
        }

        // GET: Vuelos/Create
        public ActionResult Create()
        {
            ViewBag.idAvion = new SelectList(db.Avion, "idAvion", "Compañia");
            return View();
        }

        // POST: Vuelos/Create
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Create([Bind(Include = "idVuelo,idAvion,Estatus,CiudadOrigen,CiudadDestino,AeropuertoOrigen,AeropuertoDestino,FechaSalida,FechaLlegada,Jornada")] Vuelo vuelo)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    db.SP_INGRESAR_VUELO(vuelo.idAvion, vuelo.CiudadOrigen, vuelo.CiudadDestino, vuelo.AeropuertoOrigen, vuelo.AeropuertoDestino, vuelo.FechaSalida, vuelo.FechaLlegada);
                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    ViewData["Error"] = ex.InnerException.Message;
                }
            }

            ViewBag.idAvion = new SelectList(db.Avion, "idAvion", "Compañia", vuelo.idAvion);
            return View(vuelo);
        }

        // GET: Vuelos/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Vuelo vuelo = db.Vuelo.Find(id);
            if (vuelo == null)
            {
                return HttpNotFound();
            }
            ViewBag.idAvion = new SelectList(db.Avion, "idAvion", "Compañia", vuelo.idAvion);
            return View(vuelo);
        }

        // POST: Vuelos/Edit/5
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "idVuelo,idAvion,Estatus,CiudadOrigen,CiudadDestino,AeropuertoOrigen,AeropuertoDestino,FechaSalida,FechaLlegada,Jornada")] Vuelo vuelo)
        {
            if (ModelState.IsValid)
            {
                db.Entry(vuelo).State = EntityState.Modified;
                db.SaveChanges();
                db.SP_INGRESAR_TRANLOG("Commit", "Update", "Vuelo");
                return RedirectToAction("Index");
            }
            ViewBag.idAvion = new SelectList(db.Avion, "idAvion", "Compañia", vuelo.idAvion);
            return View(vuelo);
        }

        // GET: Vuelos/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            Vuelo vuelo = db.Vuelo.Find(id);
            if (vuelo == null)
            {
                return HttpNotFound();
            }
            return View(vuelo);
        }

        // POST: Vuelos/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            try
            {
                db.SP_CANCELAR_VUELO(id);
                db.SP_INGRESAR_TRANLOG("Commit", "Update", "Pasajero");
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                ViewData["Error"] = ex.InnerException.Message;
            }
            Vuelo vuelo = db.Vuelo.Find(id);
            return View(vuelo);
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
