using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class HistorialEstadoPedido
    {
        [Key]
        public int HistorialId { get; set; }

        [Required]
        public int PedidoId { get; set; }

        [Required]
        public int EstadoId { get; set; }

        [Required]
        public int UsuarioId { get; set; }

        [Display(Name = "Fecha de Cambio")]
        public DateTime FechaCambio { get; set; } = DateTime.Now;

        [StringLength(500)]
        public string Comentario { get; set; }

        // Navegación
        [ForeignKey("PedidoId")]
        public virtual Pedido Pedido { get; set; }

        [ForeignKey("EstadoId")]
        public virtual EstadoPedido Estado { get; set; }

        [ForeignKey("UsuarioId")]
        public virtual Usuario Usuario { get; set; }
    }
}
