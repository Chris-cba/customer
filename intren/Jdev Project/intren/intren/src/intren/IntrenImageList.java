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

public class IntrenImageList implements ORAData, ORADataFactory
{
  public static final String _SQL_NAME = "INTREN_IMAGE_LIST";
  public static final int _SQL_TYPECODE = OracleTypes.ARRAY;

  MutableArray _array;

private static final IntrenImageList _IntrenImageListFactory = new IntrenImageList();

  public static ORADataFactory getORADataFactory()
  { return _IntrenImageListFactory; }
  /* constructors */
  public IntrenImageList()
  {
    this(new IntrenImageRecUser[0]);
  }

  public IntrenImageList(IntrenImageRecUser[] a)
  {
    _array = new MutableArray(2002, a, IntrenImageRecUser.getORADataFactory());
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
    IntrenImageList a = new IntrenImageList();
    a._array = new MutableArray(2002, (ARRAY) d, IntrenImageRecUser.getORADataFactory());
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
  public IntrenImageRecUser[] getArray() throws SQLException
  {
    if (_lazyArray!=null) { return _lazyArray; }
    return (IntrenImageRecUser[]) _array.getObjectArray(
      new IntrenImageRecUser[_array.length()]);
  }

  public IntrenImageRecUser[] getArray(long index, int count) throws SQLException
  {
    if (_lazyArray!=null) { _setArray(_lazyArray); _lazyArray = null; }
    return (IntrenImageRecUser[]) _array.getObjectArray(index,
      new IntrenImageRecUser[_array.sliceLength(index, count)]);
  }

  private IntrenImageRecUser[] _lazyArray;
  public void setArray(IntrenImageRecUser[] a) { _lazyArray = a; };
  public void _setArray(IntrenImageRecUser[] a) throws SQLException
  {
    _array.setObjectArray(a);
  }

  public void setArray(IntrenImageRecUser[] a, long index) throws SQLException
  {
    if (_lazyArray!=null) { _setArray(_lazyArray); _lazyArray = null; }
    _array.setObjectArray(a, index);
  }

  public IntrenImageRecUser _getElement(long index) throws SQLException
  {
    if (_lazyArray!=null) { _setArray(_lazyArray); _lazyArray = null; }
    return (IntrenImageRecUser) _array.getObjectElement(index);
  }

  public void _setElement(IntrenImageRecUser a, long index) throws SQLException
  {
    if (_lazyArray!=null) { _setArray(_lazyArray); _lazyArray = null; }
    _array.setObjectElement(a, index);
  }

}
