!-------------------------------------------------------------------------------------------------------------------------------
! This program is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! This program is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with this program.  If not, see <http://www.gnu.org/licenses/>.
!
!                       Copyright (C) 2002 by
!   National Institute of Public Health and Environment
!           Laboratory for Air Research (RIVM/LLO)
!                      The Netherlands
!
! MODULE             : m_commonfile
! FILENAME           : %M%
! SCCS(SOURCE)       : %P%
! RELEASE - LEVEL    : %R% - %L%
! BRANCH - SEQUENCE  : %B% - %S%
! DATE - TIME        : %E% - %U%
! WHAT               : %W%:%E%
! AUTHOR             : Martien de Haan (ARIS)
! FIRM/INSTITUTE     : RIVM/LLO
! LANGUAGE           : FORTRAN-F90
! DESCRIPTION        : Define file unit numbers and file names. Subroutine to make full file name.
! EXIT CODES         :
! FILES AND OTHER    :
!    I/O DEVICES
! SYSTEM DEPENDENCIES: HP Fortran
! CALLED FUNCTIONS   :
! UPDATE HISTORY :
!-------------------------------------------------------------------------------------------------------------------------------
MODULE m_commonfile

IMPLICIT NONE
!
! CONSTANTS - File names
!
CHARACTER*12, PARAMETER                          :: BASEMASK     = 'basemask.ops' ! base mask for The Netherlands (500mx500m)
CHARACTER*12, PARAMETER                          :: Z0EURFILE    = 'z0eur.ops'    ! standard file for z0 in Europe
CHARACTER*12, PARAMETER                          :: DVFILE       = 'dvepre.ops'   ! standard file for diurnal variations 
CHARACTER*12, PARAMETER                          :: PSDFILE      = 'pmdpre.ops'   ! standard file for particle size distributions
!
! CONSTANTS - Standard fileunits
!
INTEGER*4, PARAMETER                             :: IOB_IU       = 1           ! currently not used
INTEGER*4, PARAMETER                             :: IOB_SETUP    = 2           ! currently not used
INTEGER*4, PARAMETER                             :: IOB_STDIN    = 5           ! currently not used  
INTEGER*4, PARAMETER                             :: IOB_STDOUT   = 6           ! standard output     
INTEGER*4, PARAMETER                             :: IOB_STDERR   = 7           ! currently not used  
!
! CONSTANTS - Other fileunits
!
INTEGER*4, PARAMETER                             :: fu_input     = 100         ! unit number input (control) file
INTEGER*4, PARAMETER                             :: fu_log       = 200         ! unit number log file
INTEGER*4, PARAMETER                             :: fu_exit      = 300         ! currently not used
INTEGER*4, PARAMETER                             :: fu_progress  = 350         ! unit number progress file
INTEGER*4, PARAMETER                             :: fu_scratch   = 400         ! unit number scratch file
INTEGER*4, PARAMETER                             :: fu_bron      = 500         ! unit number sources file
INTEGER*4, PARAMETER                             :: fu_dist      = 550         ! unit number distributions file (e.g. diurnal variations, particle size distributions)
INTEGER*4, PARAMETER                             :: fu_recep     = 600         ! unit number receptor file
INTEGER*4, PARAMETER                             :: fu_mask      = 600         ! unit number mask file
INTEGER*4, PARAMETER                             :: fu_klim      = 700         ! unit number meteo statistics file
INTEGER*4, PARAMETER                             :: fu_z0        = 700         ! unit number z0 file
INTEGER*4, PARAMETER                             :: fu_plt       = 800         ! unit number plot file
INTEGER*4, PARAMETER                             :: fu_prt       = 900         ! unit number print file
INTEGER*4, PARAMETER                             :: fu_err       = 950         ! unit number error file
!
! VARIABLES - Directories
!
CHARACTER*512                                    :: datadir                    ! directory for data files
!
! VARIABLES - File names
!
CHARACTER*512                                    :: ctrnam                     ! name of control file
CHARACTER*512                                    :: indnam                     ! name of file with progress indicator
CHARACTER*512                                    :: errnam                     ! name of file with error information
CHARACTER*512                                    :: logname                    ! name of log file

CHARACTER*512                                    :: brnam                      ! name of file with emission sources
CHARACTER*512                                    :: namrecept                  ! name of file with receptor coordinates
CHARACTER*512                                    :: kname                      ! name of meteo statistics file (non-interpolated meteo)

CHARACTER*512                                    :: prnnam                     ! name of printer output file
CHARACTER*512                                    :: pltnam                     ! name of plot output file

CHARACTER*512                                    :: dvnam                      ! name of file with pre-defined diurnal variations
CHARACTER*512                                    :: psdnam                     ! name of file with pre-defined particle size distributions
CHARACTER*512                                    :: usdvnam                    ! name of file with user-defined diurnal variations
CHARACTER*512                                    :: uspsdnam                   ! name of file with user-defined particle size distributions

CHARACTER*512                                    :: masknam                    ! name of file with Netherlands mask
CHARACTER*512                                    :: z0file                     ! name of file with z0 values for NL
CHARACTER*512                                    :: lufile                     ! name of file with land use data
CHARACTER*512                                    :: z0eurnam                   ! name of file with z0 values for Europe

CHARACTER*24                                     :: map_so2(5)                 ! name of file with background map SO2 (for 4 years)
CHARACTER*24                                     :: map_nox(5)                 ! name of file with background map NOx (for 4 years)
CHARACTER*24                                     :: map_nh3(5)                 ! name of file with background map NH3 (for 4 years)

DATA map_so2  / 'bgso2c1984.ops', 'bgso2c1994.ops', 'bgso2c2005.ops', 'bgso2c2012.ops','bgso2c2020.ops' /
DATA map_nox  / 'bgnoxc1984.ops', 'bgnoxc1994.ops', 'bgnoxc2005.ops', 'bgnoxc2012.ops','bgnoxc2020.ops' /
DATA map_nh3  / 'bgnh3c1984.ops', 'bgnh3c1994.ops', 'bgnh3c2005.ops', 'bgnh3c2012.ops','bgnh3c2020.ops' /
!-------------------------------------------------------------------------------------------------------------------------------
! SUBROUTINE  : MakeCommonPath
! DESCRIPTION : Generates full file names for the common background or diurnal variation files and checks existence. An error is
!               returned if the filename becomes too long (which is not very likely) or if the file does not exist (which
!               probably happens more often).
! REMARKS     : - The file directory is the common datadir directory.
!               - Does nothing is error is set before entrance.
! INPUTS      : fileentry  (character*(*). Name of the file, without path.
! OUTPUTS     : filepath   (character*(*)). Variable in which full path is stored. Required because the path can be written
!                           somewhere else.
! INPUT/OUTPUT: error      (TError object). Assigned when an error occurred.
!-------------------------------------------------------------------------------------------------------------------------------
INTERFACE MakeCommonPath
   MODULE PROCEDURE MakeCommonPath
END INTERFACE

CONTAINS

!-------------------------------------------------------------------------------------------------------------------------------
! SUBROUTINE: get_version_core
!-------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE get_version_core(dll_version, dll_date)

! CONSTANTS
CHARACTER*512                                    :: ROUTINENAAM                ! 
PARAMETER     (ROUTINENAAM = 'get_version_core')

! SUBROUTINE ARGUMENTS - OUTPUT
CHARACTER*(*), INTENT(OUT)                       :: dll_version                ! 
CHARACTER*(*), INTENT(OUT)                       :: dll_date                   ! 

! SCCS-ID VARIABLES
CHARACTER*81                                     :: sccsida                    ! 
sccsida = '%W%:%E%'// char (0)
!-------------------------------------------------------------------------------------------------------------------------------
!
dll_version="1.0.0"
dll_date="28 jun 2012"

END SUBROUTINE get_version_core

!-------------------------------------------------------------------------------------------------------------------------------
! SUBROUTINE           : MakeCommonPath
! INTERFACE            : MakeCommonPath
! PURPOSE              : Make common file path and check whether the file exists.
!-------------------------------------------------------------------------------------------------------------------------------
SUBROUTINE MakeCommonPath(fileentry, filepath, error)

USE m_error
USE m_string
USE m_fileutils

! SUBROUTINE ARGUMENTS - INPUT
CHARACTER*(*), INTENT(IN)                        :: fileentry                  ! File name without path

! SUBROUTINE ARGUMENTS - I/O
TYPE (TError), INTENT(INOUT)                     :: error                      ! Error handling record

! SUBROUTINE ARGUMENTS - OUTPUT
CHARACTER*(*), INTENT(OUT)                       :: filepath                   ! File name including path
!
! CONSTANTS
CHARACTER*512                                    :: ROUTINENAAM                ! 
PARAMETER     (ROUTINENAAM = 'MakeCommonPath')

IF (.NOT. error%haserror) THEN
!
! Create filepath and check whether it exists.
!
  CALL StringMerge(datadir, fileentry, filepath, error)
  IF (error%haserror) GOTO 9999
  IF (.NOT.chkexist(filepath, error)) GOTO 9999
ENDIF

RETURN

9999 CALL ErrorCall(ROUTINENAAM, error)
RETURN
END SUBROUTINE MakeCommonPath

END MODULE m_commonfile
