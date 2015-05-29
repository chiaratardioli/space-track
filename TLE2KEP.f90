!
! Daniel Casanova (casanov@unizar.es)
! Version: May 20, 2014
! Modified by Chiara Tardioli, May 22, 2015
! --------------------------------------------------------------------- 
!                                                                       
!  *****************************************************************    
!  *                                                               *    
!  *              TWO LINE ELEMTS TO ORBITAL ELEMENTS              * 
!  *                                                               *    
!  *      Given the file.txt with the TLE information from         *
!  *  a piece of space debris, we compute the orbital elements     *    
!  *                                                               *
!  *****************************************************************    

! INPUT: The TLE 'file.txt' download from http://www.space-track.org/
! OUTPUT: The orbital elements 'file_oe.fla' 
! EXPLANATION: Given the TLE file we run the program and it compute the orbital
!              elements of each object in the file. 
! USAGE: We change the 'file.txt' and the 'file_oe.fla' according to our data and we
!        compile $ifort TLE2KEP.f90 -o TLE2KEP.x , $./TLE2KEP

program TLE2KEP


!Constants
  implicit none !There is no implicit variables

  integer, parameter :: double_prec = selected_real_kind(15)

  real(double_prec), parameter :: pi=4d0*datan(1d0)
  real(double_prec), parameter :: mu=0.39860044144982d15 ! [m³/kg/s²]

! Variables
  integer i, iend  !The index for the loop and the integer used when reading a file.
  integer nlines   !Number of lines in the 'file.fla'. Note that, objects = nlines/3
 
  integer line, satNum, revol_number           !Variables of the TLE catalog
  real(double_prec) inc, RAAN, ecc, argp, M, n 
 
  real(double_prec) sma
  character(30) eccentricity



!Open the TLE file and count the number of lines in the file
 nlines = 0
 open(10, file='file.txt', status='OLD')
 do
    read(10,*, END=20)
    nlines = nlines + 1
 end do
20 close(10)

!DO loop
 open(10, file='file.txt', status='OLD')
 open(11, file='file_oe.fla', status='UNKNOWN')

!Write file header
    write(11,100)'NORAD_ID','sma_meter','ecc','inc_deg','RAAN_deg','argp_deg','M_deg'
100 format(a8,2x,a14,5(1x,a14))

 DO i=1, nlines/3 ! The number of objects in the .txt file
!Read the rows (1,2,3), (4,5,6) ... The third line is the important one
    read(10,*)
    read(10,*)
    read(10,30,iostat=iend)line,satNum,inc,RAAN,eccentricity,argp,M,n,revol_number
30 format(1i2,1i6,2f9.4,1a7,2f9.4,1f12.8,1i6) 
   
!Compute the values sma, ecc, inc, ...
    eccentricity = '0.'//eccentricity
    read(eccentricity,*)ecc
    n = (n*1d0)*2d0*pi/(24d0*3600d0)  !Conversion from [revolution/day] to [rad/sec]
    sma = (mu/(n*n))**(1d0/3d0); ![m]

!Write the orbital elements in a file
    write(11,40)satNum,sma,ecc,inc,RAAN,argp,M
40  format(1i8,2x,f14.4,5(1x,f14.8))

 END DO
 close(10)
 close(11)

end program TLE2KEP
