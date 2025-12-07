using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class CarritoCompra
    {
        [Key]
        public int CarritoId { get; set; }

        [Required]
        public int UsuarioId { get; set; }

        [Required]
        public int ProductoId { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "La cantidad debe ser mayor a 0")]
        public int Cantidad { get; set; } = 1;

        [Display(Name = "Fecha Agregado")]
        public DateTime FechaAgregado { get; set; } = DateTime.Now;

        // Propiedad calculada
        [NotMapped]
        public decimal Subtotal => Cantidad * (Producto?.PrecioFinal ?? 0);

        // Navegación
        [ForeignKey("UsuarioId")]
        public virtual Usuario? Usuario { get; set; }

        [ForeignKey("ProductoId")]
        public virtual Producto? Producto { get; set; }
    }
}