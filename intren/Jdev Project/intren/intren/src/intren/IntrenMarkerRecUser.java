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

public class IntrenMarkerRecUser extends IntrenMarkerRecBase implements ORAData, ORADataFactory, IntrenMarkerRec
{
   private static final IntrenMarkerRecUser _IntrenMarkerRecUserFactory = new IntrenMarkerRecUser();
   public static ORADataFactory getORADataFactory()
   { return _IntrenMarkerRecUserFactory; }

   public IntrenMarkerRecUser() { super(); }
   public IntrenMarkerRecUser(Connection conn) throws SQLException { super(conn); } 
  public IntrenMarkerRecUser(String markerId, String easting, String northing, String dateInstalled, String dateDecomissioned, String contractorOrganisation, String streetName, String natureOfAsset, String material, String domainOwner, String jobReference, String jobType, String town, String depth, String kerbOffset, String shapeOfAsset, String dimOfAsset, String fittingType, String constructionType, String uboInTrench, String uboAssetType, String photoType, String previuosMarker, String geographicLocation, String surveyJobNo, String surveyMethod, IntrenImageList images) throws SQLException
  {
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
   public ORAData create(Datum d, int sqlType) throws SQLException
   { return create(new IntrenMarkerRecUser(), d, sqlType); }

  /* superclass accessors */

  public void setMarkerId(String markerId) throws SQLException { super._setMarkerId(markerId); }
  public String getMarkerId() throws SQLException { return super._getMarkerId(); }


  public void setEasting(String easting) throws SQLException { super._setEasting(easting); }
  public String getEasting() throws SQLException { return super._getEasting(); }


  public void setNorthing(String northing) throws SQLException { super._setNorthing(northing); }
  public String getNorthing() throws SQLException { return super._getNorthing(); }


  public void setDateInstalled(String dateInstalled) throws SQLException { super._setDateInstalled(dateInstalled); }
  public String getDateInstalled() throws SQLException { return super._getDateInstalled(); }


  public void setDateDecomissioned(String dateDecomissioned) throws SQLException { super._setDateDecomissioned(dateDecomissioned); }
  public String getDateDecomissioned() throws SQLException { return super._getDateDecomissioned(); }


  public void setContractorOrganisation(String contractorOrganisation) throws SQLException { super._setContractorOrganisation(contractorOrganisation); }
  public String getContractorOrganisation() throws SQLException { return super._getContractorOrganisation(); }


  public void setStreetName(String streetName) throws SQLException { super._setStreetName(streetName); }
  public String getStreetName() throws SQLException { return super._getStreetName(); }


  public void setNatureOfAsset(String natureOfAsset) throws SQLException { super._setNatureOfAsset(natureOfAsset); }
  public String getNatureOfAsset() throws SQLException { return super._getNatureOfAsset(); }


  public void setMaterial(String material) throws SQLException { super._setMaterial(material); }
  public String getMaterial() throws SQLException { return super._getMaterial(); }


  public void setDomainOwner(String domainOwner) throws SQLException { super._setDomainOwner(domainOwner); }
  public String getDomainOwner() throws SQLException { return super._getDomainOwner(); }


  public void setJobReference(String jobReference) throws SQLException { super._setJobReference(jobReference); }
  public String getJobReference() throws SQLException { return super._getJobReference(); }


  public void setJobType(String jobType) throws SQLException { super._setJobType(jobType); }
  public String getJobType() throws SQLException { return super._getJobType(); }


  public void setTown(String town) throws SQLException { super._setTown(town); }
  public String getTown() throws SQLException { return super._getTown(); }


  public void setDepth(String depth) throws SQLException { super._setDepth(depth); }
  public String getDepth() throws SQLException { return super._getDepth(); }


  public void setKerbOffset(String kerbOffset) throws SQLException { super._setKerbOffset(kerbOffset); }
  public String getKerbOffset() throws SQLException { return super._getKerbOffset(); }


  public void setShapeOfAsset(String shapeOfAsset) throws SQLException { super._setShapeOfAsset(shapeOfAsset); }
  public String getShapeOfAsset() throws SQLException { return super._getShapeOfAsset(); }


  public void setDimOfAsset(String dimOfAsset) throws SQLException { super._setDimOfAsset(dimOfAsset); }
  public String getDimOfAsset() throws SQLException { return super._getDimOfAsset(); }


  public void setFittingType(String fittingType) throws SQLException { super._setFittingType(fittingType); }
  public String getFittingType() throws SQLException { return super._getFittingType(); }


  public void setConstructionType(String constructionType) throws SQLException { super._setConstructionType(constructionType); }
  public String getConstructionType() throws SQLException { return super._getConstructionType(); }


  public void setUboInTrench(String uboInTrench) throws SQLException { super._setUboInTrench(uboInTrench); }
  public String getUboInTrench() throws SQLException { return super._getUboInTrench(); }


  public void setUboAssetType(String uboAssetType) throws SQLException { super._setUboAssetType(uboAssetType); }
  public String getUboAssetType() throws SQLException { return super._getUboAssetType(); }


  public void setPhotoType(String photoType) throws SQLException { super._setPhotoType(photoType); }
  public String getPhotoType() throws SQLException { return super._getPhotoType(); }


  public void setPreviuosMarker(String previuosMarker) throws SQLException { super._setPreviuosMarker(previuosMarker); }
  public String getPreviuosMarker() throws SQLException { return super._getPreviuosMarker(); }


  public void setGeographicLocation(String geographicLocation) throws SQLException { super._setGeographicLocation(geographicLocation); }
  public String getGeographicLocation() throws SQLException { return super._getGeographicLocation(); }


  public void setSurveyJobNo(String surveyJobNo) throws SQLException { super._setSurveyJobNo(surveyJobNo); }
  public String getSurveyJobNo() throws SQLException { return super._getSurveyJobNo(); }


  public void setSurveyMethod(String surveyMethod) throws SQLException { super._setSurveyMethod(surveyMethod); }
  public String getSurveyMethod() throws SQLException { return super._getSurveyMethod(); }


  public void setImages(IntrenImageList images) throws SQLException { super._setImages(images); }
  public IntrenImageList getImages() throws SQLException { return super._getImages(); }



}
