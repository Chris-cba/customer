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

public interface IntrenRespMarkerList {

  public void setMarkers(IntrenMarkerRecList markers) throws SQLException;
  public IntrenMarkerRecList getMarkers() throws SQLException;

  public void setResponce(IntrenResponceRecUser responce) throws SQLException;
  public IntrenResponceRecUser getResponce() throws SQLException;


}
