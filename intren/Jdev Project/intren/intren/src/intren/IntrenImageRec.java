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

public interface IntrenImageRec {

  public void setFilename(String filename) throws SQLException;
  public String getFilename() throws SQLException;

  public void setFilecontents(byte[] filecontents) throws SQLException;
  public byte[] getFilecontents() throws SQLException;

  public void setFilesize(String filesize) throws SQLException;
  public String getFilesize() throws SQLException;


}
