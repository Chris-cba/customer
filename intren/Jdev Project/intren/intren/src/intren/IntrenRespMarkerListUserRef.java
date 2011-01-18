package intren;

import java.sql.SQLException;
import java.sql.Connection;
import oracle.jdbc.OracleTypes;
import oracle.sql.ORAData;
import oracle.sql.ORADataFactory;
import oracle.sql.Datum;
import oracle.sql.REF;
import oracle.sql.STRUCT;

public class IntrenRespMarkerListUserRef implements ORAData, ORADataFactory
{
  public static final String _SQL_BASETYPE = "INTREN_RESP_MARKER_LIST";
  public static final int _SQL_TYPECODE = OracleTypes.REF;

  REF _ref;

private static final IntrenRespMarkerListUserRef _IntrenRespMarkerListUserRefFactory = new IntrenRespMarkerListUserRef();

  public static ORADataFactory getORADataFactory()
  { return _IntrenRespMarkerListUserRefFactory; }
  /* constructor */
  public IntrenRespMarkerListUserRef()
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
    IntrenRespMarkerListUserRef r = new IntrenRespMarkerListUserRef();
    r._ref = (REF) d;
    return r;
  }

  public static IntrenRespMarkerListUserRef cast(ORAData o) throws SQLException
  {
     if (o == null) return null;
     try { return (IntrenRespMarkerListUserRef) getORADataFactory().create(o.toDatum(null), OracleTypes.REF); }
     catch (Exception exn)
     { throw new SQLException("Unable to convert "+o.getClass().getName()+" to IntrenRespMarkerListUserRef: "+exn.toString()); }
  }

  public IntrenRespMarkerListUser getValue() throws SQLException
  {
     return (IntrenRespMarkerListUser) IntrenRespMarkerListUser.getORADataFactory().create(
       _ref.getSTRUCT(), OracleTypes.REF);
  }

  public void setValue(IntrenRespMarkerListUser c) throws SQLException
  {
    _ref.setValue((STRUCT) c.toDatum(_ref.getJavaSqlConnection()));
  }
}
