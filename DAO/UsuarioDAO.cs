using Microsoft.Data.SqlClient;
using System.Data;
using TiendaElectronica.Models;
using TiendaElectronica.Repositorio;

namespace TiendaElectronica.DAO
{
    public class UsuarioDAO : IUsuarioRepositorio
    {
        string  cadena = (new ConfigurationBuilder().AddJsonFile("appsettings.json").Build()).GetConnectionString("cn") ?? string.Empty;
        
        public IEnumerable<Usuario> Listado()
        {
            List<Usuario> lista = new();

            using (SqlConnection cn = new SqlConnection(cadena))
            {
                using (SqlCommand cmd = new SqlCommand("usp_usuarios_listar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cn.Open();

                    using (SqlDataReader dr = cmd.ExecuteReader())
                    {
                        while (dr.Read())
                        {
                            lista.Add(new Usuario
                            {
                                UsuarioId = dr.GetInt32(dr.GetOrdinal("UsuarioId")),
                                RolId = dr.GetInt32(dr.GetOrdinal("RolId")),
                                NombreUsuario = dr.GetString(dr.GetOrdinal("NombreUsuario")),
                                Email = dr.GetString(dr.GetOrdinal("Email")),
                                PasswordHash = dr.GetString(dr.GetOrdinal("PasswordHash")),
                                Nombres = dr.GetString(dr.GetOrdinal("Nombres")),
                                Apellidos = dr.GetString(dr.GetOrdinal("Apellidos")),
                                TipoDocumento = dr["TipoDocumento"] as string,
                                NumeroDocumento = dr["NumeroDocumento"] as string,
                                Telefono = dr["Telefono"] as string,
                                Direccion = dr["Direccion"] as string,
                                Ciudad = dr["Ciudad"] as string,
                                CodigoPostal = dr["CodigoPostal"] as string,
                                Pais = dr["Pais"] as string,
                                FechaRegistro = dr.GetDateTime(dr.GetOrdinal("FechaRegistro")),
                                UltimoAcceso = dr["UltimoAcceso"] == DBNull.Value
                                    ? (DateTime?)null
                                    : Convert.ToDateTime(dr["UltimoAcceso"]),
                                Activo = dr["Activo"] == DBNull.Value
                                    ? (bool?)null
                                    : Convert.ToBoolean(dr["Activo"])
                            });
                        }
                    }
                }
            }

            return lista;
        }

        public string Agregar(Usuario entity)
        {
            string mensaje = "";
            try
            {
                using (SqlConnection cn = new SqlConnection(cadena))
                using (SqlCommand cmd = new SqlCommand("usp_usuarios_agregar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@RolId", entity.RolId);
                    cmd.Parameters.AddWithValue("@NombreUsuario", entity.NombreUsuario);
                    cmd.Parameters.AddWithValue("@Email", entity.Email);
                    cmd.Parameters.AddWithValue("@PasswordHash", entity.PasswordHash);
                    cmd.Parameters.AddWithValue("@Nombres", entity.Nombres);
                    cmd.Parameters.AddWithValue("@Apellidos", entity.Apellidos);
                    cmd.Parameters.AddWithValue("@TipoDocumento", (object?)entity.TipoDocumento ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@NumeroDocumento", (object?)entity.NumeroDocumento ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Telefono", (object?)entity.Telefono ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Direccion", (object?)entity.Direccion ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Ciudad", (object?)entity.Ciudad ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CodigoPostal", (object?)entity.CodigoPostal ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Pais", (object?)entity.Pais ?? "Perú");
                    cmd.Parameters.AddWithValue("@Activo", entity.Activo ?? true);

                    cn.Open();
                    int i = cmd.ExecuteNonQuery();
                    mensaje = i > 0 ? "Usuario agregado correctamente" : "No se pudo agregar el usuario";
                }
            }
            catch (Exception ex)
            {
                mensaje = ex.Message;
            }

            return mensaje;
        }

        public string Actualizar(Usuario entity)
        {
            string mensaje = "";
            try
            {
                using (SqlConnection cn = new SqlConnection(cadena))
                using (SqlCommand cmd = new SqlCommand("usp_usuarios_actualizar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@UsuarioId", entity.UsuarioId);
                    cmd.Parameters.AddWithValue("@RolId", entity.RolId);
                    cmd.Parameters.AddWithValue("@NombreUsuario", entity.NombreUsuario);
                    cmd.Parameters.AddWithValue("@Email", entity.Email);
                    cmd.Parameters.AddWithValue("@PasswordHash", entity.PasswordHash);
                    cmd.Parameters.AddWithValue("@Nombres", entity.Nombres);
                    cmd.Parameters.AddWithValue("@Apellidos", entity.Apellidos);
                    cmd.Parameters.AddWithValue("@TipoDocumento", (object?)entity.TipoDocumento ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@NumeroDocumento", (object?)entity.NumeroDocumento ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Telefono", (object?)entity.Telefono ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Direccion", (object?)entity.Direccion ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Ciudad", (object?)entity.Ciudad ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@CodigoPostal", (object?)entity.CodigoPostal ?? DBNull.Value);
                    cmd.Parameters.AddWithValue("@Pais", (object?)entity.Pais ?? "Perú");
                    cmd.Parameters.AddWithValue("@Activo", entity.Activo ?? true);

                    cn.Open();
                    int i = cmd.ExecuteNonQuery();
                    mensaje = i > 0 ? "Usuario actualizado correctamente" : "No se pudo actualizar el usuario";
                }
            }
            catch (Exception ex)
            {
                mensaje = ex.Message;
            }

            return mensaje;
        }

        public string Eliminar(int id)
        {
            string mensaje = "";
            try
            {
                using (SqlConnection cn = new SqlConnection(cadena))
                using (SqlCommand cmd = new SqlCommand("usp_usuarios_eliminar", cn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@UsuarioId", id);

                    cn.Open();
                    int i = cmd.ExecuteNonQuery();
                    mensaje = i > 0 ? "Usuario eliminado" : "No se pudo eliminar el usuario";
                }
            }
            catch (Exception ex)
            {
                mensaje = ex.Message;
            }

            return mensaje;
        }

        public Usuario Buscar(int id)
        {
            return Listado().FirstOrDefault(x => x.UsuarioId == id) ?? new Usuario();
        }
    }
}
