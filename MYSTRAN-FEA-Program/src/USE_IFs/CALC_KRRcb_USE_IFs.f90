      MODULE CALC_KRRcb_USE_IFs

! USE Interface statements for all subroutines called by SUBROUTINE CALC_KRRcb

      USE OURTIM_Interface
      USE ALLOCATE_SCR_CCS_MAT_Interface
      USE SPARSE_CRS_SPARSE_CCS_Interface
      USE MATMULT_SSS_NTERM_Interface
      USE ALLOCATE_SCR_CRS_MAT_Interface
      USE MATMULT_SSS_Interface
      USE DEALLOCATE_SCR_MAT_Interface
      USE SPARSE_CRS_TERM_COUNT_Interface
      USE CRS_NONSYM_TO_CRS_SYM_Interface
      USE OUTA_HERE_Interface
      USE MATADD_SSS_NTERM_Interface
      USE ALLOCATE_SPARSE_MAT_Interface
      USE MATADD_SSS_Interface
      USE DEALLOCATE_LAPACK_MAT_Interface
      USE SYM_MAT_DECOMP_LAPACK_Interface
      USE SYM_MAT_DECOMP_IntMKL_Interface
      USE SPARSE_MAT_DIAG_ZEROS_Interface

      END MODULE CALC_KRRcb_USE_IFs
