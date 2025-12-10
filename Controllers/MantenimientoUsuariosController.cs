using Microsoft.AspNetCore.Mvc;
using TiendaElectronica.Models;
using TiendaElectronica.Repositorio;
namespace TiendaElectronica.Controllers
{
    public class MantenimientoUsuariosController : Controller
    {
        IUsuarioRepositorio _usuarios;

        public MantenimientoUsuariosController(IUsuarioRepositorio usuarios)
        {
            _usuarios = usuarios;
        }

        public IActionResult UsuarioCRUD(int? id, string op)
        {
            ViewBag.op = op ?? "0";
            ViewBag.usuarios = _usuarios.Listado();

            if (id == null)
            {
                // nuevo
                return View(new Usuario());
            }
            else
            {
                // editar
                ViewBag.op = "1";
                var reg = _usuarios.Buscar(id.Value);
                return View(reg);
            }
        }

        [HttpPost][ValidateAntiForgeryToken]public IActionResult UsuarioCRUD(Usuario reg, string op)
        {
            ViewBag.usuarios = _usuarios.Listado();

            if (!ModelState.IsValid)
            {
                ViewBag.op = op ?? "0";
                ViewBag.usuarios = _usuarios.Listado();
                return View(reg);
            }

            string mensaje;

            if (string.IsNullOrEmpty(op) || op == "0")
            {
                mensaje = _usuarios.Agregar(reg);
             
                op = "1";
            }
            else if (op == "1")
            {
                mensaje = _usuarios.Actualizar(reg);
             
            }
            else
            {
                mensaje = "Operación no reconocida";
            }
           
            ModelState.AddModelError("", mensaje);
            ViewBag.op = op;
            ViewBag.usuarios = _usuarios.Listado();
            return View(reg);
        }
        public IActionResult Delete(int id)
        {
            string mensaje = _usuarios.Eliminar(id);
           TempData["mensaje"] = mensaje;

           return RedirectToAction("UsuarioCRUD");
        }
    }
}