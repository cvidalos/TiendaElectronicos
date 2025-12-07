using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace TiendaElectronica.Models
{
    public class CuentaBancaria
    {
        [Key]
        public int CuentaId { get; set; }

        [Required(ErrorMessage = "El nombre del banco es requerido")]
        [StringLength(100)]
        public string Banco { get; set; }

        [Required(ErrorMessage = "El tipo de cuenta es requerido")]
        [StringLength(50)]
        [Display(Name = "Tipo de Cuenta")]
        public string TipoCuenta { get; set; }

        [Required(ErrorMessage = "El número de cuenta es requerido")]
        [StringLength(50)]
        [Display(Name = "Número de Cuenta")]
        public string NumeroCuenta { get; set; }

        [StringLength(50)]
        public string CCI { get; set; }

        [Required(ErrorMessage = "El titular es requerido")]
        [StringLength(200)]
        public string Titular { get; set; }

        [StringLength(10)]
        public string Moneda { get; set; } = "PEN";

        public bool Activo { get; set; } = true;

        public int Orden { get; set; } = 0;

        // Navegación
        public virtual ICollection<ComprobanteDeposito> ComprobantesDeposito { get; set; }
    }
}
