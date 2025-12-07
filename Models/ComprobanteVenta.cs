using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class ComprobanteVenta
    {
        [Key]
        public int ComprobanteVentaId { get; set; }

        [Required]
        public int PedidoId { get; set; }

        [Required]
        public int NotaPedidoId { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Tipo de Comprobante")]
        public string TipoComprobante { get; set; }

        [Required]
        [StringLength(10)]
        [Display(Name = "Serie")]
        public string SerieComprobante { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Número")]
        public string NumeroComprobante { get; set; }

        [Display(Name = "Número Completo")]
        [NotMapped]
        public string NumeroComprobanteCompleto => $"{SerieComprobante}-{NumeroComprobante}";

        [Display(Name = "Fecha de Emisión")]
        public DateTime FechaEmision { get; set; } = DateTime.Now;

        [StringLength(200)]
        [Display(Name = "Razón Social")]
        public string RazonSocial { get; set; }

        [StringLength(20)]
        [Display(Name = "Documento")]
        public string NumeroDocumento { get; set; }

        [StringLength(255)]
        [Display(Name = "Dirección del Cliente")]
        public string DireccionCliente { get; set; }

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

        [Display(Name = "Fecha de Anulación")]
        public DateTime? FechaAnulacion { get; set; }

        [StringLength(500)]
        [Display(Name = "Motivo de Anulación")]
        public string MotivoAnulacion { get; set; }

        [StringLength(500)]
        [Display(Name = "Ruta PDF")]
        public string RutaPDF { get; set; }

        // Navegación
        [ForeignKey("PedidoId")]
        public virtual Pedido Pedido { get; set; }

        [ForeignKey("NotaPedidoId")]
        public virtual NotaPedido NotaPedido { get; set; }

        public virtual ICollection<NotaCredito> NotasCredito { get; set; }
        public virtual ICollection<NotaDebito> NotasDebito { get; set; }
    }
}