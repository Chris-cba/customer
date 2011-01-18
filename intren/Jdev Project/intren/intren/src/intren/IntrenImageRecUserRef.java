package intren;

import java.sql.SQLException;
import java.sql.Connection;
import oracle.jdbc.OracleTypes;
import oracle.sql.ORAData;
import oracle.sql.ORADataFactory;
import oracle.sql.Datum;
import oracle.sql.REF;
import oracle.sql.STRUCT;

public class IntrenImageRecUserRef implements ORAData, ORADataFactory
{
  public static final String _SQL_BASETYPE = "INTREN_IMAGE_REC";
  public static final int _SQL_TYPECODE = OracleTypes.REF;

  REF _ref;

private static final IntrenImageRecUserRef _IntrenImageRecUserRefFactory = new IntrenImageRecUserRef();

  public static ORADataFactory getORADataFactory()
  { return _IntrenImageRecUserRefFactory; }
  /* constructor */
  public IntrenImageRecUserRef()
  {
  }

  /* ORAData interface */
  public Datum toDatum(Connection c) throws SQLException
  {
    return _ref;
  }

  /* ORADataFactory interface */
  public ORAData create(Datum d, int sqlType) throws SQLException
  {
    if (d == null) return null; 
    IntrenImageRecUserRef r = new IntrenImageRecUserRef();
    r._ref = (REF) d;
    return r;
  }

  public static IntrenImageRecUserRef cast(ORAData o) throws SQLException
  {
     if (o == null) return null;
     try { return (IntrenImageRecUserRef) getORADataFactory().create(o.toDatum(null), OracleTypes.REF); }
     catch (Exception exn)
     { throw new SQLException("Unable to convert "+o.getClass().getName()+" to IntrenImageRecUserRef: "+exn.toString()); }
  }

  public IntrenImageRecUser getValue() throws SQLException
  {
     return (IntrenImageRecUser) IntrenImageRecUser.getORADataFactory().create(
       _ref.getSTRUCT(), OracleTypes.REF);
  }

  public void setValue(IntrenImageRecUser c) throws SQLException
  {
    _ref.setValue((STRUCT) c.toDatum(_ref.getJavaSqlConnection()));
  }
}
