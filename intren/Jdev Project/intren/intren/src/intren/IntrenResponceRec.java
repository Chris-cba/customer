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

public interface IntrenResponceRec {

  public void setDatetime(String datetime) throws SQLException;
  public String getDatetime() throws SQLException;

  public void setMessage(String message) throws SQLException;
  public String getMessage() throws SQLException;

  public void setCodeversion(String codeversion) throws SQLException;
  public String getCodeversion() throws SQLException;

  public void setResponceCode(String responceCode) throws SQLException;
  public String getResponceCode() throws SQLException;


}
