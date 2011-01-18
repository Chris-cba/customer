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

public class IntrenRespMarkerRecUser extends IntrenRespMarkerRecBase implements ORAData, ORADataFactory, IntrenRespMarkerRec
{
   private static final IntrenRespMarkerRecUser _IntrenRespMarkerRecUserFactory = new IntrenRespMarkerRecUser();
   public static ORADataFactory getORADataFactory()
   { return _IntrenRespMarkerRecUserFactory; }

   public IntrenRespMarkerRecUser() { super(); }
   public IntrenRespMarkerRecUser(Connection conn) throws SQLException { super(conn); } 
  public IntrenRespMarkerRecUser(IntrenMarkerRecUser marker, IntrenResponceRecUser responce) throws SQLException
  {
    _setMarker(marker);
    _setResponce(responce);
  }
   /* ORAData interface */
   public ORAData create(Datum d, int sqlType) throws SQLException
   { return create(new IntrenRespMarkerRecUser(), d, sqlType); }

  /* superclass accessors */

  public void setMarker(IntrenMarkerRecUser marker) throws SQLException { super._setMarker(marker); }
  public IntrenMarkerRecUser getMarker() throws SQLException { return super._getMarker(); }


  public void setResponce(IntrenResponceRecUser responce) throws SQLException { super._setResponce(responce); }
  public IntrenResponceRecUser getResponce() throws SQLException { return super._getResponce(); }



}
