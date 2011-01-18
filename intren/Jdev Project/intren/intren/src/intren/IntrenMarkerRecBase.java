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

public class IntrenMarkerRecBase implements ORAData, ORADataFactory
{
  public static final String _SQL_NAME = "INTREN_MARKER_REC";
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

  protected static int[] _sqlType =  { 12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,2003 };
  protected static ORADataFactory[] _factory = new ORADataFactory[27];
  static
  {
    _factory[26] = IntrenImageList.getORADataFactory();
  }
  protected static final IntrenMarkerRecBase _IntrenMarkerRecBaseFactory = new IntrenMarkerRecBase();

  public static ORADataFactory getORADataFactory()
  { return _IntrenMarkerRecBaseFactory; }
  /* constructors */
  protected void _init_struct(boolean init)
  { if (init) _struct = new MutableStruct(new Object[27], _sqlType, _factory); }
  public IntrenMarkerRecBase()
  { _init_struct(true);  }
  public IntrenMarkerRecBase(Connection c) /*throws SQLException*/
  { _init_struct(true); __onn = c; }
  public IntrenMarkerRecBase(String markerId, String easting, String northing, String dateInstalled, String dateDecomissioned, String contractorOrganisation, String streetName, String natureOfAsset, String material, String domainOwner, String jobReference, String jobType, String town, String depth, String kerbOffset, String shapeOfAsset, String dimOfAsset, String fittingType, String constructionType, String uboInTrench, String uboAssetType, String photoType, String previuosMarker, String geographicLocation, String surveyJobNo, String surveyMethod, IntrenImageList images) throws SQLException
  {
    _init_struct(true);
    _setMarkerId(markerId);
    _setEasting(easting);
    _setNorthing(northing);
    _setDateInstalled(dateInstalled);
    _setDateDecomissioned(dateDecomissioned);
    _setContractorOrganisation(contractorOrganisation);
    _setStreetName(streetName);
    _setNatureOfAsset(natureOfAsset);
    _setMaterial(material);
    _setDomainOwner(domainOwner);
    _setJobReference(jobReference);
    _setJobType(jobType);
    _setTown(town);
    _setDepth(depth);
    _setKerbOffset(kerbOffset);
    _setShapeOfAsset(shapeOfAsset);
    _setDimOfAsset(dimOfAsset);
    _setFittingType(fittingType);
    _setConstructionType(constructionType);
    _setUboInTrench(uboInTrench);
    _setUboAssetType(uboAssetType);
    _setPhotoType(photoType);
    _setPreviuosMarker(previuosMarker);
    _setGeographicLocation(geographicLocation);
    _setSurveyJobNo(surveyJobNo);
    _setSurveyMethod(surveyMethod);
    _setImages(images);
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
  public void _setFrom(IntrenMarkerRecBase o) throws SQLException
  { setContextFrom(o); setValueFrom(o); }
  protected void setContextFrom(IntrenMarkerRecBase o) throws SQLException
  { release(); __onn = o.__onn; }
  protected void setValueFrom(IntrenMarkerRecBase o) { _struct = o._struct; }
  protected ORAData create(IntrenMarkerRecBase o, Datum d, int sqlType) throws SQLException
  {
    if (d == null) { if (o!=null) { o.release(); }; return null; }
    if (o == null) o = new IntrenMarkerRecUser();
    o._struct = new MutableStruct((STRUCT) d, _sqlType, _factory);
    o.__onn = ((STRUCT) d).getJavaSqlConnection();
    return o;
  }
  /* accessor methods */
  public String _getMarkerId() throws SQLException
  { return (String) _struct.getAttribute(0); }

  public void _setMarkerId(String markerId) throws SQLException
  { _struct.setAttribute(0, markerId); }


  public String _getEasting() throws SQLException
  { return (String) _struct.getAttribute(1); }

  public void _setEasting(String easting) throws SQLException
  { _struct.setAttribute(1, easting); }


  public String _getNorthing() throws SQLException
  { return (String) _struct.getAttribute(2); }

  public void _setNorthing(String northing) throws SQLException
  { _struct.setAttribute(2, northing); }


  public String _getDateInstalled() throws SQLException
  { return (String) _struct.getAttribute(3); }

  public void _setDateInstalled(String dateInstalled) throws SQLException
  { _struct.setAttribute(3, dateInstalled); }


  public String _getDateDecomissioned() throws SQLException
  { return (String) _struct.getAttribute(4); }

  public void _setDateDecomissioned(String dateDecomissioned) throws SQLException
  { _struct.setAttribute(4, dateDecomissioned); }


  public String _getContractorOrganisation() throws SQLException
  { return (String) _struct.getAttribute(5); }

  public void _setContractorOrganisation(String contractorOrganisation) throws SQLException
  { _struct.setAttribute(5, contractorOrganisation); }


  public String _getStreetName() throws SQLException
  { return (String) _struct.getAttribute(6); }

  public void _setStreetName(String streetName) throws SQLException
  { _struct.setAttribute(6, streetName); }


  public String _getNatureOfAsset() throws SQLException
  { return (String) _struct.getAttribute(7); }

  public void _setNatureOfAsset(String natureOfAsset) throws SQLException
  { _struct.setAttribute(7, natureOfAsset); }


  public String _getMaterial() throws SQLException
  { return (String) _struct.getAttribute(8); }

  public void _setMaterial(String material) throws SQLException
  { _struct.setAttribute(8, material); }


  public String _getDomainOwner() throws SQLException
  { return (String) _struct.getAttribute(9); }

  public void _setDomainOwner(String domainOwner) throws SQLException
  { _struct.setAttribute(9, domainOwner); }


  public String _getJobReference() throws SQLException
  { return (String) _struct.getAttribute(10); }

  public void _setJobReference(String jobReference) throws SQLException
  { _struct.setAttribute(10, jobReference); }


  public String _getJobType() throws SQLException
  { return (String) _struct.getAttribute(11); }

  public void _setJobType(String jobType) throws SQLException
  { _struct.setAttribute(11, jobType); }


  public String _getTown() throws SQLException
  { return (String) _struct.getAttribute(12); }

  public void _setTown(String town) throws SQLException
  { _struct.setAttribute(12, town); }


  public String _getDepth() throws SQLException
  { return (String) _struct.getAttribute(13); }

  public void _setDepth(String depth) throws SQLException
  { _struct.setAttribute(13, depth); }


  public String _getKerbOffset() throws SQLException
  { return (String) _struct.getAttribute(14); }

  public void _setKerbOffset(String kerbOffset) throws SQLException
  { _struct.setAttribute(14, kerbOffset); }


  public String _getShapeOfAsset() throws SQLException
  { return (String) _struct.getAttribute(15); }

  public void _setShapeOfAsset(String shapeOfAsset) throws SQLException
  { _struct.setAttribute(15, shapeOfAsset); }


  public String _getDimOfAsset() throws SQLException
  { return (String) _struct.getAttribute(16); }

  public void _setDimOfAsset(String dimOfAsset) throws SQLException
  { _struct.setAttribute(16, dimOfAsset); }


  public String _getFittingType() throws SQLException
  { return (String) _struct.getAttribute(17); }

  public void _setFittingType(String fittingType) throws SQLException
  { _struct.setAttribute(17, fittingType); }


  public String _getConstructionType() throws SQLException
  { return (String) _struct.getAttribute(18); }

  public void _setConstructionType(String constructionType) throws SQLException
  { _struct.setAttribute(18, constructionType); }


  public String _getUboInTrench() throws SQLException
  { return (String) _struct.getAttribute(19); }

  public void _setUboInTrench(String uboInTrench) throws SQLException
  { _struct.setAttribute(19, uboInTrench); }


  public String _getUboAssetType() throws SQLException
  { return (String) _struct.getAttribute(20); }

  public void _setUboAssetType(String uboAssetType) throws SQLException
  { _struct.setAttribute(20, uboAssetType); }


  public String _getPhotoType() throws SQLException
  { return (String) _struct.getAttribute(21); }

  public void _setPhotoType(String photoType) throws SQLException
  { _struct.setAttribute(21, photoType); }


  public String _getPreviuosMarker() throws SQLException
  { return (String) _struct.getAttribute(22); }

  public void _setPreviuosMarker(String previuosMarker) throws SQLException
  { _struct.setAttribute(22, previuosMarker); }


  public String _getGeographicLocation() throws SQLException
  { return (String) _struct.getAttribute(23); }

  public void _setGeographicLocation(String geographicLocation) throws SQLException
  { _struct.setAttribute(23, geographicLocation); }


  public String _getSurveyJobNo() throws SQLException
  { return (String) _struct.getAttribute(24); }

  public void _setSurveyJobNo(String surveyJobNo) throws SQLException
  { _struct.setAttribute(24, surveyJobNo); }


  public String _getSurveyMethod() throws SQLException
  { return (String) _struct.getAttribute(25); }

  public void _setSurveyMethod(String surveyMethod) throws SQLException
  { _struct.setAttribute(25, surveyMethod); }


  public IntrenImageList _getImages() throws SQLException
  { return (IntrenImageList) _struct.getAttribute(26); }

  public void _setImages(IntrenImageList images) throws SQLException
  { _struct.setAttribute(26, images); }

;
  // Some setter action is delayed until toDatum() 
  // where the connection is available 
  void _userSetterHelper() throws java.sql.SQLException {} 
}
