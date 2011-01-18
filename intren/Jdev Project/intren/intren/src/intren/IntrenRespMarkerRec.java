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

public interface IntrenRespMarkerRec {

  public void setMarker(IntrenMarkerRecUser marker) throws SQLException;
  public IntrenMarkerRecUser getMarker() throws SQLException;

  public void setResponce(IntrenResponceRecUser responce) throws SQLException;
  public IntrenResponceRecUser getResponce() throws SQLException;


}
