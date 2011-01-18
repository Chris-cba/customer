package intren;

import java.sql.SQLException;
import java.sql.Connection;
import java.io.*;

public class IntrenUser extends IntrenBase implements Intren, java.rmi.Remote
{

  /* constructors */
  public IntrenUser() throws SQLException  { super(); }
  public IntrenUser(javax.sql.DataSource ds) throws SQLException { super(ds); }
  /* superclass methods */
  public IntrenResponceRecUser deleteMarker(IntrenMarkerIdTypeUser piMarkerId) throws java.rmi.RemoteException
  { 

    IntrenResponceRecUser __jRt_0 = null;
    try {
    java.sql.Connection __onnScopeMethod = __dataSource.getConnection();
    IntrenMarkerIdTypeUser __jRt_10 = piMarkerId;
    __jRt_0 = super._deleteMarker(__jRt_10, __onnScopeMethod);
    __onnScopeMethod.close();

    }  
    catch (java.sql.SQLException except) {
        except.printStackTrace();
        throw new java.rmi.RemoteException(except.getClass().getName() + ": " + except.getMessage()); 
    }
    return __jRt_0;
  }
  public IntrenResponceRecUser createNewMarker(IntrenMarkerRecUser piMarker) throws java.rmi.RemoteException
  { 

    IntrenResponceRecUser __jRt_0 = null;
    try {
    java.sql.Connection __onnScopeMethod = __dataSource.getConnection();
    IntrenMarkerRecUser __jRt_12 = piMarker;
    __jRt_0 = super._createNewMarker(__jRt_12, __onnScopeMethod);
    __onnScopeMethod.close();

    }  
    catch (java.sql.SQLException except) {
        except.printStackTrace();
        throw new java.rmi.RemoteException(except.getClass().getName() + ": " + except.getMessage()); 
    }
    return __jRt_0;
  }
  public IntrenRespMarkerListUser getListOfMarkers() throws java.rmi.RemoteException
  { 

    IntrenRespMarkerListUser __jRt_0 = null;
    try {
    java.sql.Connection __onnScopeMethod = __dataSource.getConnection();
    __jRt_0 = super._getListOfMarkers(__onnScopeMethod);
    __onnScopeMethod.close();

    }  
    catch (java.sql.SQLException except) {
        except.printStackTrace();
        throw new java.rmi.RemoteException(except.getClass().getName() + ": " + except.getMessage()); 
    }
    return __jRt_0;
  }
  public IntrenResponceRecUser ping() throws java.rmi.RemoteException
  { 

    IntrenResponceRecUser __jRt_0 = null;
    try {
    java.sql.Connection __onnScopeMethod = __dataSource.getConnection();
    __jRt_0 = super._ping(__onnScopeMethod);
    __onnScopeMethod.close();

    }  
    catch (java.sql.SQLException except) {
        except.printStackTrace();
        throw new java.rmi.RemoteException(except.getClass().getName() + ": " + except.getMessage()); 
    }
    return __jRt_0;
  }
  public IntrenResponceRecUser updateMarker(IntrenMarkerRecUser piMarker) throws java.rmi.RemoteException
  { 

    IntrenResponceRecUser __jRt_0 = null;
    try {
    java.sql.Connection __onnScopeMethod = __dataSource.getConnection();
    IntrenMarkerRecUser __jRt_14 = piMarker;
    __jRt_0 = super._updateMarker(__jRt_14, __onnScopeMethod);
    __onnScopeMethod.close();

    }  
    catch (java.sql.SQLException except) {
        except.printStackTrace();
        throw new java.rmi.RemoteException(except.getClass().getName() + ": " + except.getMessage()); 
    }
    return __jRt_0;
  }
  public IntrenRespMarkerRecUser getMarker(IntrenMarkerIdTypeUser piMarkerId) throws java.rmi.RemoteException
  { 

    IntrenRespMarkerRecUser __jRt_0 = null;
    try {
    java.sql.Connection __onnScopeMethod = __dataSource.getConnection();
    IntrenMarkerIdTypeUser __jRt_16 = piMarkerId;
    __jRt_0 = super._getMarker(__jRt_16, __onnScopeMethod);
    __onnScopeMethod.close();

    }  
    catch (java.sql.SQLException except) {
        except.printStackTrace();
        throw new java.rmi.RemoteException(except.getClass().getName() + ": " + except.getMessage()); 
    }
    return __jRt_0;
  }
}
