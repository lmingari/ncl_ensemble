begin
;---Open WRF output file
  fname                 = "anal00031"
  f                     = addfile(fname, "r")
  
;---Open workstation
  wks                   = gsn_open_wks("png","single_wrf")
  
;---Set some common resources
  res                   = True
  res@gsnDraw           = False
  res@gsnFrame          = False

;---Using Native projection
  res@tfDoNDCOverlay    = True
  res@gsnAddCyclic      = False
  
  res@gsnLeftString     = "WRF - Native map projection"
  res@gsnRightString    = ""
  res@gsnCenterString   = ""
  
;---Map plot
  map_res               = True
  map_res@gsnDraw       = False
  map_res@gsnFrame      = False

;---Set map resources based on projection on WRF output file
  map_res = wrf_map_resources(f,map_res)

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

;---Get variables to be read
  data    = f->T2
  times   = wrf_user_getvar(f,"times",-1)
  ntimes  = dimsizes(times)
  data    = data - 273.15
    
;---Draw a new plot
  do it=0,ntimes-1
    print("Working on time: " + times(it))
    
    map       = gsn_csm_map(wks,map_res)  
    contour   = gsn_csm_contour(wks,data(it,:,:), con_res)
    
    ;---Overlay plots on map and draw.
    overlay(map,contour)
    
    draw(map)
    frame(wks)
  end do
end