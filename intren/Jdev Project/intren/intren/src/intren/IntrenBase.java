package intren;

import java.sql.SQLException;
import java.sql.Connection;
import java.io.*;

public class IntrenBase
{

  /* connection management */
  protected javax.sql.DataSource __dataSource = null;
  public void _setDataSource(javax.sql.DataSource dataSource) throws SQLException
  { __dataSource = dataSource; }
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

  /* constructors */
  public IntrenBase() throws SQLException
  {    try {
     javax.naming.InitialContext __initCtx = new javax.naming.InitialContext();
     __dataSource = (javax.sql.DataSource) __initCtx.lookup("java:comp/env/jdbc/intrenDS");
   } catch (Exception __jndie) { 
     throw new java.sql.SQLException("Error looking up <java:comp/env/jdbc/intrenDS>: " + __jndie.getMessage()); 
   }
 }
  public IntrenBase(javax.sql.DataSource ds) throws SQLException { __dataSource = ds; }

  public IntrenResponceRecUser _deleteMarker (
    IntrenMarkerIdTypeUser PI_MARKER_ID, Connection __onnScopeMethod)
  throws java.sql.SQLException
  {
    java.sql.Connection __sJT_cc = null;
    IntrenResponceRecUser __jPt_result=null;
    oracle.jdbc.OracleCallableStatement __sJT_st=null;
    __sJT_cc = __onnScopeMethod;
    __sJT_st = (oracle.jdbc.OracleCallableStatement) __sJT_cc.prepareCall("BEGIN :1 := \"INTREN_WS\".DELETE_MARKER(:2 ); END;");
    __sJT_st.registerOutParameter(1, 2002, "INTREN_RESPONCE_REC");
    if (PI_MARKER_ID==null) __sJT_st.setNull(2, 2002, "INTREN_MARKER_ID_TYPE"); else   __sJT_st.setORAData(2, PI_MARKER_ID);
    __sJT_st.executeUpdate();
    __jPt_result = (IntrenResponceRecUser) __sJT_st.getORAData(1, IntrenResponceRecUser.getORADataFactory());
    try { __sJT_st.close(); } catch (Exception e) {}
    return __jPt_result;
  }

  public IntrenResponceRecUser _createNewMarker (
    IntrenMarkerRecUser PI_MARKER, Connection __onnScopeMethod)
  throws java.sql.SQLException
  {
    java.sql.Connection __sJT_cc = null;
    IntrenResponceRecUser __jPt_result=null;
    oracle.jdbc.OracleCallableStatement __sJT_st=null;
    __sJT_cc = __onnScopeMethod;
    __sJT_st = (oracle.jdbc.OracleCallableStatement) __sJT_cc.prepareCall("BEGIN :1 := \"INTREN_WS\".CREATE_NEW_MARKER(:2 ); END;");
    __sJT_st.registerOutParameter(1, 2002, "INTREN_RESPONCE_REC");
    if (PI_MARKER==null) __sJT_st.setNull(2, 2002, "INTREN_MARKER_REC"); else   __sJT_st.setORAData(2, PI_MARKER);
    __sJT_st.executeUpdate();
    __jPt_result = (IntrenResponceRecUser) __sJT_st.getORAData(1, IntrenResponceRecUser.getORADataFactory());
    try { __sJT_st.close(); } catch (Exception e) {}
    return __jPt_result;
  }

  public IntrenRespMarkerListUser _getListOfMarkers (Connection __onnScopeMethod)
  throws java.sql.SQLException
  {
    java.sql.Connection __sJT_cc = null;
    IntrenRespMarkerListUser __jPt_result=null;
    oracle.jdbc.OracleCallableStatement __sJT_st=null;
    __sJT_cc = __onnScopeMethod;
    __sJT_st = (oracle.jdbc.OracleCallableStatement) __sJT_cc.prepareCall("BEGIN :1 := \"INTREN_WS\".GET_LIST_OF_MARKERS(); END;");
    __sJT_st.registerOutParameter(1, 2002, "INTREN_RESP_MARKER_LIST");
    __sJT_st.executeUpdate();
    __jPt_result = (IntrenRespMarkerListUser) __sJT_st.getORAData(1, IntrenRespMarkerListUser.getORADataFactory());
    try { __sJT_st.close(); } catch (Exception e) {}
    return __jPt_result;
  }

  public IntrenResponceRecUser _ping (Connection __onnScopeMethod)
  throws java.sql.SQLException
  {
    java.sql.Connection __sJT_cc = null;
    IntrenResponceRecUser __jPt_result=null;
    oracle.jdbc.OracleCallableStatement __sJT_st=null;
    __sJT_cc = __onnScopeMethod;
    __sJT_st = (oracle.jdbc.OracleCallableStatement) __sJT_cc.prepareCall("BEGIN :1 := \"INTREN_WS\".PING(); END;");
    __sJT_st.registerOutParameter(1, 2002, "INTREN_RESPONCE_REC");
    __sJT_st.executeUpdate();
    __jPt_result = (IntrenResponceRecUser) __sJT_st.getORAData(1, IntrenResponceRecUser.getORADataFactory());
    try { __sJT_st.close(); } catch (Exception e) {}
    return __jPt_result;
  }

  public IntrenResponceRecUser _updateMarker (
    IntrenMarkerRecUser PI_MARKER, Connection __onnScopeMethod)
  throws java.sql.SQLException
  {
    java.sql.Connection __sJT_cc = null;
    IntrenResponceRecUser __jPt_result=null;
    oracle.jdbc.OracleCallableStatement __sJT_st=null;
    __sJT_cc = __onnScopeMethod;
    __sJT_st = (oracle.jdbc.OracleCallableStatement) __sJT_cc.prepareCall("BEGIN :1 := \"INTREN_WS\".UPDATE_MARKER(:2 ); END;");
    __sJT_st.registerOutParameter(1, 2002, "INTREN_RESPONCE_REC");
    if (PI_MARKER==null) __sJT_st.setNull(2, 2002, "INTREN_MARKER_REC"); else   __sJT_st.setORAData(2, PI_MARKER);
    __sJT_st.executeUpdate();
    __jPt_result = (IntrenResponceRecUser) __sJT_st.getORAData(1, IntrenResponceRecUser.getORADataFactory());
    try { __sJT_st.close(); } catch (Exception e) {}
    return __jPt_result;
  }

  public IntrenRespMarkerRecUser _getMarker (
    IntrenMarkerIdTypeUser PI_MARKER_ID, Connection __onnScopeMethod)
  throws java.sql.SQLException
  {
    java.sql.Connection __sJT_cc = null;
    IntrenRespMarkerRecUser __jPt_result=null;
    oracle.jdbc.OracleCallableStatement __sJT_st=null;
    __sJT_cc = __onnScopeMethod;
    __sJT_st = (oracle.jdbc.OracleCallableStatement) __sJT_cc.prepareCall("BEGIN :1 := \"INTREN_WS\".GET_MARKER(:2 ); END;");
    __sJT_st.registerOutParameter(1, 2002, "INTREN_RESP_MARKER_REC");
    if (PI_MARKER_ID==null) __sJT_st.setNull(2, 2002, "INTREN_MARKER_ID_TYPE"); else   __sJT_st.setORAData(2, PI_MARKER_ID);
    __sJT_st.executeUpdate();
    __jPt_result = (IntrenRespMarkerRecUser) __sJT_st.getORAData(1, IntrenRespMarkerRecUser.getORADataFactory());
    try { __sJT_st.close(); } catch (Exception e) {}
    return __jPt_result;
  }
}
