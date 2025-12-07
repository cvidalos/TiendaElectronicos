// =============================================
// ARCHIVO: NotaDebito.cs
// =============================================
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class NotaDebito
    {
        [Key]
        public int NotaDebitoId { get; set; }

        [Required]
        public int ComprobanteVentaId { get; set; }

        [Required]
        public int PedidoId { get; set; }

        [Required(ErrorMessage = "La serie es requerida")]
        [StringLength(10)]
        [Display(Name = "Serie")]
        public string SerieNotaDebito { get; set; }

        [Required(ErrorMessage = "El número es requerido")]
        [StringLength(20)]
        [Display(Name = "Número")]
        public string NumeroNotaDebito { get; set; }

        [NotMapped]
        [Display(Name = "Número Completo")]
        public string NumeroNotaDebitoCompleto => $"{SerieNotaDebito}-{NumeroNotaDebito}";

        [Required(ErrorMessage = "El tipo de nota es requerido")]
        [StringLength(50)]
        [Display(Name = "Tipo de Nota")]
        public string TipoNota { get; set; }

        [Required(ErrorMessage = "El motivo es requerido")]
        [StringLength(500)]
        [Display(Name = "Motivo")]
        public string Motivo { get; set; }

        [Display(Name = "Fecha de Emisión")]
        public DateTime FechaEmision { get; set; } = DateTime.Now;

        [Required]
        [Range(0, 999999.99, ErrorMessage = "El subtotal debe ser mayor o igual a 0")]
        [Column(TypeName = "decimal(10,2)")]
        [Display(Name = "Subtotal")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal Subtotal { get; set; }

        [Required]
        [Range(0, 999999.99, ErrorMessage = "El IGV debe ser mayor o igual a 0")]
        [Column(TypeName = "decimal(10,2)")]
        [Display(Name = "IGV (18%)")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal IGV { get; set; }

        [Required]
        [Range(0.01, 999999.99, ErrorMessage = "El total debe ser mayor a 0")]
        [Column(TypeName = "decimal(10,2)")]
        [Display(Name = "Total")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal Total { get; set; }

        [StringLength(20)]
        [Display(Name = "Estado")]
        public string Estado { get; set; } = "Emitida";

        [StringLength(500)]
        [Display(Name = "Ruta PDF")]
        public string RutaPDF { get; set; }

        [Display(Name = "Observaciones")]
        public string Observaciones { get; set; }

        // Navegación
        [ForeignKey("ComprobanteVentaId")]
        public virtual ComprobanteVenta ComprobanteVenta { get; set; }

        [ForeignKey("PedidoId")]
        public virtual Pedido Pedido { get; set; }

        public virtual ICollection<DetalleNotaDebito> DetallesNotaDebito { get; set; }
    }
}