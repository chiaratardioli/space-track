!
! Copyright (c) Stardust
! Chiara Tardioli (c.tardioli@strath.ac.uk)
! Version: May 22, 2015
! --------------------------------------------------------------------- 
!                                                                       
!  *****************************************************************    
!  *                                                               *    
!  *              SATELLITE CATALOG IN TABLE FORMAT                * 
!  *                                                               *    
!  *      Given the satcat.txt, add column names and               *
!  *            put it in a table separeted by "|"                 *
!  *                                                               *
!  *****************************************************************    

! INPUT: The satcat.txt file downloaded from http://www.celestrack.com/
! OUTPUT: The same file but in a table format
! USAGE: Compile e.g., using $ifort SAT2TABLE.f90 -o SAT2TABLE.x
!        Run with $./SAT2TABLE

program SAT2TABLE


!Constants
  implicit none !There is no implicit variables

  integer, parameter :: double_prec = selected_real_kind(15)

  real(double_prec), parameter :: pi=4d0*datan(1d0)
  real(double_prec), parameter :: mu=0.39860044144982d15 ! [m³/kg/s²]

  integer,parameter :: nlines=100000   !maximum number of lines.

! Variables
  character(11) intdes,country,launch_date,launch_site,rcs,status,decay,type
  character(1) multi_falg,payload_flag,operational_flag
  character(11) norad_id,apogee_altitude,perigee_altitude,period,inc
  character(24) satname,tmp
 
  integer i,first,last
 
! ----------------------------------------------------------------------

! Open files
 open(10, file='satcat.txt', status='OLD')
 open(11, file='satcat.fla', status='UNKNOWN')

! Write file header
! write(11,100)'NORAD_ID','SATNAME','INTDES','TYPE','COUNTRY', &
!      & 'LAUNCH','SITE','DECAY','PERIOD','INCL','APO','PERI','RCS','STATUS'
!100 format(a8,1x,a24,1x,a11,1x,a11,1x,a7,1x,a10,1x,a5,1x,a10,1x,a7,1x,a5,1x,a6,1x,a6,1x,a8,1x,a6)

 write(11,100)'NORAD_ID','|','SATNAME','|','INTDES','|','TYPE','|','COUNTRY','|', &
      & 'LAUNCH','|','SITE','|','DECAY','|','PERIOD','|','INCL','|','APO','|', &
      & 'PERI','|','RCS','|','STATUS'
100 format(a11,1x,a1,a24,12(a1,a11))

! DO LOOP
 DO i=1, nlines ! The number of objects in the input file

    ! Read input files
    read(10,101,END=999) intdes,norad_id,multi_falg,payload_flag,operational_flag, &
         & satname,country,launch_date,launch_site,decay, &
         & period,inc,apogee_altitude,perigee_altitude,rcs,status

!    if( intdes == "") GOTO 5

    ! Object type : PAYLOAD - ROCKET_BODY - DEBRIS
    if( ichar(payload_flag).eq.42 ) then
       write(type,'(a11)') 'PAYLOAD'
!       write(*,*)i,payload_flag,ichar(payload_flag),type
    elseif( index(satname,'R/B') > 0 ) then
        write(type,'(a11)') 'ROCKET_BOBY'
!       write(*,*)i, satname, type
    else  
       ! if( index(satname,'DEB') > 0 | index(satname,'PLAT') > 0 )
       write(type,'(a11)') 'DEBRIS'
!       write(*,*)i, satname, type
    endif

    if( operational_flag == 'U' ) then
        write(type,'(a11)') 'U'
       write(*,*) i, type
       read(*,*)
    endif

    ! Satellite name without spaces
!    tmp = replace_text(satname,' ','_')
!    write(satname,'(a24)') tmp

!!$    ! Decay
!!$    if( decay == "") then
!!$       write(decay,'(a10)') "NA"
!!$!       write(*,*)i,decay
!!$    endif
!!$
!!$    ! period,inc,apogee_altitude,perigee_altitude
!!$    if( period == "" ) then
!!$!       write(*,*)i,period,inc,apogee_altitude,perigee_altitude
!!$       write(period,'(a7)') "NA"
!!$       write(inc,'(a5)') "NA"
!!$       write(apogee_altitude,'(a6)') "NA"
!!$       write(perigee_altitude,'(a6)') "NA"
!!$    endif
!!$
    ! Radar Cross Section [meters2]
    if( index(rcs,'N/A') > 0 ) then
       write(rcs,'(a8)') ""
!       write(*,*)i,rcs
    endif
!!$
!!$    ! Orbital Status Code
!!$    if( status == "") then
!!$       write(status,'(a6)') "NA"
!!$!       write(*,*) i,status
!!$    endif

    ! Write on output file    
!    write(11,102) norad_id,satname,intdes,type,country,launch_date,launch_site,decay, &
!         & period,inc,apogee_altitude,perigee_altitude,rcs,status

    write(11,*) norad_id,'|',satname,'|',intdes,'|',type,'|',country,'|',launch_date,'|', &
         launch_site,'|',decay,'|',period,'|',inc,'|',apogee_altitude,'|', & 
         perigee_altitude,'|',rcs,'|',status

5   CONTINUE
 ENDDO
 write(*,*)'Do loop too shoort',i,nlines
999 CONTINUE
! write(*,*) 'File ended successfully'

101 format(a11,2x,a5,1x,a1,a1,a1,1x,a24,2x,a5,2x,a10,2x,a5,2x,a10,2x,a7,2x,a5,2x,a6,2x,a6,2x,a8,2x,a3)
102 format(a8,1x,a24,1x,a11,1x,a11,1x,a7,1x,a10,1x,a5,1x,a10,1x,a7,1x,a5,1x,a6,1x,a6,1x,a8,1x,a6)

 close(10)
 close(11)

CONTAINS

  FUNCTION replace_text(s,text,rep)  RESULT(outs)
    ! Replace_Text   in all occurances in string with replacement string
    implicit none
    CHARACTER(30)        :: s
    CHARACTER :: text,rep
    CHARACTER(LEN(s)+100) :: outs     ! provide outs with extra 100 char len
    INTEGER             :: i, nt, nr, m, j
    
    outs = s
    m = LEN_TRIM(s)
    nt = LEN_TRIM(text)
    nr = LEN_TRIM(rep)
    if( nt.gt.1.OR.nr.gt.1) then
       write(*,*)'only character of length 1 can be replaced'
       write(*,*)nt,nr
       stop
    endif
    
    DO j=1,m
       i = INDEX(outs,text)
!       write(*,*)i,m,outs,text
       IF (i == m+1) EXIT
       outs = outs(:i-1) // rep // outs(i+1:)
    END DO
    
  END FUNCTION replace_text
  
end program SAT2TABLE

