using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNetCore.Http;
using ProyectoBDD.Models;

namespace ProyectoBDD.Controllers
{
    public class VueloPasajerosController : Controller
    {
        private ProyectoBDDEntities db = new ProyectoBDDEntities();
        public static int idVuelo;

        // GET: VueloPasajeros
        public ActionResult Index()
        {
            var vueloPasajero = db.VueloPasajero.Include(v => v.Asiento).Include(v => v.Pasajero).Include(v => v.TipoEstatus).Include(v => v.Vuelo);
            return View(vueloPasajero.ToList());
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

        // GET: VueloPasajeros/Details/5
        public ActionResult Details(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            VueloPasajero vueloPasajero = db.VueloPasajero.Find(id);
            if (vueloPasajero == null)
            {
                return HttpNotFound();
            }
            return View(vueloPasajero);
        }

        // GET: VueloPasajeros/Edit/5
        public ActionResult Edit(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            VueloPasajero vueloPasajero = db.VueloPasajero.Find(id);
            if (vueloPasajero == null)
            {
                return HttpNotFound();
            }
            ViewBag.idAsiento = new SelectList(db.Asiento, "idAsiento", "idAsiento", vueloPasajero.idAsiento);
            ViewBag.idPasajero = new SelectList(db.Pasajero, "idPasajero", "Nombres", vueloPasajero.idPasajero);
            ViewBag.idTipoEstatus = new SelectList(db.TipoEstatus, "idTipoEstatus", "Estatus", vueloPasajero.idTipoEstatus);
            ViewBag.idVuelo = new SelectList(db.Vuelo, "idVuelo", "idVuelo", vueloPasajero.idVuelo);
            return View(vueloPasajero);
        }

        // POST: VueloPasajeros/Edit/5
        // Para protegerse de ataques de publicación excesiva, habilite las propiedades específicas a las que quiere enlazarse. Para obtener 
        // más detalles, vea https://go.microsoft.com/fwlink/?LinkId=317598.
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Edit([Bind(Include = "idVueloPasajero,idVuelo,idPasajero,idAsiento,NoAsiento,idTipoEstatus,Fecha")] VueloPasajero vueloPasajero)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    if (vueloPasajero.idTipoEstatus == 2)
                    {
                        db.SP_RESERVAR_ASIENTO(vueloPasajero.idVuelo, vueloPasajero.NoAsiento, vueloPasajero.idPasajero);
                    }
                    else if (vueloPasajero.idTipoEstatus == 3)
                    {
                        db.SP_CONFIRMAR_ASIENTO(vueloPasajero.idPasajero, vueloPasajero.idVuelo, vueloPasajero.NoAsiento);
                    }
                    else
                    {
                        db.SP_CANCELAR_RESERVA(vueloPasajero.idVueloPasajero);
                    }
                    return RedirectToAction("Index");
                }
                catch (Exception ex)
                {
                    int i = ex.InnerException.Message.IndexOf("Transaction");
                    ViewData["Error"] = ex.InnerException.Message.Substring(0, i);
                }
            }
            ViewBag.idAsiento = new SelectList(db.Asiento, "idAsiento", "idAsiento", vueloPasajero.idAsiento);
            ViewBag.idPasajero = new SelectList(db.Pasajero, "idPasajero", "Nombres", vueloPasajero.idPasajero);
            ViewBag.idTipoEstatus = new SelectList(db.TipoEstatus, "idTipoEstatus", "Estatus", vueloPasajero.idTipoEstatus);
            ViewBag.idVuelo = new SelectList(db.Vuelo, "idVuelo", "idVuelo", vueloPasajero.idVuelo);
            return View(vueloPasajero);
        }

        // GET: VueloPasajeros/Delete/5
        public ActionResult Delete(int? id)
        {
            if (id == null)
            {
                return new HttpStatusCodeResult(HttpStatusCode.BadRequest);
            }
            VueloPasajero vueloPasajero = db.VueloPasajero.Find(id);
            if (vueloPasajero == null)
            {
                return HttpNotFound();
            }
            return View(vueloPasajero);
        }

        // POST: VueloPasajeros/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public ActionResult DeleteConfirmed(int id)
        {
            try
            {
                db.SP_CANCELAR_RESERVA(id);
                return RedirectToAction("Index");
            }
            catch (Exception ex)
            {
                int i = ex.InnerException.Message.IndexOf("Transaction");
                ViewData["Error"] = ex.InnerException.Message.Substring(0, i);
                VueloPasajero vueloPasajero = db.VueloPasajero.Find(id);
                return View(vueloPasajero);
            }
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
            return View(db.SP_VUELO_ASIENTOS(idVuelo).ToList());
        }

        public ActionResult Members()
        {
            ViewBag.idVuelo = new SelectList(db.Vuelo, "idVuelo", "idVuelo");
            ViewBag.idPasajero = new SelectList(db.Pasajero, "idPasajero", "Nombres");
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Members([Bind(Include = "idVueloPasajero,idVuelo,idPasajero,idAsiento,NoAsiento,idTipoEstatus,Fecha")] VueloPasajero vueloPasajero)
        {
            if (ModelState.IsValid)
            {
                Pasajero pasajero = db.Pasajero.Find(vueloPasajero.idPasajero);
                if (pasajero.idTipoPasajero != 3)
                {
                    try
                    {
                        db.SP_INGRESAR_TRIPULACION(vueloPasajero.idPasajero, vueloPasajero.idVuelo);
                        return RedirectToAction("Index");
                    }
                    catch (Exception ex)
                    {
                        int i = ex.InnerException.Message.IndexOf("Transaction");
                        ViewData["Error"] = ex.InnerException.Message.Substring(0, i);
                        ViewBag.idVuelo = new SelectList(db.Vuelo, "idVuelo", "idVuelo");
                        ViewBag.idPasajero = new SelectList(db.Pasajero, "idPasajero", "Nombres");
                        return View(vueloPasajero);
                    } 
                }
                db.SP_INGRESAR_TRANLOG("Rollback", "Insert", "VueloPasajero");
                ViewData["Error"] = "No se puede asignar a un cliente a la tripulación";
            }

            ViewBag.idVuelo = new SelectList(db.Vuelo, "idVuelo", "idVuelo");
            ViewBag.idPasajero = new SelectList(db.Pasajero, "idPasajero", "Nombres");
            return View(vueloPasajero);
        }
    }
}
