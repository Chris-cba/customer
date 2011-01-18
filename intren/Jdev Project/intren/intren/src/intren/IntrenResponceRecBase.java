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

public class IntrenResponceRecBase implements ORAData, ORADataFactory
{
  public static final String _SQL_NAME = "INTREN_RESPONCE_REC";
  public static final int _SQL_TYPECODE = OracleTypes.STRUCT;

  /* connection management */
  protected Connection __onn = null;
  protected javax.sql.DataSource __dataSource = null;
  public void _setDataSource(javax.sql.DataSource dataSource) throws SQLException
  { release(); __dataSource = dataSource; }
  public void _setDataSourceLocation(String dataSourceLocation) throws SQLException {
    javax.sql.DataSource dataSource;
    try {
      Class cls = Class.forName("javax.naming.InitialContext");
      Object ctx = cls.newInstance();
      java.lang.reflect.Method meth = cls.getMethod("lookup", new Class[]{String.class});
      dataSource = (javax.sql.DataSource) meth.invoke(ctx, new Object[]{"java:comp/env/" + dataSourceLocation});
      _setDataSource(dataSource);
    } catch (Exception e) {
      throw new java.sql.SQLException("Error initializing DataSource at " + dataSourceLocation + ": " + e.getMessage());
    }
  }
  public Connection _getConnection() throws SQLException
  { 
    if (__onn!=null) return __onn;
     else if (__dataSource!=null) __onn= __dataSource.getConnection(); 
     return __onn; 
   } 
  public void release() throws SQLException { 
    __onn = null;
    __dataSource = null;
  }

  public void _closeConnection(){
    if (__dataSource!=null) {
      try { if (__onn!=null) { __onn.close(); } } catch (java.sql.SQLException e) {}
      __onn=null;
    }
  }
  public void _setConnection(java.sql.Connection conn) throws SQLException
  { __onn = conn; }
  protected MutableStruct _struct;

  protected static int[] _sqlType =  { 12,12,12,12 };
  protected static ORADataFactory[] _factory = new ORADataFactory[4];
  protected static final IntrenResponceRecBase _IntrenResponceRecBaseFactory = new IntrenResponceRecBase();

  public static ORADataFactory getORADataFactory()
  { return _IntrenResponceRecBaseFactory; }
  /* constructors */
  protected void _init_struct(boolean init)
  { if (init) _struct = new MutableStruct(new Object[4], _sqlType, _factory); }
  public IntrenResponceRecBase()
  { _init_struct(true);  }
  public IntrenResponceRecBase(Connection c) /*throws SQLException*/
  { _init_struct(true); __onn = c; }
  public IntrenResponceRecBase(String datetime, String message, String codeversion, String responceCode) throws SQLException
  {
    _init_struct(true);
    _setDatetime(datetime);
    _setMessage(message);
    _setCodeversion(codeversion);
    _setResponceCode(responceCode);
  }

  /* ORAData interface */
  public Datum toDatum(Connection c) throws SQLException
  {
    if (__onn!=c) release();
    __onn = c;
    _userSetterHelper();
    return _struct.toDatum(c, _SQL_NAME);
  }


  /* ORADataFactory interface */
  public ORAData create(Datum d, int sqlType) throws SQLException
  { return create(null, d, sqlType); }
  public void _setFrom(IntrenResponceRecBase o) throws SQLException
  { setContextFrom(o); setValueFrom(o); }
  protected void setContextFrom(IntrenResponceRecBase o) throws SQLException
  { release(); __onn = o.__onn; }
  protected void setValueFrom(IntrenResponceRecBase o) { _struct = o._struct; }
  protected ORAData create(IntrenResponceRecBase o, Datum d, int sqlType) throws SQLException
  {
    if (d == null) { if (o!=null) { o.release(); }; return null; }
    if (o == null) o = new IntrenResponceRecUser();
    o._struct = new MutableStruct((STRUCT) d, _sqlType, _factory);
    o.__onn = ((STRUCT) d).getJavaSqlConnection();
    return o;
  }
  /* accessor methods */
  public String _getDatetime() throws SQLException
  { return (String) _struct.getAttribute(0); }

  public void _setDatetime(String datetime) throws SQLException
  { _struct.setAttribute(0, datetime); }


  public String _getMessage() throws SQLException
  { return (String) _struct.getAttribute(1); }

  public void _setMessage(String message) throws SQLException
  { _struct.setAttribute(1, message); }


  public String _getCodeversion() throws SQLException
  { return (String) _struct.getAttribute(2); }

  public void _setCodeversion(String codeversion) throws SQLException
  { _struct.setAttribute(2, codeversion); }


  public String _getResponceCode() throws SQLException
  { return (String) _struct.getAttribute(3); }

  public void _setResponceCode(String responceCode) throws SQLException
  { _struct.setAttribute(3, responceCode); }

;
  // Some setter action is delayed until toDatum() 
  // where the connection is available 
  void _userSetterHelper() throws java.sql.SQLException {} 
}
