-- NEED RESULT: ARCH00160.P1: Multi inertial transactions occurred on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160.P2: Multi inertial transactions occurred on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160.P3: Multi inertial transactions occurred on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: One inertial transaction occurred on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: One inertial transaction occurred on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: One inertial transaction occurred on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: Old transactions were removed on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: Old transactions were removed on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: Old transactions were removed on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: One inertial transaction occurred on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: One inertial transaction occurred on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: One inertial transaction occurred on signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: Inertial semantics check on a signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: Inertial semantics check on a signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00160: Inertial semantics check on a signal asg with indexed name prefixed by an indexed name on LHS passed
-- NEED RESULT: P3: Inertial transactions entirely completed passed
-- NEED RESULT: P2: Inertial transactions entirely completed passed
-- NEED RESULT: P1: Inertial transactions entirely completed passed
-------------------------------------------------------------------------------
 --
 --    Copyright (c) 1989 by Intermetrics, Inc.
 --                All rights reserved.
 --
-------------------------------------------------------------------------------
--
-- TEST NAME:
--
--    CT00160
--
-- AUTHOR:
--
--    G. Tominovich
--
-- TEST OBJECTIVES:
--
--    8.3 (1)
--    8.3 (2)
--    8.3 (4)
--    8.3 (5)
--    8.3.1 (4)
--
-- DESIGN UNIT ORDERING:
--
--    ENT00160(ARCH00160)
--    ENT00160_Test_Bench(ARCH00160_Test_Bench)
--
-- REVISION HISTORY:
--
--    08-JUL-1987   - initial revision
--
-- NOTES:
--
--    self-checking
--    automatically generated
--
use WORK.STANDARD_TYPES.all ;
entity ENT00160 is
   port (
        s_st_arr1_vector : inout st_arr1_vector
      ; s_st_arr2_vector : inout st_arr2_vector
      ; s_st_arr3_vector : inout st_arr3_vector
        ) ;
   subtype chk_sig_type is integer range -1 to 100 ;
   signal chk_st_arr1_vector : chk_sig_type := -1 ;
   signal chk_st_arr2_vector : chk_sig_type := -1 ;
   signal chk_st_arr3_vector : chk_sig_type := -1 ;
--
--
   procedure Proc1 (
      signal   s_st_arr1_vector : inout st_arr1_vector ;
      variable counter : inout integer ;
      variable correct : inout boolean ;
      variable savtime : inout time ;
      signal   chk_st_arr1_vector : out chk_sig_type
                   )
   is
   begin
      case counter is
         when 0 =>
            s_st_arr1_vector(lowb) (
              st_arr1'Left) <=
               c_st_arr1_vector_2(highb) (
                 st_arr1'Right) after 10 ns,
               c_st_arr1_vector_1(highb) (
                 st_arr1'Right) after 20 ns ;
--
         when 1 =>
            correct :=
               s_st_arr1_vector(lowb) (
                 st_arr1'Left) =
                  c_st_arr1_vector_2(highb) (
                    st_arr1'Right) and
               (savtime + 10 ns) = Std.Standard.Now ;
--
         when 2 =>
            correct :=
               correct and
               s_st_arr1_vector(lowb) (
                 st_arr1'Left) =
                  c_st_arr1_vector_1(highb) (
                    st_arr1'Right) and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160.P1" ,
              "Multi inertial transactions occurred on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_arr1_vector(lowb) (
              st_arr1'Left) <=
               c_st_arr1_vector_2(highb) (
                 st_arr1'Right) after 10 ns,
               c_st_arr1_vector_1(highb) (
                 st_arr1'Right) after 20 ns,
               c_st_arr1_vector_2(highb) (
                 st_arr1'Right) after 30 ns,
               c_st_arr1_vector_1(highb) (
                 st_arr1'Right) after 40 ns ;
--
         when 3 =>
            correct :=
               s_st_arr1_vector(lowb) (
                 st_arr1'Left) =
                  c_st_arr1_vector_2(highb) (
                    st_arr1'Right) and
               (savtime + 10 ns) = Std.Standard.Now ;
            s_st_arr1_vector(lowb) (
              st_arr1'Left) <=
               c_st_arr1_vector_1(highb) (
                 st_arr1'Right) after 5 ns;
--
         when 4 =>
            correct :=
               correct and
               s_st_arr1_vector(lowb) (
                 st_arr1'Left) =
                  c_st_arr1_vector_1(highb) (
                    st_arr1'Right) and
               (savtime + 5 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "One inertial transaction occurred on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_arr1_vector(lowb) (
              st_arr1'Left) <= transport
               c_st_arr1_vector_1(highb) (
                 st_arr1'Right) after 100 ns;
--
         when 5 =>
            correct :=
               s_st_arr1_vector(lowb) (
                 st_arr1'Left) =
                  c_st_arr1_vector_1(highb) (
                    st_arr1'Right) and
               (savtime + 100 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "Old transactions were removed on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_arr1_vector(lowb) (
              st_arr1'Left) <=
               c_st_arr1_vector_2(highb) (
                 st_arr1'Right) after 10 ns,
               c_st_arr1_vector_1(highb) (
                 st_arr1'Right) after 20 ns,
               c_st_arr1_vector_2(highb) (
                 st_arr1'Right) after 30 ns,
               c_st_arr1_vector_1(highb) (
                 st_arr1'Right) after 40 ns ;
--
         when 6 =>
            correct :=
               s_st_arr1_vector(lowb) (
                 st_arr1'Left) =
                  c_st_arr1_vector_2(highb) (
                    st_arr1'Right) and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "One inertial transaction occurred on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            -- The following will mark last transaction above
            s_st_arr1_vector(lowb) (
              st_arr1'Left) <=
               c_st_arr1_vector_1(highb) (
                 st_arr1'Right) after 40 ns;
--
         when 7 =>
            correct :=
               s_st_arr1_vector(lowb) (
                 st_arr1'Left) =
                  c_st_arr1_vector_1(highb) (
                    st_arr1'Right) and
               (savtime + 30 ns) = Std.Standard.Now ;
--
         when 8 =>
            correct :=
               correct and
               s_st_arr1_vector(lowb) (
                 st_arr1'Left) =
                  c_st_arr1_vector_1(highb) (
                    st_arr1'Right) and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "Inertial semantics check on a signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
--
         when others
         => -- No more transactions should have occurred
            test_report ( "ARCH00160" ,
              "Inertial semantics check on a signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              false ) ;
--
      end case ;
--
      savtime := Std.Standard.Now ;
      chk_st_arr1_vector <= transport counter after (1 us - savtime) ;
      counter := counter + 1;
--
   end Proc1 ;
--
   procedure Proc2 (
      signal   s_st_arr2_vector : inout st_arr2_vector ;
      variable counter : inout integer ;
      variable correct : inout boolean ;
      variable savtime : inout time ;
      signal   chk_st_arr2_vector : out chk_sig_type
                   )
   is
   begin
      case counter is
         when 0 =>
            s_st_arr2_vector(lowb) (
              st_arr2'Left(1),st_arr2'Left(2)) <=
               c_st_arr2_vector_2(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 10 ns,
               c_st_arr2_vector_1(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 20 ns ;
--
         when 1 =>
            correct :=
               s_st_arr2_vector(lowb) (
                 st_arr2'Left(1),st_arr2'Left(2)) =
                  c_st_arr2_vector_2(highb) (
                    st_arr2'Right(1),st_arr2'Right(2)) and
               (savtime + 10 ns) = Std.Standard.Now ;
--
         when 2 =>
            correct :=
               correct and
               s_st_arr2_vector(lowb) (
                 st_arr2'Left(1),st_arr2'Left(2)) =
                  c_st_arr2_vector_1(highb) (
                    st_arr2'Right(1),st_arr2'Right(2)) and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160.P2" ,
              "Multi inertial transactions occurred on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_arr2_vector(lowb) (
              st_arr2'Left(1),st_arr2'Left(2)) <=
               c_st_arr2_vector_2(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 10 ns,
               c_st_arr2_vector_1(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 20 ns,
               c_st_arr2_vector_2(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 30 ns,
               c_st_arr2_vector_1(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 40 ns ;
--
         when 3 =>
            correct :=
               s_st_arr2_vector(lowb) (
                 st_arr2'Left(1),st_arr2'Left(2)) =
                  c_st_arr2_vector_2(highb) (
                    st_arr2'Right(1),st_arr2'Right(2)) and
               (savtime + 10 ns) = Std.Standard.Now ;
            s_st_arr2_vector(lowb) (
              st_arr2'Left(1),st_arr2'Left(2)) <=
               c_st_arr2_vector_1(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 5 ns;
--
         when 4 =>
            correct :=
               correct and
               s_st_arr2_vector(lowb) (
                 st_arr2'Left(1),st_arr2'Left(2)) =
                  c_st_arr2_vector_1(highb) (
                    st_arr2'Right(1),st_arr2'Right(2)) and
               (savtime + 5 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "One inertial transaction occurred on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_arr2_vector(lowb) (
              st_arr2'Left(1),st_arr2'Left(2)) <= transport
               c_st_arr2_vector_1(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 100 ns;
--
         when 5 =>
            correct :=
               s_st_arr2_vector(lowb) (
                 st_arr2'Left(1),st_arr2'Left(2)) =
                  c_st_arr2_vector_1(highb) (
                    st_arr2'Right(1),st_arr2'Right(2)) and
               (savtime + 100 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "Old transactions were removed on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_arr2_vector(lowb) (
              st_arr2'Left(1),st_arr2'Left(2)) <=
               c_st_arr2_vector_2(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 10 ns,
               c_st_arr2_vector_1(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 20 ns,
               c_st_arr2_vector_2(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 30 ns,
               c_st_arr2_vector_1(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 40 ns ;
--
         when 6 =>
            correct :=
               s_st_arr2_vector(lowb) (
                 st_arr2'Left(1),st_arr2'Left(2)) =
                  c_st_arr2_vector_2(highb) (
                    st_arr2'Right(1),st_arr2'Right(2)) and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "One inertial transaction occurred on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            -- The following will mark last transaction above
            s_st_arr2_vector(lowb) (
              st_arr2'Left(1),st_arr2'Left(2)) <=
               c_st_arr2_vector_1(highb) (
                 st_arr2'Right(1),st_arr2'Right(2)) after 40 ns;
--
         when 7 =>
            correct :=
               s_st_arr2_vector(lowb) (
                 st_arr2'Left(1),st_arr2'Left(2)) =
                  c_st_arr2_vector_1(highb) (
                    st_arr2'Right(1),st_arr2'Right(2)) and
               (savtime + 30 ns) = Std.Standard.Now ;
--
         when 8 =>
            correct :=
               correct and
               s_st_arr2_vector(lowb) (
                 st_arr2'Left(1),st_arr2'Left(2)) =
                  c_st_arr2_vector_1(highb) (
                    st_arr2'Right(1),st_arr2'Right(2)) and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "Inertial semantics check on a signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
--
         when others
         => -- No more transactions should have occurred
            test_report ( "ARCH00160" ,
              "Inertial semantics check on a signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              false ) ;
--
      end case ;
--
      savtime := Std.Standard.Now ;
      chk_st_arr2_vector <= transport counter after (1 us - savtime) ;
      counter := counter + 1;
--
   end Proc2 ;
--
   procedure Proc3 (
      signal   s_st_arr3_vector : inout st_arr3_vector ;
      variable counter : inout integer ;
      variable correct : inout boolean ;
      variable savtime : inout time ;
      signal   chk_st_arr3_vector : out chk_sig_type
                   )
   is
   begin
      case counter is
         when 0 =>
            s_st_arr3_vector(lowb) (
              st_arr3'Left(1),st_arr3'Left(2)) <=
               c_st_arr3_vector_2(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 10 ns,
               c_st_arr3_vector_1(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 20 ns ;
--
         when 1 =>
            correct :=
               s_st_arr3_vector(lowb) (
                 st_arr3'Left(1),st_arr3'Left(2)) =
                  c_st_arr3_vector_2(highb) (
                    st_arr3'Right(1),st_arr3'Right(2)) and
               (savtime + 10 ns) = Std.Standard.Now ;
--
         when 2 =>
            correct :=
               correct and
               s_st_arr3_vector(lowb) (
                 st_arr3'Left(1),st_arr3'Left(2)) =
                  c_st_arr3_vector_1(highb) (
                    st_arr3'Right(1),st_arr3'Right(2)) and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160.P3" ,
              "Multi inertial transactions occurred on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_arr3_vector(lowb) (
              st_arr3'Left(1),st_arr3'Left(2)) <=
               c_st_arr3_vector_2(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 10 ns,
               c_st_arr3_vector_1(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 20 ns,
               c_st_arr3_vector_2(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 30 ns,
               c_st_arr3_vector_1(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 40 ns ;
--
         when 3 =>
            correct :=
               s_st_arr3_vector(lowb) (
                 st_arr3'Left(1),st_arr3'Left(2)) =
                  c_st_arr3_vector_2(highb) (
                    st_arr3'Right(1),st_arr3'Right(2)) and
               (savtime + 10 ns) = Std.Standard.Now ;
            s_st_arr3_vector(lowb) (
              st_arr3'Left(1),st_arr3'Left(2)) <=
               c_st_arr3_vector_1(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 5 ns;
--
         when 4 =>
            correct :=
               correct and
               s_st_arr3_vector(lowb) (
                 st_arr3'Left(1),st_arr3'Left(2)) =
                  c_st_arr3_vector_1(highb) (
                    st_arr3'Right(1),st_arr3'Right(2)) and
               (savtime + 5 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "One inertial transaction occurred on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_arr3_vector(lowb) (
              st_arr3'Left(1),st_arr3'Left(2)) <= transport
               c_st_arr3_vector_1(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 100 ns;
--
         when 5 =>
            correct :=
               s_st_arr3_vector(lowb) (
                 st_arr3'Left(1),st_arr3'Left(2)) =
                  c_st_arr3_vector_1(highb) (
                    st_arr3'Right(1),st_arr3'Right(2)) and
               (savtime + 100 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "Old transactions were removed on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_arr3_vector(lowb) (
              st_arr3'Left(1),st_arr3'Left(2)) <=
               c_st_arr3_vector_2(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 10 ns,
               c_st_arr3_vector_1(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 20 ns,
               c_st_arr3_vector_2(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 30 ns,
               c_st_arr3_vector_1(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 40 ns ;
--
         when 6 =>
            correct :=
               s_st_arr3_vector(lowb) (
                 st_arr3'Left(1),st_arr3'Left(2)) =
                  c_st_arr3_vector_2(highb) (
                    st_arr3'Right(1),st_arr3'Right(2)) and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "One inertial transaction occurred on signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
            -- The following will mark last transaction above
            s_st_arr3_vector(lowb) (
              st_arr3'Left(1),st_arr3'Left(2)) <=
               c_st_arr3_vector_1(highb) (
                 st_arr3'Right(1),st_arr3'Right(2)) after 40 ns;
--
         when 7 =>
            correct :=
               s_st_arr3_vector(lowb) (
                 st_arr3'Left(1),st_arr3'Left(2)) =
                  c_st_arr3_vector_1(highb) (
                    st_arr3'Right(1),st_arr3'Right(2)) and
               (savtime + 30 ns) = Std.Standard.Now ;
--
         when 8 =>
            correct :=
               correct and
               s_st_arr3_vector(lowb) (
                 st_arr3'Left(1),st_arr3'Left(2)) =
                  c_st_arr3_vector_1(highb) (
                    st_arr3'Right(1),st_arr3'Right(2)) and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00160" ,
              "Inertial semantics check on a signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              correct ) ;
--
         when others
         => -- No more transactions should have occurred
            test_report ( "ARCH00160" ,
              "Inertial semantics check on a signal " &
              "asg with indexed name prefixed by an indexed name on LHS",
              false ) ;
--
      end case ;
--
      savtime := Std.Standard.Now ;
      chk_st_arr3_vector <= transport counter after (1 us - savtime) ;
      counter := counter + 1;
--
   end Proc3 ;
--
--
end ENT00160 ;
--
architecture ARCH00160 of ENT00160 is
begin
   P1 :
   process
      variable counter : integer := 0 ;
      variable correct : boolean ;
      variable savtime : time ;
   begin
      Proc1 (
          s_st_arr1_vector,
          counter,
          correct,
          savtime,
          chk_st_arr1_vector
         ) ;
      wait until (not s_st_arr1_vector'Quiet) and
                 (savtime /= Std.Standard.Now) ;
--
   end process P1 ;
--
   PGEN_CHKP_1 :
   process ( chk_st_arr1_vector )
   begin
      if Std.Standard.Now > 0 ns then
         test_report ( "P1" ,
           "Inertial transactions entirely completed",
           chk_st_arr1_vector = 8 ) ;
      end if ;
   end process PGEN_CHKP_1 ;
--
--
   P2 :
   process
      variable counter : integer := 0 ;
      variable correct : boolean ;
      variable savtime : time ;
   begin
      Proc2 (
          s_st_arr2_vector,
          counter,
          correct,
          savtime,
          chk_st_arr2_vector
         ) ;
      wait until (not s_st_arr2_vector'Quiet) and
                 (savtime /= Std.Standard.Now) ;
--
   end process P2 ;
--
   PGEN_CHKP_2 :
   process ( chk_st_arr2_vector )
   begin
      if Std.Standard.Now > 0 ns then
         test_report ( "P2" ,
           "Inertial transactions entirely completed",
           chk_st_arr2_vector = 8 ) ;
      end if ;
   end process PGEN_CHKP_2 ;
--
--
   P3 :
   process
      variable counter : integer := 0 ;
      variable correct : boolean ;
      variable savtime : time ;
   begin
      Proc3 (
          s_st_arr3_vector,
          counter,
          correct,
          savtime,
          chk_st_arr3_vector
         ) ;
      wait until (not s_st_arr3_vector'Quiet) and
                 (savtime /= Std.Standard.Now) ;
--
   end process P3 ;
--
   PGEN_CHKP_3 :
   process ( chk_st_arr3_vector )
   begin
      if Std.Standard.Now > 0 ns then
         test_report ( "P3" ,
           "Inertial transactions entirely completed",
           chk_st_arr3_vector = 8 ) ;
      end if ;
   end process PGEN_CHKP_3 ;
--
--
--
end ARCH00160 ;
--
use WORK.STANDARD_TYPES.all ;
entity ENT00160_Test_Bench is
   signal s_st_arr1_vector : st_arr1_vector
     := c_st_arr1_vector_1 ;
   signal s_st_arr2_vector : st_arr2_vector
     := c_st_arr2_vector_1 ;
   signal s_st_arr3_vector : st_arr3_vector
     := c_st_arr3_vector_1 ;
--
end ENT00160_Test_Bench ;
--
architecture ARCH00160_Test_Bench of ENT00160_Test_Bench is
begin
   L1:
   block
      component UUT
         port (
              s_st_arr1_vector : inout st_arr1_vector
            ; s_st_arr2_vector : inout st_arr2_vector
            ; s_st_arr3_vector : inout st_arr3_vector
              ) ;
      end component ;
--
      for CIS1 : UUT use entity WORK.ENT00160 ( ARCH00160 ) ;
   begin
      CIS1 : UUT
         port map (
              s_st_arr1_vector
            , s_st_arr2_vector
            , s_st_arr3_vector
                  ) ;
   end block L1 ;
end ARCH00160_Test_Bench ;
