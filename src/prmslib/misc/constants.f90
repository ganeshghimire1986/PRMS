module prms_constants
    use variableKind

    implicit none

    ! see discussion at: https://software.intel.com/en-us/forums/intel-visual-fortran-compiler-for-windows/topic/285082
    integer, parameter :: sp = selected_real_kind(6, 37)
      !! Define real precision and range
    integer, parameter :: dp = selected_real_kind(15, 300)
      !! Define double precision and range

    ! from prms6.f90
    integer(i32), parameter :: MAXFILE_LENGTH = 256
    character(LEN=*), parameter :: EQULS = '===================================================================='
    character(len=*), parameter :: DIM_HEADER = '** Dimensions **'
    character(len=*), parameter :: PARAM_HEADER = '** Parameters **'
    character(len=*), parameter :: ENTRY_DELIMITER = '####'

    real(r64), parameter :: SECS_PER_DAY = 86400_dp
    real(r64), parameter :: SECS_PER_HOUR = 3600_dp
    real(r32), parameter :: MIN_PER_HOUR = 60_sp
    real(r32), parameter :: HOUR_PER_DAY = 24_sp

    real(r32), parameter :: NEARZERO = EPSILON(0.0)
    real(r64), parameter :: DNEARZERO = EPSILON(0.0_dp)

    real(r64), parameter :: FT2_PER_ACRE = 43560.0_dp
    real(r64), parameter :: CFS2CMS_CONV = 0.028316847_dp

    real(r32), parameter :: INCH2MM = 25.4_sp
    real(r32), parameter :: INCH2M = 0.0254_sp

    ! TODO: what units are MAXTEMP and MINTEMP?
    real(r32), parameter :: MAXTEMP = 200.0
    real(r32), parameter :: MINTEMP = -150.0

    real(r32), parameter :: MM2INCH = 1.0 / INCH2MM

    real(r32), parameter :: FEET2METERS = 0.3048
    real(r32), parameter :: METERS2FEET = 1.0 / FEET2METERS

    ! Frequency values
    ! Used for basinOut_freq, nhruOut_freq, and nsubOut_freq
    integer(i32), parameter :: DAILY = 1
    integer(i32), parameter :: MONTHLY = 2
    integer(i32), parameter :: DAILY_MONTHLY = 3
    integer(i32), parameter :: MEAN_MONTHLY = 4
    integer(i32), parameter :: MEAN_YEARLY = 5
    integer(i32), parameter :: YEARLY = 6

    ! Model modes
    enum, bind(C)
      enumerator :: GSFLOW=0, PRMS=1, WRITE_CLIMATE=4, CLIMATE=6, POTET=7, &
                    TRANSPIRE=8, FROST=9, CONVERT=10, DOCUMENTATION=99
    end enum

    ! Hemisphere constants
    enum, bind(C)
      enumerator :: NORTHERN, SOUTHERN
    end enum

    ! Date time index constants
    enum, bind(c)
      enumerator :: YEAR=1, MONTH=2, DAY=3, HOUR=4, MINUTE=5, SECOND=6
    end enum

    ! Temperature units
    enum, bind(C)
      enumerator :: FAHRENHEIT, CELSIUS
    end enum

    ! Precipitation units
    enum, bind(C)
      enumerator :: INCHES, MM
    end enum

    ! Elevation units
    enum, bind(C)
      enumerator :: FEET=0, METERS=1
    end enum

    ! hru_type
    enum, bind(C)
      enumerator :: INACTIVE=0, LAND=1, LAKE=2, SWALE=3
    end enum
end module prms_constants
