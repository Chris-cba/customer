package intren;

import java.sql.SQLException;
import java.sql.Connection;
import oracle.jdbc.OracleTypes;
import oracle.sql.ORAData;
import oracle.sql.ORADataFactory;
import oracle.sql.Datum;
import oracle.sql.REF;
import oracle.sql.STRUCT;

public class IntrenRespMarkerRecUserRef implements ORAData, ORADataFactory
{
  public static final String _SQL_BASETYPE = "INTREN_RESP_MARKER_REC";
  public static final int _SQL_TYPECODE = OracleTypes.REF;

  REF _ref;

private static final IntrenRespMarkerRecUserRef _IntrenRespMarkerRecUserRefFactory = new IntrenRespMarkerRecUserRef();

  public static ORADataFactory getORADataFactory()
  { return _IntrenRespMarkerRecUserRefFactory; }
  /* constructor */
  public IntrenRespMarkerRecUserRef()
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
    IntrenRespMarkerRecUserRef r = new IntrenRespMarkerRecUserRef();
    r._ref = (REF) d;
    return r;
  }

  public static IntrenRespMarkerRecUserRef cast(ORAData o) throws SQLException
  {
     if (o == null) return null;
     try { return (IntrenRespMarkerRecUserRef) getORADataFactory().create(o.toDatum(null), OracleTypes.REF); }
     catch (Exception exn)
     { throw new SQLException("Unable to convert "+o.getClass().getName()+" to IntrenRespMarkerRecUserRef: "+exn.toString()); }
  }

  public IntrenRespMarkerRecUser getValue() throws SQLException
  {
     return (IntrenRespMarkerRecUser) IntrenRespMarkerRecUser.getORADataFactory().create(
       _ref.getSTRUCT(), OracleTypes.REF);
  }

  public void setValue(IntrenRespMarkerRecUser c) throws SQLException
  {
    _ref.setValue((STRUCT) c.toDatum(_ref.getJavaSqlConnection()));
  }
}
