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

public class IntrenImageRecUser extends IntrenImageRecBase implements ORAData, ORADataFactory, IntrenImageRec
{
   private static final IntrenImageRecUser _IntrenImageRecUserFactory = new IntrenImageRecUser();
   public static ORADataFactory getORADataFactory()
   { return _IntrenImageRecUserFactory; }

   public IntrenImageRecUser() { super(); }
   public IntrenImageRecUser(Connection conn) throws SQLException { super(conn); } 
  public IntrenImageRecUser(String filename, byte[] filecontents, String filesize) throws SQLException
  {
    _setFilename(filename);
    oracle.sql.BLOB __jPt_1;
    if (filecontents==null) {
      __jPt_1 = null;
    } else {
      __jPt_1 = oracle.sql.BLOB.createTemporary(_getConnection(), false, oracle.sql.BLOB.DURATION_SESSION); 
      __jPt_1.putBytes(1l, filecontents);
    }
    _setFilecontents(__jPt_1);
    _setFilesize(filesize);
  }
   /* ORAData interface */
   public ORAData create(Datum d, int sqlType) throws SQLException
   { return create(new IntrenImageRecUser(), d, sqlType); }

  /* superclass accessors */

  public void setFilename(String filename) throws SQLException { super._setFilename(filename); }
  public String getFilename() throws SQLException { return super._getFilename(); }


  public void setFilecontents(byte[] filecontents) throws SQLException  { 
   _filecontentsHelper = filecontents;
   _filecontentsHelperSet = true;
  }
  byte[] _filecontentsHelper;
  boolean _filecontentsHelperSet = false;
  public byte[] getFilecontents() throws SQLException  { 
   if (_filecontentsHelperSet) return _filecontentsHelper;
    oracle.sql.BLOB __jRt_0;
    __jRt_0 = super._getFilecontents(); 
    byte[] __jRt_1;
    if (__jRt_0==null) {
      __jRt_1=null;
    } else {
      long __bytesLen = __jRt_0.length();
      if (__bytesLen>Integer.MAX_VALUE) {
        throw new java.sql.SQLException("BLOB too large: " + __bytesLen);
      } else {
        __jRt_1 = __jRt_0.getBytes(1l, (int)__bytesLen);
      }
    }
    return __jRt_1; 
  }


  public void setFilesize(String filesize) throws SQLException { super._setFilesize(filesize); }
  public String getFilesize() throws SQLException { return super._getFilesize(); }



  void _userSetterHelper() throws java.sql.SQLException 
  {

   if (_filecontentsHelperSet)
   { oracle.sql.BLOB __jPt_0;
      if (_filecontentsHelper==null) {
      __jPt_0 = null;
    } else {
      __jPt_0 = oracle.sql.BLOB.createTemporary(_getConnection(), false, oracle.sql.BLOB.DURATION_SESSION); 
      __jPt_0.putBytes(1l, _filecontentsHelper);
    }
     super._setFilecontents(__jPt_0); 
     _filecontentsHelperSet = false;
   };


  }
}
