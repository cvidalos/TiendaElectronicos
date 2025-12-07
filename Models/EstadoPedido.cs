using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TiendaElectronica.Models
{
    public class EstadoPedido
    {
        [Key]
        public int EstadoId { get; set; }

        [Required]
        [StringLength(50)]
        [Display(Name = "Nombre del Estado")]
        public string NombreEstado { get; set; }

        [StringLength(200)]
        [Display(Name = "Descripción")]
        public string Descripcion { get; set; }

        [Required]
        public int Orden { get; set; }

        [StringLength(20)]
        public string Color { get; set; }

        public bool Activo { get; set; } = true;

        // Navegación
        public virtual ICollection<Pedido> Pedidos { get; set; }
        public virtual ICollection<HistorialEstadoPedido> HistorialEstados { get; set; }
    }
}