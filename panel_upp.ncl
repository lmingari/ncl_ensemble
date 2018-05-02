begin
  start_cpu_time = get_cpu_time()

;---Number of rows?
  nrows   = 10

;---List of UPP files
  nfiles    = 60
  dd        = ispan(0,nfiles-1,1)
  paths     = "./"
  files     = "SFC_"+ sprinti("%0.2i", dd+1) + "_20170923_19.000"
;  print(paths+files)

;---Open files using addfiles
  f                     = addfiles(paths+files,"r")

;---Open workstation
  wks                   = gsn_open_wks("pdf","panel_upp")

;---Set common resources for all plots
  res                   = True
  res@gsnFrame          = False
  res@gsnDraw           = False

;---Using Native projection
  res@tfDoNDCOverlay    = True
  res@gsnAddCyclic      = False

  res@gsnLeftString     = ""
  res@gsnRightString    = ""
  res@gsnCenterString   = ""

;---Map plot
  map_res               = True
  map_res@gsnFrame      = False
  map_res@gsnDraw       = False

;---Set map resources based on projection on UPP output file
  map_res@mpProjection                = "LambertConformal"
  map_res@mpLambertParallel1F         = f[0]->g3_lat_0@Latin1
  map_res@mpLambertParallel2F         = f[0]->g3_lat_0@Latin2
  map_res@mpLambertMeridianF          = f[0]->g3_lon_1@Lov
  map_res@mpLimitMode                 = "Corners"
  map_res@mpLeftCornerLatF            = f[0]->g3_lat_0@corners(0)
  map_res@mpLeftCornerLonF            = f[0]->g3_lon_1@corners(0)
  map_res@mpRightCornerLatF           = f[0]->g3_lat_0@corners(2)
  map_res@mpRightCornerLonF           = f[0]->g3_lon_1@corners(2)

;---Map resources
  map_res@mpFillOn                    = False
  map_res@mpOutlineOn                 = True
  map_res@mpDataBaseVersion           = "MediumRes"
  map_res@mpDataSetName               = "Earth..4"
  map_res@mpOutlineDrawOrder          = "PostDraw"

  map_res@mpOutlineBoundarySets       = "National"
  map_res@mpNationalLineColor         = "Black"
  map_res@mpGeophysicalLineColor      = "Black"
  map_res@mpNationalLineThicknessF    = 0.2
  map_res@mpGeophysicalLineThicknessF = 0.2
  ;map_res@mpMaskOutlineSpecifiers     = "Argentina"

  map_res@tmXBLabelFontHeightF        = 0.012
  map_res@tmYLLabelFontHeightF        = 0.012
  map_res@tmYLLabelAngleF             = 90
  map_res@tmYLLabelJust               = "CenterCenter"
  map_res@tmYRLabelFontHeightF        = 0.012
  map_res@tmYRLabelAngleF             = 90
  map_res@tmYRLabelJust               = "CenterCenter" 
 
  map_res@tmBorderThicknessF          = 0.1
  map_res@tmXBMajorThicknessF         = 0.1
  map_res@tmXTMajorThicknessF         = 0.1
  map_res@tmYRMajorThicknessF         = 0.1
  map_res@tmYLMajorThicknessF         = 0.1

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

  con_res@lbLabelBarOn                = False

;---Read in "join" mode
  ListSetType (f, "join") 

;---Get variables to be read
  data = f[:]->TMP_GDS3_HTGL
  data = data - 273.15

  ncols   = nfiles/nrows
  if(nfiles%nrows .gt. 0) then
    ncols = ncols + 1
  end if
    
  map     = new(nfiles,graphic)
  contour = new(nfiles,graphic)

;---Loop through each time step and draw a new plot
  do it=0,nfiles-1
    print("Working for member " + it)

    if (it .lt. ncols) then
      map_res@tmXTLabelsOn = True            
      map_res@tmXTOn       = True
    else
      map_res@tmXTLabelsOn = False           
      map_res@tmXTOn       = False
    end if

    if (it .ge. ncols*(nrows-1)) then
      map_res@tmXBLabelsOn = True            
      map_res@tmXBOn       = True            
    else
      map_res@tmXBLabelsOn = False           
      map_res@tmXBOn       = False
    end if

    if (it%ncols .eq. 0) then
      map_res@tmYLLabelsOn = True
      map_res@tmYLOn       = True
    else
      map_res@tmYLLabelsOn = False
      map_res@tmYLOn       = False
    end if

    if (it%ncols .eq. ncols-1 .or. it .eq. nfiles-1) then
      map_res@tmYRLabelsOn = True
      map_res@tmYROn       = True
    else
      map_res@tmYRLabelsOn = False
      map_res@tmYROn       = False
    end if
    
    map(it)     = gsn_csm_map(wks,map_res)  
    contour(it) = gsn_csm_contour(wks,data(it,:,:),con_res)

    ;---Overlay plots on map and draw.
    overlay(map(it),contour(it))
  end do

  pnlres                           = True
  pnlres@gsnPanelMainString        = ""
  pnlres@gsnPanelLabelBar          = True

  pnlres@lbLabelBarOn              = True  
  pnlres@lbBoxEndCapStyle          = "TriangleBothEnds"
  pnlres@lbTitleString             = "Temperature (~F34~0~F~C)"
  pnlres@lbTitleFontHeightF        = 0.014
  
  pnlres@pmLabelBarWidthF          = 0.35
  pnlres@pmLabelBarHeightF         = 0.07
  pnlres@pmLabelBarOrthogonalPosF  = -0.02
  pnlres@gsnPanelBottom            = 0.05

  gsn_panel(wks,map,(/nrows,ncols/),pnlres)

  end_cpu_time = get_cpu_time()
  print(get_script_prefix_name() + ": elapsed time = " + (end_cpu_time-start_cpu_time) + " seconds.")
end


