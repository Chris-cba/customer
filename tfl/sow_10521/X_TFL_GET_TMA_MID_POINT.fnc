CREATE OR REPLACE FUNCTION X_TFL_GET_TMA_MID_POINT( GEOM SDO_GEOMETRY ) RETURN SDO_GEOMETRY DETERMINISTIC 
--
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/customer/tfl/sow_10521/X_TFL_GET_TMA_MID_POINT.fnc-arc   3.0   Sep 02 2009 11:58:24   Ian Turnbull  $
--       Module Name      : $Workfile:   X_TFL_GET_TMA_MID_POINT.fnc  $
--       Date into PVCS   : $Date:   Sep 02 2009 11:58:24  $
--       Date fetched Out : $Modtime:   Sep 02 2009 10:56:00  $
--       PVCS Version     : $Revision:   3.0  $
--       Based on SCCS version :
--
--
--   Author : %USERNAME%
--
--   FUNCTION X_TFL_GET_TMA_MID_POINT( GEOM SDO_GEOMETRY )
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2009
-----------------------------------------------------------------------------
--
-- This function was written for TfL by Aileen Heal as part of SoW 10521 to 
-- calculate the mid point of a TMA geomeotry using the folowing algorithm. 
--
-- If the geometry (geom) is a point then the function returns a point
-- If the geometry has only 2 points then it returns the location of the 1st point
-- If the start/end point of the geometry is within a tolerance of 1.1 metres then
--    it is assumed the geomeotry is a polygon and returns the centroid of the MBR for the polygon
-- If the geometry is a polyline then it returns the middle point of the polyline i.e. if it has 5 points it will 
--    return the 3rd point. 

IS
   d        NUMBER; -- Number of dimensions in geometry
   pStartX  NUMBER; -- X start point
   pStartY  NUMBER; -- Y Start point
   pEndX    NUMBER; -- X end point
   pEndY    NUMBER; -- Y end point
   pMidX    NUMBER; -- X Mid point
   pMidY    NUMBER; -- Y Mid point
   pDeltaX  NUMBER; -- delta X
   pDeltaY  NUMBER; -- delta Y
   pMinX    NUMBER; 
   pMinY    NUMBER; 
   pMaxX    NUMBER; 
   pMaxY    NUMBER; 
   pDist    NUMBER; -- distance  
   pTol     NUMBER := 1.1;  -- tollerance
   pNumPts  NUMBER;
   pPtNum   NUMBER;

BEGIN
   -- Get the number of dimensions from the gtype
   d := SUBSTR (geom.SDO_GTYPE, 1, 1);

   -- calculate number of points in geometry
   pNumPts := geom.sdo_ordinates.count() / d;

   if pNumPts < 0 then
      return null;
   
   elsif pNumPts < 3 then  -- point or line with 2 points return 1st point
     -- use the 1st point
     pMidX := geom.SDO_ORDINATES(1);
     pMidY := geom.SDO_ORDINATES(2);
   
   else -- 3 or more points
     -- get start point
     pStartX := geom.SDO_ORDINATES(1);
     pStartY := geom.SDO_ORDINATES(2);
     
     -- get end point
     pEndX := geom.SDO_ORDINATES((pNumPts-1) * d + 1);
     pEndY := geom.SDO_ORDINATES((pNumPts-1) * d + 2);  
    
     -- calcuate the deltas
     pDeltaX := pEndX - pStartX;
     pDeltaY := pEndY - pStartY;
    
     -- calcualte distance between start/end point
     pDist := sqrt(pDeltaX*pDeltaX + pDeltaY*PdeltaY);
    
     if PDist > pTol then  -- polyline not polygon -- get middle point
        
        -- work out the number of the middle point 
        pPtNum := trunc(pNumPts*0.5+ 0.5);   

        -- Extract the X and Y coordinates of the desired point
        pMidX := geom.SDO_ORDINATES((pPtNum-1) * d + 1);
        pMidY := geom.SDO_ORDINATES((pPtNum-1) * d + 2);

     else -- we have a polygon return the middle of the mbr 
       
       -- get extents of mbr
       pMinX := sdo_geom.sdo_min_mbr_ordinate(geom,1);
       pMinY := sdo_geom.sdo_min_mbr_ordinate(geom,2);
       pMaxX := sdo_geom.sdo_max_mbr_ordinate(geom,1);
       pMaxY := sdo_geom.sdo_max_mbr_ordinate(geom,2);
    
       -- calculate centroid of mbr
       pMidX := (pMinX + pMaxX) * 0.5;
       pMidY := (pMinY + pmaxY) * 0.5;
     end if;     
   
   end if;

   -- Construct and return the point
   RETURN MDSYS.SDO_GEOMETRY (2001, geom.SDO_SRID,SDO_POINT_TYPE (pMidX, pMidY, NULL),NULL, NULL);

END;
/


  
