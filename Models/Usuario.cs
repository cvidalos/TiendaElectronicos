using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class Usuario
    {
        [Key]
        public int UsuarioId { get; set; }

        [Required]
        public int RolId { get; set; }

        [Required(ErrorMessage = "El nombre de usuario es requerido")]
        [StringLength(50)]
        [Display(Name = "Nombre de Usuario")]
        public string? NombreUsuario { get; set; }

        [Required(ErrorMessage = "El email es requerido")]
        [EmailAddress(ErrorMessage = "Email no válido")]
        [StringLength(100)]
        public string? Email { get; set; }

        [Required(ErrorMessage = "La contraseña es requerida")]
        [StringLength(255)]
        [DataType(DataType.Password)]
        [Display(Name = "Contraseña")]
        public string? PasswordHash { get; set; }

        [Required(ErrorMessage = "Los nombres son requeridos")]
        [StringLength(100)]
        public string? Nombres { get; set; }

        [Required(ErrorMessage = "Los apellidos son requeridos")]
        [StringLength(100)]
        public string? Apellidos { get; set; }

        [StringLength(20)]
        [Display(Name = "Tipo de Documento")]
        public string? TipoDocumento { get; set; }

        [StringLength(20)]
        [Display(Name = "Número de Documento")]
        public string? NumeroDocumento { get; set; }

        [StringLength(20)]
        [Display(Name = "Teléfono")]
        public string? Telefono { get; set; }

        [StringLength(255)]
        [Display(Name = "Dirección")]
        public string? Direccion { get; set; }

        [StringLength(100)]
        public string? Ciudad { get; set; }

        [StringLength(10)]
        [Display(Name = "Código Postal")]
        public string? CodigoPostal { get; set; }

        [StringLength(50)]
        [Display(Name = "País")]
        public string? Pais { get; set; } = "Perú";

        [Display(Name = "Fecha de Registro")]
        public DateTime FechaRegistro { get; set; } = DateTime.Now;

        [Display(Name = "Último Acceso")]
        public DateTime? UltimoAcceso { get; set; }

        public bool? Activo { get; set; } = true;

        [NotMapped]
        [Display(Name = "Nombre Completo")]
        public string NombreCompleto => $"{Nombres} {Apellidos}";

        // Navegación
        [ForeignKey("RolId")]
        public virtual Rol? Rol { get; set; }
        public virtual ICollection<Pedido>? Pedidos { get; set; }
        public virtual ICollection<CarritoCompra>? CarritoCompras { get; set; }
        public virtual ICollection<HistorialEstadoPedido>? HistorialEstados { get; set; }
        public virtual ICollection<ComprobanteDeposito>? ComprobantesValidados { get; set; }
      
    }
}