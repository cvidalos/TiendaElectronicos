using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TiendaElectronica.Models
{
    public class Categoria
    {
        [Key]
        public int CategoriaId { get; set; }

        [Required(ErrorMessage = "El nombre de la categoría es requerido")]
        [StringLength(100)]
        [Display(Name = "Nombre de Categoría")]
        public string NombreCategoria { get; set; }

        [StringLength(255)]
        [Display(Name = "Descripción")]
        public string Descripcion { get; set; }

        public bool Activo { get; set; } = true;

        [Display(Name = "Fecha de Creación")]
        public DateTime FechaCreacion { get; set; } = DateTime.Now;

        // Navegación
        public virtual ICollection<Producto> Productos { get; set; }
    }
}