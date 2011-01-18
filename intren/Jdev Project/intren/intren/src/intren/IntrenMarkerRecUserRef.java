package intren;

import java.sql.SQLException;
import java.sql.Connection;
import oracle.jdbc.OracleTypes;
import oracle.sql.ORAData;
import oracle.sql.ORADataFactory;
import oracle.sql.Datum;
import oracle.sql.REF;
import oracle.sql.STRUCT;

public class IntrenMarkerRecUserRef implements ORAData, ORADataFactory
{
  public static final String _SQL_BASETYPE = "INTREN_MARKER_REC";
  public static final int _SQL_TYPECODE = OracleTypes.REF;

  REF _ref;

private static final IntrenMarkerRecUserRef _IntrenMarkerRecUserRefFactory = new IntrenMarkerRecUserRef();

  public static ORADataFactory getORADataFactory()
  { return _IntrenMarkerRecUserRefFactory; }
  /* constructor */
  public IntrenMarkerRecUserRef()
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
    IntrenMarkerRecUserRef r = new IntrenMarkerRecUserRef();
    r._ref = (REF) d;
    return r;
  }

  public static IntrenMarkerRecUserRef cast(ORAData o) throws SQLException
  {
     if (o == null) return null;
     try { return (IntrenMarkerRecUserRef) getORADataFactory().create(o.toDatum(null), OracleTypes.REF); }
     catch (Exception exn)
     { throw new SQLException("Unable to convert "+o.getClass().getName()+" to IntrenMarkerRecUserRef: "+exn.toString()); }
  }

  public IntrenMarkerRecUser getValue() throws SQLException
  {
     return (IntrenMarkerRecUser) IntrenMarkerRecUser.getORADataFactory().create(
       _ref.getSTRUCT(), OracleTypes.REF);
  }

  public void setValue(IntrenMarkerRecUser c) throws SQLException
  {
    _ref.setValue((STRUCT) c.toDatum(_ref.getJavaSqlConnection()));
  }
}
