using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace TiendaElectronica.Models
{
    public class Producto
    {
        [Key]
        public int ProductoId { get; set; }

        [Required]
        public int CategoriaId { get; set; }

        [Required(ErrorMessage = "El nombre del producto es requerido")]
        [StringLength(200)]
        [Display(Name = "Nombre del Producto")]
        public string NombreProducto { get; set; }

        [Display(Name = "Descripción")]
        public string Descripcion { get; set; }

        [StringLength(100)]
        public string Marca { get; set; }

        [StringLength(100)]
        public string Modelo { get; set; }

        [Required(ErrorMessage = "El precio es requerido")]
        [Range(0.01, 999999.99, ErrorMessage = "El precio debe ser mayor a 0")]
        [Column(TypeName = "decimal(10,2)")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal Precio { get; set; }

        [Column(TypeName = "decimal(10,2)")]
        [Display(Name = "Precio de Oferta")]
        [DisplayFormat(DataFormatString = "{0:C2}")]
        public decimal? PrecioOferta { get; set; }

        [Required]
        [Range(0, int.MaxValue, ErrorMessage = "El stock debe ser mayor o igual a 0")]
        public int Stock { get; set; }

        [Display(Name = "Stock Mínimo")]
        public int StockMinimo { get; set; } = 5;

        [StringLength(100)]
        [Display(Name = "Garantía")]
        public string Garantia { get; set; }

        [Display(Name = "Especificaciones")]
        public string Especificaciones { get; set; }

        [Display(Name = "Fecha de Creación")]
        public DateTime FechaCreacion { get; set; } = DateTime.Now;

        [Display(Name = "Fecha de Modificación")]
        public DateTime? FechaModificacion { get; set; }

        public bool Activo { get; set; } = true;

        public bool Destacado { get; set; } = false;

        // Propiedades calculadas
        [NotMapped]
        [Display(Name = "Precio Final")]
        public decimal PrecioFinal => PrecioOferta ?? Precio;

        [NotMapped]
        public bool TieneOferta => PrecioOferta.HasValue && PrecioOferta < Precio;

        [NotMapped]
        public bool StockBajo => Stock <= StockMinimo && Stock > 0;

        [NotMapped]
        public bool SinStock => Stock == 0;

        [NotMapped]
        public decimal PorcentajeDescuento
        {
            get
            {
                if (TieneOferta)
                    return Math.Round(((Precio - PrecioOferta.Value) / Precio) * 100, 0);
                return 0;
            }
        }

        // Navegación
        [ForeignKey("CategoriaId")]
        public virtual Categoria Categoria { get; set; }
        public virtual ICollection<ImagenProducto> Imagenes { get; set; }
        public virtual ICollection<DetallePedido> DetallesPedido { get; set; }
        public virtual ICollection<CarritoCompra> CarritoCompras { get; set; }
    }

}
