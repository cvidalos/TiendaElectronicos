using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{

    public class Rol
    {
        [Key]
        public int RolId { get; set; }

        [Required(ErrorMessage = "El nombre del rol es requerido")]
        [StringLength(50)]
        [Display(Name = "Nombre del Rol")]
        public string NombreRol { get; set; }

        [StringLength(200)]
        [Display(Name = "Descripción")]
        public string Descripcion { get; set; }

        [Display(Name = "Fecha de Creación")]
        public DateTime FechaCreacion { get; set; } = DateTime.Now;

        public bool Activo { get; set; } = true;

        public virtual ICollection<Usuario> Usuarios { get; set; }
    }
}