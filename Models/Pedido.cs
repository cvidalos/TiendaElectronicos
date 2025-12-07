using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class Pedido
    {
        [Key]
        public int PedidoId { get; set; }

        [Required]
        public int UsuarioId { get; set; }

        [Required]
        public int EstadoId { get; set; }

        [Required(ErrorMessage = "Debe seleccionar el tipo de comprobante")]
        [StringLength(20)]
        [Display(Name = "Tipo de Comprobante")]
        public string TipoComprobante { get; set; }

        [StringLength(200)]
        [Display(Name = "Razón Social")]
        public string RazonSocial { get; set; }

        [StringLength(11)]
        public string RUC { get; set; }

        [StringLength(255)]
        [Display(Name = "Dirección Fiscal")]
        public string DireccionFiscal { get; set; }

        [Display(Name = "Fecha del Pedido")]
        public DateTime FechaPedido { get; set; } = DateTime.Now;

        [Display(Name = "Fecha de Actualización")]
        public DateTime FechaActualizacion { get; set; } = DateTime.Now;

        [Required]
        [Column(TypeName = "decimal(10,2)")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal Total { get; set; }

        [Required]
        [Column(TypeName = "decimal(10,2)")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal Subtotal { get; set; }

        [Column(TypeName = "decimal(10,2)")]
        [Display(Name = "IGV (18%)")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal IGV { get; set; } = 0;

        [Column(TypeName = "decimal(10,2)")]
        [Display(Name = "Costo de Envío")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal CostoEnvio { get; set; } = 0;

        [Required]
        [StringLength(255)]
        [Display(Name = "Dirección de Envío")]
        public string DireccionEnvio { get; set; }

        [Required]
        [StringLength(100)]
        public string Ciudad { get; set; }

        [StringLength(10)]
        [Display(Name = "Código Postal")]
        public string CodigoPostal { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Teléfono")]
        public string Telefono { get; set; }

        [Display(Name = "Notas del Cliente")]
        public string NotasCliente { get; set; }

        [Display(Name = "Notas Internas")]
        public string NotasInternas { get; set; }

        // Navegación
        [ForeignKey("UsuarioId")]
        public virtual Usuario Usuario { get; set; }

        [ForeignKey("EstadoId")]
        public virtual EstadoPedido Estado { get; set; }

        public virtual ICollection<DetallePedido> DetallesPedido { get; set; }
        public virtual ICollection<HistorialEstadoPedido> HistorialEstados { get; set; }
        public virtual ICollection<ComprobanteDeposito> ComprobantesDeposito { get; set; }
        public virtual NotaPedido NotaPedido { get; set; }
        public virtual ICollection<ComprobanteVenta> ComprobantesVenta { get; set; }
        public virtual ICollection<NotaCredito> NotasCredito { get; set; }
        public virtual ICollection<NotaDebito> NotasDebito { get; set; }
    }
}