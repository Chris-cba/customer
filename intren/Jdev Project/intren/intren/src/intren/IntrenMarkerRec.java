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

public interface IntrenMarkerRec {

  public void setMarkerId(String markerId) throws SQLException;
  public String getMarkerId() throws SQLException;

  public void setEasting(String easting) throws SQLException;
  public String getEasting() throws SQLException;

  public void setNorthing(String northing) throws SQLException;
  public String getNorthing() throws SQLException;

  public void setDateInstalled(String dateInstalled) throws SQLException;
  public String getDateInstalled() throws SQLException;

  public void setDateDecomissioned(String dateDecomissioned) throws SQLException;
  public String getDateDecomissioned() throws SQLException;

  public void setContractorOrganisation(String contractorOrganisation) throws SQLException;
  public String getContractorOrganisation() throws SQLException;

  public void setStreetName(String streetName) throws SQLException;
  public String getStreetName() throws SQLException;

  public void setNatureOfAsset(String natureOfAsset) throws SQLException;
  public String getNatureOfAsset() throws SQLException;

  public void setMaterial(String material) throws SQLException;
  public String getMaterial() throws SQLException;

  public void setDomainOwner(String domainOwner) throws SQLException;
  public String getDomainOwner() throws SQLException;

  public void setJobReference(String jobReference) throws SQLException;
  public String getJobReference() throws SQLException;

  public void setJobType(String jobType) throws SQLException;
  public String getJobType() throws SQLException;

  public void setTown(String town) throws SQLException;
  public String getTown() throws SQLException;

  public void setDepth(String depth) throws SQLException;
  public String getDepth() throws SQLException;

  public void setKerbOffset(String kerbOffset) throws SQLException;
  public String getKerbOffset() throws SQLException;

  public void setShapeOfAsset(String shapeOfAsset) throws SQLException;
  public String getShapeOfAsset() throws SQLException;

  public void setDimOfAsset(String dimOfAsset) throws SQLException;
  public String getDimOfAsset() throws SQLException;

  public void setFittingType(String fittingType) throws SQLException;
  public String getFittingType() throws SQLException;

  public void setConstructionType(String constructionType) throws SQLException;
  public String getConstructionType() throws SQLException;

  public void setUboInTrench(String uboInTrench) throws SQLException;
  public String getUboInTrench() throws SQLException;

  public void setUboAssetType(String uboAssetType) throws SQLException;
  public String getUboAssetType() throws SQLException;

  public void setPhotoType(String photoType) throws SQLException;
  public String getPhotoType() throws SQLException;

  public void setPreviuosMarker(String previuosMarker) throws SQLException;
  public String getPreviuosMarker() throws SQLException;

  public void setGeographicLocation(String geographicLocation) throws SQLException;
  public String getGeographicLocation() throws SQLException;

  public void setSurveyJobNo(String surveyJobNo) throws SQLException;
  public String getSurveyJobNo() throws SQLException;

  public void setSurveyMethod(String surveyMethod) throws SQLException;
  public String getSurveyMethod() throws SQLException;

  public void setImages(IntrenImageList images) throws SQLException;
  public IntrenImageList getImages() throws SQLException;


}
