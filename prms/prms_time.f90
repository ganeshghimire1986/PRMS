!***********************************************************************
! Sets PRMS time variables
!***********************************************************************
      MODULE PRMS_SET_TIME
      USE PRMS_MODULE, ONLY: YEAR, MONTH, DAY, HOUR, MINUTE
      IMPLICIT NONE
!   Local Variables
      character(len=*), parameter :: MODDESC = 'Timestep Control'
      character(len=*), parameter :: MODNAME = 'prms_time'
      character(len=*), parameter :: Version_prms_time = '2020-07-01'
      INTEGER, SAVE :: Modays(12), Yrdays, Summer_flag, Jday, Jsol, Julwater, Julian_day_absolute
      INTEGER, SAVE :: Nowtime(6), Nowday, Nowmonth, Nowyear, Nowhour, Nowminute
      REAL, SAVE :: Timestep_hours, Timestep_days, Timestep_minutes
      DOUBLE PRECISION, SAVE :: Cfs2inches, Cfs_conv, Timestep_seconds
      END MODULE PRMS_SET_TIME

!***********************************************************************
!***********************************************************************
      INTEGER FUNCTION prms_time()
      USE PRMS_SET_TIME
      USE PRMS_MODULE, ONLY: Process, Timestep, Starttime, SECS_PER_DAY, SECS_PER_HOUR, FT2_PER_ACRE, ERROR_time
      USE PRMS_BASIN, ONLY: Hemisphere, Basin_area_inv
      IMPLICIT NONE
! Functions
      INTRINSIC SNGL
      INTEGER, EXTERNAL :: leap_day, julian_day, compute_julday
      DOUBLE PRECISION, EXTERNAL :: deltim
      EXTERNAL :: dattim, print_module
! Local Variables
      INTEGER :: startday
      DOUBLE PRECISION :: dt
!***********************************************************************
      prms_time = 0

      IF ( Process(:3)=='run' .OR. Process(:4)=='init' ) THEN

        IF ( Process(:3)=='run' ) THEN
          Timestep = Timestep + 1

          CALL dattim('now', Nowtime)
          Jday = julian_day('now', 'calendar')
          Jsol = julian_day('now', 'solar')
          Julwater = julian_day('now', 'water')
          Julian_day_absolute = Julian_day_absolute + 1

        ELSE ! initialize
          Modays(1) = 31
          Modays(3) = 31
          Modays(4) = 30
          Modays(5) = 31
          Modays(6) = 30
          Modays(7) = 31
          Modays(8) = 31
          Modays(9) = 30
          Modays(10) = 31
          Modays(11) = 30
          Modays(12) = 31

          Nowtime = Starttime
          Jday = julian_day('start', 'calendar')
          Jsol = julian_day('start', 'solar')
          Julwater = julian_day('start', 'water')
          startday = compute_julday(Starttime(1), Starttime(2), Starttime(3))
          Julian_day_absolute = startday
        ENDIF

        Nowyear = Nowtime(YEAR)
        Nowmonth = Nowtime(MONTH)
        Nowday = Nowtime(DAY)
        Nowhour = Nowtime(HOUR)
        Nowminute = Nowtime(MINUTE)

        IF ( leap_day(Nowyear)==1 ) THEN
          Yrdays = 366
          Modays(2) = 29
        ELSE
          Yrdays = 365
          Modays(2) = 28
        ENDIF

        ! Summer is based on equinox:
        !   Julian days 79 to 265 for Northern hemisphere
        !   Julian day 265 to 79 in Southern hemisphere
        Summer_flag = 1 ! 1 = summer, 0 = winter
        IF ( Hemisphere==0 ) THEN ! Northern Hemisphere
          IF ( Jday<79 .OR. Jday>265 ) Summer_flag = 0 ! Equinox
        ELSE ! Southern Hemisphere
          IF ( Jday>79 .AND. Jday<265 ) Summer_flag = 0 ! Equinox
        ENDIF

        dt = deltim()
        Timestep_hours = SNGL( dt )
        Timestep_days = Timestep_hours/24.0
        Timestep_minutes = Timestep_hours*60.0
        Timestep_seconds = dt*SECS_PER_HOUR
        Cfs_conv = FT2_PER_ACRE/12.0D0/Timestep_seconds
        Cfs2inches = Basin_area_inv*12.0D0*Timestep_seconds/FT2_PER_ACRE

        ! Check to see if in a daily or subdaily time step
        IF ( Timestep_hours>24.0 ) THEN
          PRINT *, 'ERROR, timestep > daily, fix Data File, timestep:', Timestep_hours
          ERROR STOP ERROR_time
        ELSEIF ( Timestep_hours<24.0 ) THEN
          PRINT *, 'ERROR, timestep < daily for daily model, fix Data File', Timestep_hours
          ERROR STOP ERROR_time
        ENDIF

      ELSEIF ( Process(:4)=='decl' ) THEN
        CALL print_module(MODDESC, MODNAME, Version_prms_time)
        Timestep_seconds = SECS_PER_DAY
        Cfs_conv = FT2_PER_ACRE/12.0D0/Timestep_seconds
        Cfs2inches = Basin_area_inv*12.0D0*Timestep_seconds/FT2_PER_ACRE
      ENDIF

      END FUNCTION prms_time
