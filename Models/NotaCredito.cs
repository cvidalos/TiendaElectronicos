
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class NotaCredito
    {
        [Key]
        public int NotaCreditoId { get; set; }

        [Required]
        public int ComprobanteVentaId { get; set; }

        [Required]
        public int PedidoId { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "Serie")]
        public string SerieNotaCredito { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Número")]
        public string NumeroNotaCredito { get; set; }

        [NotMapped]
        [Display(Name = "Número Completo")]
        public string NumeroNotaCreditoCompleto => $"{SerieNotaCredito}-{NumeroNotaCredito}";

        [Required]
        [StringLength(50)]
        [Display(Name = "Tipo de Nota")]
        public string TipoNota { get; set; }

        [Required]
        [StringLength(500)]
        public string Motivo { get; set; }

        [Display(Name = "Fecha de Emisión")]
        public DateTime FechaEmision { get; set; } = DateTime.Now;

        [Required]
        [Column(TypeName = "decimal(10,2)")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal Subtotal { get; set; }

        [Required]
        [Column(TypeName = "decimal(10,2)")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal IGV { get; set; }

        [Required]
        [Column(TypeName = "decimal(10,2)")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal Total { get; set; }

        [StringLength(20)]
        public string Estado { get; set; } = "Emitida";

        [StringLength(500)]
        [Display(Name = "Ruta PDF")]
        public string RutaPDF { get; set; }

        public string Observaciones { get; set; }

        // Navegación
        [ForeignKey("ComprobanteVentaId")]
        public virtual ComprobanteVenta ComprobanteVenta { get; set; }

        [ForeignKey("PedidoId")]
        public virtual Pedido Pedido { get; set; }

        public virtual ICollection<DetalleNotaCredito> DetallesNotaCredito { get; set; }
    }
}