! ##################################################################################################################################
 
      SUBROUTINE CALC_ELEM_NODE_FORCES
 
! Calculates elem nodal forces in local elem coord system for one elem and one subcase for all element types.
 
      USE PENTIUM_II_KIND, ONLY       :  BYTE, LONG, DOUBLE
      USE IOUNT1, ONLY                :  WRT_BUG, WRT_ERR, WRT_LOG, ERR, F04, F06
      USE SCONTR, ONLY                :  BLNK_SUB_NAM, NGRID, JTSUB, JTSUB_OLD, WARN_ERR
      USE TIMDAT, ONLY                :  TSEC
      USE SUBR_BEGEND_LEVELS, ONLY    :  CALC_ELEM_NODE_FORCES_BEGEND
      USE CONSTANTS_1, ONLY           :  ZERO
      USE MODEL_STUF, ONLY            :  AGRID, ELAS_COMP, ELDOF, KE, PEL, PTE, UEL, TYPE, SUBLOD
 
      USE CALC_ELEM_NODE_FORCES_USE_IFs

      IMPLICIT NONE
 
      CHARACTER(LEN=LEN(BLNK_SUB_NAM)):: SUBR_NAME = 'CALC_ELEM_NODE_FORCES'
 
      INTEGER(LONG)                   :: I,J               ! DO loop indices
      INTEGER(LONG)                   :: I1,I2             ! Calculated displ component no's for ELAS elems
      INTEGER(LONG)                   :: NCOLS             ! Number of rows in element stiffness matrix
      INTEGER(LONG)                   :: NROWS             ! Number of cols in element stiffness matrix
      INTEGER(LONG)                   :: NUM_COMPS_GRID_1  ! No. displ components for 1st grid on ELAS elems
      INTEGER(LONG), PARAMETER        :: SUBR_BEGEND = CALC_ELEM_NODE_FORCES_BEGEND
 
! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9001) SUBR_NAME,TSEC
 9001    FORMAT(1X,A,' BEGN ',F10.3)
      ENDIF

! **********************************************************************************************************************************
      NROWS = ELDOF
      NCOLS = ELDOF
 
      DO I=1,NCOLS
         PEL(I) = ZERO
      ENDDO 
 
! **********************************************************************************************************************************
! Calc forces for one element. The ELAS and ROD1 elem have very sparse stiffness matrices, so an explicit form is used
! for them. All other element forces are calculated by multiplication of complete stiffness matrix with the displ's.
 
      IF (TYPE(1:4) == 'ELAS') THEN                        ! Calculate forces for ELAS1-4 elems
 
         I1 = ELAS_COMP(1)
         CALL GET_GRID_NUM_COMPS ( AGRID(1), NUM_COMPS_GRID_1, SUBR_NAME )
         I2 = NUM_COMPS_GRID_1 + ELAS_COMP(2)
         PEL(I1) = KE(I1,I1)*UEL(I1) + KE(I1,I2)*UEL(I2)   ! Note: KE is global and local for the ELAS elems
         PEL(I2) = KE(I2,I1)*UEL(I1) + KE(I2,I2)*UEL(I2)
 
      ELSE IF (TYPE == 'ROD     ') THEN                    ! Calculate forces for ROD1 elem
 
         IF (JTSUB > JTSUB_OLD) THEN
            PEL(1) = -PTE(1,JTSUB)
            PEL(7) = -PTE(7,JTSUB)
         ENDIF

         PEL( 1) = PEL(1) + KE( 1, 1)*UEL( 1) + KE( 1, 7)*UEL( 7)
         PEL( 4) =          KE( 4, 4)*UEL( 4) + KE( 4,10)*UEL(10)
         PEL( 7) = PEL(7) + KE( 7, 1)*UEL( 1) + KE( 7, 7)*UEL( 7)
         PEL(10) =          KE(10, 4)*UEL( 4) + KE(10,10)*UEL(10)
 
      ELSE IF (TYPE == 'USERIN  ') THEN

         WRITE(F06,9991) TYPE

      ELSE                                                 ! Calculate forces for any other type of elem
 
         DO I=1,NROWS
 
            IF (JTSUB > JTSUB_OLD) THEN
               PEL(I) = -PTE(I,JTSUB)
            ENDIF
 
            DO J=1,NCOLS
               PEL(I) = PEL(I) + KE(I,J)*UEL(J)
            ENDDO
         ENDDO
 
      ENDIF

! **********************************************************************************************************************************
      IF (WRT_LOG >= SUBR_BEGEND) THEN
         CALL OURTIM
         WRITE(F04,9002) SUBR_NAME,TSEC
 9002    FORMAT(1X,A,' END  ',F10.3)
      ENDIF

      RETURN

! **********************************************************************************************************************************
 9991 FORMAT(' *INFORMATION: ELEMENT NODE FORCE CALCULATION NOT PROGRAMMED FOR ',A,' ELEMENTS')

! **********************************************************************************************************************************

      END SUBROUTINE CALC_ELEM_NODE_FORCES
