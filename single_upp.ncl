begin
;---Open UPP output file
  fname                 = "SFC_31_20170923_19.000"
  f                     = addfile(fname,"r")

;---Open workstation
  wks                   = gsn_open_wks("png","single_upp")

;---Set common resources for all plots
  res                   = True
  res@gsnFrame          = False
  res@gsnDraw           = False

;---Using Native projection
  res@tfDoNDCOverlay    = True
  res@gsnAddCyclic      = False

  res@gsnLeftString     = "UPP - Native map projection"
  res@gsnRightString    = ""
  res@gsnCenterString   = ""

;---Map plot
  map_res               = True
  map_res@gsnFrame      = False
  map_res@gsnDraw       = False

;---Set map resources based on projection on UPP output file
  map_res@mpProjection                = "LambertConformal"
  map_res@mpLambertParallel1F         = f->g3_lat_0@Latin1
  map_res@mpLambertParallel2F         = f->g3_lat_0@Latin2
  map_res@mpLambertMeridianF          = f->g3_lon_1@Lov
  map_res@mpLimitMode                 = "Corners"
  map_res@mpLeftCornerLatF            = f->g3_lat_0@corners(0)
  map_res@mpLeftCornerLonF            = f->g3_lon_1@corners(0)
  map_res@mpRightCornerLatF           = f->g3_lat_0@corners(2)
  map_res@mpRightCornerLonF           = f->g3_lon_1@corners(2)

;---Map resources
  map_res@mpFillOn                    = False
  map_res@mpOutlineOn                 = True
  map_res@mpDataBaseVersion           = "MediumRes"
  map_res@mpDataSetName               = "Earth..4"
  map_res@mpOutlineDrawOrder          = "PostDraw"

  map_res@mpOutlineBoundarySets       = "National"
  map_res@mpNationalLineColor         = "Black"
  map_res@mpGeophysicalLineColor      = "Black"
  map_res@mpNationalLineThicknessF    = 1.5
  map_res@mpGeophysicalLineThicknessF = 1.5
  ;map_res@mpMaskOutlineSpecifiers     = "Argentina"

  map_res@tmXTOn                      = False
  map_res@tmYROn                      = False
  map_res@tmXTLabelsOn                = False
  map_res@tmYRLabelsOn                = False
  map_res@tmXBLabelFontHeightF        = 0.012
  map_res@tmYLLabelFontHeightF        = 0.012
  map_res@tmYLLabelAngleF             = 90
  map_res@tmYLLabelJust               = "CenterCenter"
  
  map_res@pmTickMarkDisplayMode       = "Always"
  
;---Color Palette
  cmap = read_colormap_file("MPL_RdYlBu")
  cmap = cmap(::-1,:) ; reverse the color map 

;---CONTOUR filled contour plot
  con_res                             = res
  con_res@cnFillOn                    = True
  con_res@cnLinesOn                   = False
  con_res@cnLineLabelsOn              = False
  con_res@cnInfoLabelOn               = False
  con_res@cnRasterModeOn              = False

  con_res@cnLevelSelectionMode        = "ManualLevels"
  con_res@cnMinLevelValF              = 12
  con_res@cnMaxLevelValF              = 30
  con_res@cnLevelSpacingF             = 0.5

  con_res@cnFillPalette               = cmap

  con_res@lbLabelBarOn                = True
  con_res@lbBoxEndCapStyle            = "TriangleBothEnds"
  con_res@lbTitleString               = "Temperature (~F34~0~F~C)"
  con_res@lbTitleFontHeightF          = 0.018
  con_res@lbLabelFontHeightF          = 0.012
  con_res@lbLabelStride               = 6

  con_res@pmLabelBarHeightF           = 0.07
  con_res@pmLabelBarOrthogonalPosF    = 0.03
  ;con_res@lbTitleOffsetF              = -0.4

;---Get variables to be read
  data = f->TMP_GDS3_HTGL
  data = data - 273.15

;---Draw a new plot
  map     = gsn_csm_map(wks,map_res)
  contour = gsn_csm_contour(wks,data,con_res)

;---Overlay plots on map and draw.
  overlay(map,contour)
  
  draw(map)   ; This will draw all overlaid plots and the map
  frame(wks)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
end
