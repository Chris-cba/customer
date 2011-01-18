package intren;

import java.sql.SQLException;
import java.sql.Connection;
import oracle.jdbc.OracleTypes;
import oracle.sql.ORAData;
import oracle.sql.ORADataFactory;
import oracle.sql.Datum;
import oracle.sql.STRUCT;
import oracle.jpub.runtime.MutableStruct;
import java.io.*;

public class IntrenMarkerIdTypeUser extends IntrenMarkerIdTypeBase implements ORAData, ORADataFactory, IntrenMarkerIdType
{
   private static final IntrenMarkerIdTypeUser _IntrenMarkerIdTypeUserFactory = new IntrenMarkerIdTypeUser();
   public static ORADataFactory getORADataFactory()
   { return _IntrenMarkerIdTypeUserFactory; }

   public IntrenMarkerIdTypeUser() { super(); }
   public IntrenMarkerIdTypeUser(Connection conn) throws SQLException { super(conn); } 
  public IntrenMarkerIdTypeUser(String markerId) throws SQLException
  {
    _setMarkerId(markerId);
  }
   /* ORAData interface */
   public ORAData create(Datum d, int sqlType) throws SQLException
   { return create(new IntrenMarkerIdTypeUser(), d, sqlType); }

  /* superclass accessors */

  public void setMarkerId(String markerId) throws SQLException { super._setMarkerId(markerId); }
  public String getMarkerId() throws SQLException { return super._getMarkerId(); }



}
