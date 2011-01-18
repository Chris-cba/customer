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

public class IntrenRespMarkerListBase implements ORAData, ORADataFactory
{
  public static final String _SQL_NAME = "INTREN_RESP_MARKER_LIST";
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

  protected static int[] _sqlType =  { 2003,2002 };
  protected static ORADataFactory[] _factory = new ORADataFactory[2];
  static
  {
    _factory[0] = IntrenMarkerRecList.getORADataFactory();
    _factory[1] = IntrenResponceRecUser.getORADataFactory();
  }
  protected static final IntrenRespMarkerListBase _IntrenRespMarkerListBaseFactory = new IntrenRespMarkerListBase();

  public static ORADataFactory getORADataFactory()
  { return _IntrenRespMarkerListBaseFactory; }
  /* constructors */
  protected void _init_struct(boolean init)
  { if (init) _struct = new MutableStruct(new Object[2], _sqlType, _factory); }
  public IntrenRespMarkerListBase()
  { _init_struct(true);  }
  public IntrenRespMarkerListBase(Connection c) /*throws SQLException*/
  { _init_struct(true); __onn = c; }
  public IntrenRespMarkerListBase(IntrenMarkerRecList markers, IntrenResponceRecUser responce) throws SQLException
  {
    _init_struct(true);
    _setMarkers(markers);
    _setResponce(responce);
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
  public void _setFrom(IntrenRespMarkerListBase o) throws SQLException
  { setContextFrom(o); setValueFrom(o); }
  protected void setContextFrom(IntrenRespMarkerListBase o) throws SQLException
  { release(); __onn = o.__onn; }
  protected void setValueFrom(IntrenRespMarkerListBase o) { _struct = o._struct; }
  protected ORAData create(IntrenRespMarkerListBase o, Datum d, int sqlType) throws SQLException
  {
    if (d == null) { if (o!=null) { o.release(); }; return null; }
    if (o == null) o = new IntrenRespMarkerListUser();
    o._struct = new MutableStruct((STRUCT) d, _sqlType, _factory);
    o.__onn = ((STRUCT) d).getJavaSqlConnection();
    return o;
  }
  /* accessor methods */
  public IntrenMarkerRecList _getMarkers() throws SQLException
  { return (IntrenMarkerRecList) _struct.getAttribute(0); }

  public void _setMarkers(IntrenMarkerRecList markers) throws SQLException
  { _struct.setAttribute(0, markers); }


  public IntrenResponceRecUser _getResponce() throws SQLException
  { return (IntrenResponceRecUser) _struct.getAttribute(1); }

  public void _setResponce(IntrenResponceRecUser responce) throws SQLException
  { _struct.setAttribute(1, responce); }

;
  // Some setter action is delayed until toDatum() 
  // where the connection is available 
  void _userSetterHelper() throws java.sql.SQLException {} 
}
