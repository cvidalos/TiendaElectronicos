using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class NotaPedido
    {
        [Key]
        public int NotaPedidoId { get; set; }

        [Required]
        public int PedidoId { get; set; }

        [Required]
        [StringLength(20)]
        [Display(Name = "Número de Nota de Pedido")]
        public string NumeroNotaPedido { get; set; }

        [Display(Name = "Fecha de Emisión")]
        public DateTime FechaEmision { get; set; } = DateTime.Now;

        [StringLength(20)]
        public string Estado { get; set; } = "Emitida";

        [Display(Name = "Fecha de Devolución")]
        public DateTime? FechaDevolucion { get; set; }

        [StringLength(500)]
        [Display(Name = "Motivo de Devolución")]
        public string MotivoDevolucion { get; set; }

        [Display(Name = "Fecha de Aceptación")]
        public DateTime? FechaAceptacion { get; set; }

        public string Observaciones { get; set; }

        // Navegación
        [ForeignKey("PedidoId")]
        public virtual Pedido Pedido { get; set; }

        public virtual ICollection<ComprobanteVenta> ComprobantesVenta { get; set; }
    }
}