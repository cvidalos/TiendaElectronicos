namespace TiendaElectronica.Repositorio
{
    public interface ISelect<T> where T : class
    {
        IEnumerable<T> Listado();
    }

    public interface ICrud<T> where T : class
    {
        string Agregar(T entity);
        string Actualizar(T entity);
        string Eliminar(int id);
        T Buscar(int id);
    }
}
