using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class ComprobanteDeposito
    {
        [Key]
        public int ComprobanteDepositoId { get; set; }

        [Required]
        public int PedidoId { get; set; }

        public int? CuentaId { get; set; }

        [StringLength(50)]
        [Display(Name = "Número de Operación")]
        public string NumeroOperacion { get; set; }

        [Display(Name = "Fecha de Depósito")]
        public DateTime? FechaDeposito { get; set; }

        [Required(ErrorMessage = "El monto depositado es requerido")]
        [Column(TypeName = "decimal(10,2)")]
        [Display(Name = "Monto Depositado")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal MontoDepositado { get; set; }

        [StringLength(500)]
        [Display(Name = "Comprobante (Imagen)")]
        public string RutaComprobante { get; set; }

        public bool Validado { get; set; } = false;

        [Display(Name = "Fecha de Validación")]
        public DateTime? FechaValidacion { get; set; }

        [Display(Name = "Usuario Validador")]
        public int? UsuarioValidadorId { get; set; }

        [StringLength(500)]
        [Display(Name = "Observaciones de Validación")]
        public string ObservacionesValidacion { get; set; }

        [Display(Name = "Fecha de Registro")]
        public DateTime FechaRegistro { get; set; } = DateTime.Now;

        // Navegación
        [ForeignKey("PedidoId")]
        public virtual Pedido Pedido { get; set; }

        [ForeignKey("CuentaId")]
        public virtual CuentaBancaria CuentaBancaria { get; set; }

        [ForeignKey("UsuarioValidadorId")]
        public virtual Usuario UsuarioValidador { get; set; }
    }
}