package intren;

import java.sql.SQLException;
import java.sql.Connection;
import oracle.jdbc.OracleTypes;
import oracle.sql.ORAData;
import oracle.sql.ORADataFactory;
import oracle.sql.Datum;
import oracle.sql.ARRAY;
import oracle.sql.ArrayDescriptor;
import oracle.jpub.runtime.MutableArray;

public class IntrenMarkerRecList implements ORAData, ORADataFactory
{
  public static final String _SQL_NAME = "INTREN_MARKER_REC_LIST";
  public static final int _SQL_TYPECODE = OracleTypes.ARRAY;

  MutableArray _array;

private static final IntrenMarkerRecList _IntrenMarkerRecListFactory = new IntrenMarkerRecList();

  public static ORADataFactory getORADataFactory()
  { return _IntrenMarkerRecListFactory; }
  /* constructors */
  public IntrenMarkerRecList()
  {
    this(new IntrenMarkerRecUser[0]);
  }

  public IntrenMarkerRecList(IntrenMarkerRecUser[] a)
  {
    _array = new MutableArray(2002, a, IntrenMarkerRecUser.getORADataFactory());
    _lazyArray = a;
  }

  /* ORAData interface */
  public Datum toDatum(Connection c) throws SQLException
  {
    if (_lazyArray!=null) _setArray(_lazyArray);
    if (_lazyArray!=null) _lazyArray = null;
    if (__schemaName!=null) return _array.toDatum(c,__schemaName + "." + _SQL_NAME);
    return _array.toDatum(c, _SQL_NAME);
  }
  private String __schemaName = null;
  public void __setSchemaName(String schemaName) { __schemaName = schemaName; }

  /* ORADataFactory interface */
  public ORAData create(Datum d, int sqlType) throws SQLException
  {
    if (d == null) return null; 
    IntrenMarkerRecList a = new IntrenMarkerRecList();
    a._array = new MutableArray(2002, (ARRAY) d, IntrenMarkerRecUser.getORADataFactory());
    a._lazyArray = null;
    return a;
  }

  public int length() throws SQLException
  {
    return _array.length();
  }

  public int _getBaseType() throws SQLException
  {
    return _array.getBaseType();
  }

  public String _getBaseTypeName() throws SQLException
  {
    return _array.getBaseTypeName();
  }

  public ArrayDescriptor _getDescriptor() throws SQLException
  {
    return _array.getDescriptor();
  }

  /* array accessor methods */
  public IntrenMarkerRecUser[] getArray() throws SQLException
  {
    if (_lazyArray!=null) { return _lazyArray; }
    return (IntrenMarkerRecUser[]) _array.getObjectArray(
      new IntrenMarkerRecUser[_array.length()]);
  }

  public IntrenMarkerRecUser[] getArray(long index, int count) throws SQLException
  {
    if (_lazyArray!=null) { _setArray(_lazyArray); _lazyArray = null; }
    return (IntrenMarkerRecUser[]) _array.getObjectArray(index,
      new IntrenMarkerRecUser[_array.sliceLength(index, count)]);
  }

  private IntrenMarkerRecUser[] _lazyArray;
  public void setArray(IntrenMarkerRecUser[] a) { _lazyArray = a; };
  public void _setArray(IntrenMarkerRecUser[] a) throws SQLException
  {
    _array.setObjectArray(a);
  }

  public void setArray(IntrenMarkerRecUser[] a, long index) throws SQLException
  {
    if (_lazyArray!=null) { _setArray(_lazyArray); _lazyArray = null; }
    _array.setObjectArray(a, index);
  }

  public IntrenMarkerRecUser _getElement(long index) throws SQLException
  {
    if (_lazyArray!=null) { _setArray(_lazyArray); _lazyArray = null; }
    return (IntrenMarkerRecUser) _array.getObjectElement(index);
  }

  public void _setElement(IntrenMarkerRecUser a, long index) throws SQLException
  {
    if (_lazyArray!=null) { _setArray(_lazyArray); _lazyArray = null; }
    _array.setObjectElement(a, index);
  }

}
