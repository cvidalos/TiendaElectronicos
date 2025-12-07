using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class DetalleNotaDebito
    {
        [Key]
        public int DetalleNotaDebitoId { get; set; }

        [Required]
        public int NotaDebitoId { get; set; }

        [Required(ErrorMessage = "El concepto es requerido")]
        [StringLength(200)]
        [Display(Name = "Concepto")]
        public string Concepto { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "La cantidad debe ser mayor a 0")]
        public int Cantidad { get; set; } = 1;

        [Required(ErrorMessage = "El precio unitario es requerido")]
        [Range(0.01, 999999.99, ErrorMessage = "El precio debe ser mayor a 0")]
        [Column(TypeName = "decimal(10,2)")]
        [Display(Name = "Precio Unitario")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal PrecioUnitario { get; set; }

        [Required]
        [Column(TypeName = "decimal(10,2)")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal Subtotal { get; set; }

        // Navegación
        [ForeignKey("NotaDebitoId")]
        public virtual NotaDebito NotaDebito { get; set; }
    }
}