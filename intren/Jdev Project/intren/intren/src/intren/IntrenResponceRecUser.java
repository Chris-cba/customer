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

public class IntrenResponceRecUser extends IntrenResponceRecBase implements ORAData, ORADataFactory, IntrenResponceRec
{
   private static final IntrenResponceRecUser _IntrenResponceRecUserFactory = new IntrenResponceRecUser();
   public static ORADataFactory getORADataFactory()
   { return _IntrenResponceRecUserFactory; }

   public IntrenResponceRecUser() { super(); }
   public IntrenResponceRecUser(Connection conn) throws SQLException { super(conn); } 
  public IntrenResponceRecUser(String datetime, String message, String codeversion, String responceCode) throws SQLException
  {
    _setDatetime(datetime);
    _setMessage(message);
    _setCodeversion(codeversion);
    _setResponceCode(responceCode);
  }
   /* ORAData interface */
   public ORAData create(Datum d, int sqlType) throws SQLException
   { return create(new IntrenResponceRecUser(), d, sqlType); }

  /* superclass accessors */

  public void setDatetime(String datetime) throws SQLException { super._setDatetime(datetime); }
  public String getDatetime() throws SQLException { return super._getDatetime(); }


  public void setMessage(String message) throws SQLException { super._setMessage(message); }
  public String getMessage() throws SQLException { return super._getMessage(); }


  public void setCodeversion(String codeversion) throws SQLException { super._setCodeversion(codeversion); }
  public String getCodeversion() throws SQLException { return super._getCodeversion(); }


  public void setResponceCode(String responceCode) throws SQLException { super._setResponceCode(responceCode); }
  public String getResponceCode() throws SQLException { return super._getResponceCode(); }



}
