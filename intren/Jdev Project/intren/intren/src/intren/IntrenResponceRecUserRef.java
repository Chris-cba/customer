package intren;

import java.sql.SQLException;
import java.sql.Connection;
import oracle.jdbc.OracleTypes;
import oracle.sql.ORAData;
import oracle.sql.ORADataFactory;
import oracle.sql.Datum;
import oracle.sql.REF;
import oracle.sql.STRUCT;

public class IntrenResponceRecUserRef implements ORAData, ORADataFactory
{
  public static final String _SQL_BASETYPE = "INTREN_RESPONCE_REC";
  public static final int _SQL_TYPECODE = OracleTypes.REF;

  REF _ref;

private static final IntrenResponceRecUserRef _IntrenResponceRecUserRefFactory = new IntrenResponceRecUserRef();

  public static ORADataFactory getORADataFactory()
  { return _IntrenResponceRecUserRefFactory; }
  /* constructor */
  public IntrenResponceRecUserRef()
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
    IntrenResponceRecUserRef r = new IntrenResponceRecUserRef();
    r._ref = (REF) d;
    return r;
  }

  public static IntrenResponceRecUserRef cast(ORAData o) throws SQLException
  {
     if (o == null) return null;
     try { return (IntrenResponceRecUserRef) getORADataFactory().create(o.toDatum(null), OracleTypes.REF); }
     catch (Exception exn)
     { throw new SQLException("Unable to convert "+o.getClass().getName()+" to IntrenResponceRecUserRef: "+exn.toString()); }
  }

  public IntrenResponceRecUser getValue() throws SQLException
  {
     return (IntrenResponceRecUser) IntrenResponceRecUser.getORADataFactory().create(
       _ref.getSTRUCT(), OracleTypes.REF);
  }

  public void setValue(IntrenResponceRecUser c) throws SQLException
  {
    _ref.setValue((STRUCT) c.toDatum(_ref.getJavaSqlConnection()));
  }
}
