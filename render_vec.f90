!--------------------------------------------------------------------------
!  this subroutine takes a 2D grid of vector data (ie. x and y components)
!  and plots an arrow map of it
!--------------------------------------------------------------------------
 
subroutine render_vec(vecpixx,vecpixy,vecmax,npixx,npixy,        &
                  xmin,ymin,dx,label) 
 use legends, only:legend_vec
 use settings_vecplot, only:iVecplotLegend
 implicit none
 integer, intent(in) :: npixx,npixy
 real, intent(in) :: xmin,ymin,vecmax,dx
 real, dimension(npixx,npixy), intent(in) :: vecpixx,vecpixy
 character(len=*), intent(in) :: label
 real :: trans(6),vmax,scale
 real :: charheight
 
!set up grid for rendering 

 trans(1) = xmin !- 0.5*dx                ! this is for the pgimag call
 trans(2) = dx                        ! see help for pgimag/pggray/pgcont
 trans(3) = 0.0
 trans(4) = ymin !- 0.5*dx
 trans(5) = 0.0
 trans(6) = dx

 print*,trim(label),' vector plot..',npixx,'x',npixy,',array size=',size(vecpixx)
 print*,'max(x component) = ',maxval(vecpixx),'max(y component) = ',maxval(vecpixy)

 call pgsah(2,45.0,0.7)   ! arrow style
 call pgqch(charheight)
 call pgsch(0.3)          ! size of arrow head
 if (vecmax.le.0.0) then  ! adaptive limits
    scale = 0.0
    vmax = max(maxval(vecpixx(:,:)),maxval(vecpixy(:,:)))
    if (vmax.gt.0.) scale = 0.1/vmax
 else
    scale=0.1/vecmax
 endif
 print*,' scale = ',scale
 
 call pgvect(vecpixx(:,:),vecpixy(:,:),npixx,npixy, &
      1,npixx,1,npixy,scale,0,trans,-1000.0)

 if (iVecplotLegend) then
    call legend_vec(vmax,scale,label,charheight)
 endif
 call pgsch(charheight)
 
 return
 
end subroutine render_vec
