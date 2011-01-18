package intren;

import java.sql.SQLException;
import java.sql.Connection;
import java.io.*;

public interface Intren extends java.rmi.Remote{


  public IntrenResponceRecUser deleteMarker(IntrenMarkerIdTypeUser piMarkerId) throws java.rmi.RemoteException;
  public IntrenResponceRecUser createNewMarker(IntrenMarkerRecUser piMarker) throws java.rmi.RemoteException;
  public IntrenRespMarkerListUser getListOfMarkers() throws java.rmi.RemoteException;
  public IntrenResponceRecUser ping() throws java.rmi.RemoteException;
  public IntrenResponceRecUser updateMarker(IntrenMarkerRecUser piMarker) throws java.rmi.RemoteException;
  public IntrenRespMarkerRecUser getMarker(IntrenMarkerIdTypeUser piMarkerId) throws java.rmi.RemoteException;
}
