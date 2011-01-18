package intren;

import java.sql.SQLException;
import java.sql.Connection;
import oracle.jdbc.OracleTypes;
import oracle.sql.ORAData;
import oracle.sql.ORADataFactory;
import oracle.sql.Datum;
import oracle.sql.REF;
import oracle.sql.STRUCT;

public class IntrenMarkerIdTypeUserRef implements ORAData, ORADataFactory
{
  public static final String _SQL_BASETYPE = "INTREN_MARKER_ID_TYPE";
  public static final int _SQL_TYPECODE = OracleTypes.REF;

  REF _ref;

private static final IntrenMarkerIdTypeUserRef _IntrenMarkerIdTypeUserRefFactory = new IntrenMarkerIdTypeUserRef();

  public static ORADataFactory getORADataFactory()
  { return _IntrenMarkerIdTypeUserRefFactory; }
  /* constructor */
  public IntrenMarkerIdTypeUserRef()
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
    IntrenMarkerIdTypeUserRef r = new IntrenMarkerIdTypeUserRef();
    r._ref = (REF) d;
    return r;
  }

  public static IntrenMarkerIdTypeUserRef cast(ORAData o) throws SQLException
  {
     if (o == null) return null;
     try { return (IntrenMarkerIdTypeUserRef) getORADataFactory().create(o.toDatum(null), OracleTypes.REF); }
     catch (Exception exn)
     { throw new SQLException("Unable to convert "+o.getClass().getName()+" to IntrenMarkerIdTypeUserRef: "+exn.toString()); }
  }

  public IntrenMarkerIdTypeUser getValue() throws SQLException
  {
     return (IntrenMarkerIdTypeUser) IntrenMarkerIdTypeUser.getORADataFactory().create(
       _ref.getSTRUCT(), OracleTypes.REF);
  }

  public void setValue(IntrenMarkerIdTypeUser c) throws SQLException
  {
    _ref.setValue((STRUCT) c.toDatum(_ref.getJavaSqlConnection()));
  }
}
