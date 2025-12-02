using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class ImagenProducto
    {
        [Key]
        public int ImagenId { get; set; }

        [Required]
        public int ProductoId { get; set; }

        [Required]
        [StringLength(500)]
        [Display(Name = "Ruta de Imagen")]
        public string RutaImagen { get; set; }

        [Display(Name = "Es Principal")]
        public bool EsPrincipal { get; set; } = false;

        public int Orden { get; set; } = 0;

        [Display(Name = "Fecha de Carga")]
        public DateTime FechaCarga { get; set; } = DateTime.Now;

        // Navegación
        [ForeignKey("ProductoId")]
        public virtual Producto Producto { get; set; }
    }
}
