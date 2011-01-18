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

public class IntrenRespMarkerListUser extends IntrenRespMarkerListBase implements ORAData, ORADataFactory, IntrenRespMarkerList
{
   private static final IntrenRespMarkerListUser _IntrenRespMarkerListUserFactory = new IntrenRespMarkerListUser();
   public static ORADataFactory getORADataFactory()
   { return _IntrenRespMarkerListUserFactory; }

   public IntrenRespMarkerListUser() { super(); }
   public IntrenRespMarkerListUser(Connection conn) throws SQLException { super(conn); } 
  public IntrenRespMarkerListUser(IntrenMarkerRecList markers, IntrenResponceRecUser responce) throws SQLException
  {
    _setMarkers(markers);
    _setResponce(responce);
  }
   /* ORAData interface */
   public ORAData create(Datum d, int sqlType) throws SQLException
   { return create(new IntrenRespMarkerListUser(), d, sqlType); }

  /* superclass accessors */

  public void setMarkers(IntrenMarkerRecList markers) throws SQLException { super._setMarkers(markers); }
  public IntrenMarkerRecList getMarkers() throws SQLException { return super._getMarkers(); }


  public void setResponce(IntrenResponceRecUser responce) throws SQLException { super._setResponce(responce); }
  public IntrenResponceRecUser getResponce() throws SQLException { return super._getResponce(); }



}
