-- NEED RESULT: ARCH00107.P1: Multi transport transactions occurred on signal asg with selected name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00107.P2: Multi transport transactions occurred on signal asg with selected name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00107.P3: Multi transport transactions occurred on signal asg with selected name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00107: One transport transaction occurred on signal asg with selected name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00107: Old transactions were removed on signal asg with selected name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00107: One transport transaction occurred on signal asg with selected name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00107: Old transactions were removed on signal asg with selected name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00107: One transport transaction occurred on signal asg with selected name prefixed by an indexed name on LHS passed
-- NEED RESULT: ARCH00107: Old transactions were removed on signal asg with selected name prefixed by an indexed name on LHS passed
-- NEED RESULT: P3: Transport transactions entirely completed passed
-- NEED RESULT: P2: Transport transactions entirely completed passed
-- NEED RESULT: P1: Transport transactions entirely completed passed
-------------------------------------------------------------------------------
	--
	--	   Copyright (c) 1989 by Intermetrics, Inc.
	--                All rights reserved.
	--
-------------------------------------------------------------------------------

--
-- TEST NAME:
--
--    CT00107
--
-- AUTHOR:
--
--    G. Tominovich
--
-- TEST OBJECTIVES:
--
--    8.3 (2)
--    8.3 (3)
--    8.3 (5)
--    8.3.1 (3)
--
-- DESIGN UNIT ORDERING:
--
--    E00000(ARCH00107)
--    ENT00107_Test_Bench(ARCH00107_Test_Bench)
--
-- REVISION HISTORY:
--
--    07-JUL-1987   - initial revision
--
-- NOTES:
--
--    self-checking
--    automatically generated
--
use WORK.STANDARD_TYPES.all ;
architecture ARCH00107 of E00000 is
   subtype chk_sig_type is integer range -1 to 100 ;
   signal chk_st_rec1_vector : chk_sig_type := -1 ;
   signal chk_st_rec2_vector : chk_sig_type := -1 ;
   signal chk_st_rec3_vector : chk_sig_type := -1 ;
--
   signal s_st_rec1_vector : st_rec1_vector
     := c_st_rec1_vector_1 ;
   signal s_st_rec2_vector : st_rec2_vector
     := c_st_rec2_vector_1 ;
   signal s_st_rec3_vector : st_rec3_vector
     := c_st_rec3_vector_1 ;
--
begin
   PGEN_CHKP_1 :
   process ( chk_st_rec1_vector )
   begin
      if Std.Standard.Now > 0 ns then
         test_report ( "P1" ,
           "Transport transactions entirely completed",
           chk_st_rec1_vector = 4 ) ;
      end if ;
   end process PGEN_CHKP_1 ;
--
   P1 :
   process ( s_st_rec1_vector )
      variable correct : boolean ;
      variable counter : integer := 0 ;
      variable savtime : time ;
   begin
      case counter is
         when 0
         => s_st_rec1_vector(lowb).f2 <= transport
               c_st_rec1_vector_2(highb).f2 after 10 ns,
               c_st_rec1_vector_1(highb).f2 after 20 ns ;
--
         when 1
         => correct :=
               s_st_rec1_vector(lowb).f2 =
                 c_st_rec1_vector_2(highb).f2 and
               (savtime + 10 ns) = Std.Standard.Now ;
--
         when 2
         => correct :=
               correct and
               s_st_rec1_vector(lowb).f2 =
                 c_st_rec1_vector_1(highb).f2 and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00107.P1" ,
              "Multi transport transactions occurred on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_rec1_vector(lowb).f2 <= transport
               c_st_rec1_vector_2(highb).f2 after 10 ns ,
               c_st_rec1_vector_1(highb).f2 after 20 ns ,
               c_st_rec1_vector_2(highb).f2 after 30 ns ,
               c_st_rec1_vector_1(highb).f2 after 40 ns ;
--
         when 3
         => correct :=
               s_st_rec1_vector(lowb).f2 =
                 c_st_rec1_vector_2(highb).f2 and
               (savtime + 10 ns) = Std.Standard.Now ;
            s_st_rec1_vector(lowb).f2 <= transport
               c_st_rec1_vector_1(highb).f2 after 5 ns ;
--
         when 4
         => correct :=
               correct and
               s_st_rec1_vector(lowb).f2 =
                 c_st_rec1_vector_1(highb).f2 and
               (savtime + 5 ns) = Std.Standard.Now ;
            test_report ( "ARCH00107" ,
              "One transport transaction occurred on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              correct ) ;
            test_report ( "ARCH00107" ,
              "Old transactions were removed on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              correct ) ;
--
         when others
         => -- No more transactions should have occurred
            test_report ( "ARCH00107" ,
              "Old transactions were removed on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              false ) ;
--
      end case ;
--
      savtime := Std.Standard.Now ;
      chk_st_rec1_vector <= transport counter after (1 us - savtime) ;
      counter := counter + 1;
--
   end process P1 ;
--
   PGEN_CHKP_2 :
   process ( chk_st_rec2_vector )
   begin
      if Std.Standard.Now > 0 ns then
         test_report ( "P2" ,
           "Transport transactions entirely completed",
           chk_st_rec2_vector = 4 ) ;
      end if ;
   end process PGEN_CHKP_2 ;
--
   P2 :
   process ( s_st_rec2_vector )
      variable correct : boolean ;
      variable counter : integer := 0 ;
      variable savtime : time ;
   begin
      case counter is
         when 0
         => s_st_rec2_vector(lowb).f2 <= transport
               c_st_rec2_vector_2(highb).f2 after 10 ns,
               c_st_rec2_vector_1(highb).f2 after 20 ns ;
--
         when 1
         => correct :=
               s_st_rec2_vector(lowb).f2 =
                 c_st_rec2_vector_2(highb).f2 and
               (savtime + 10 ns) = Std.Standard.Now ;
--
         when 2
         => correct :=
               correct and
               s_st_rec2_vector(lowb).f2 =
                 c_st_rec2_vector_1(highb).f2 and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00107.P2" ,
              "Multi transport transactions occurred on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_rec2_vector(lowb).f2 <= transport
               c_st_rec2_vector_2(highb).f2 after 10 ns ,
               c_st_rec2_vector_1(highb).f2 after 20 ns ,
               c_st_rec2_vector_2(highb).f2 after 30 ns ,
               c_st_rec2_vector_1(highb).f2 after 40 ns ;
--
         when 3
         => correct :=
               s_st_rec2_vector(lowb).f2 =
                 c_st_rec2_vector_2(highb).f2 and
               (savtime + 10 ns) = Std.Standard.Now ;
            s_st_rec2_vector(lowb).f2 <= transport
               c_st_rec2_vector_1(highb).f2 after 5 ns ;
--
         when 4
         => correct :=
               correct and
               s_st_rec2_vector(lowb).f2 =
                 c_st_rec2_vector_1(highb).f2 and
               (savtime + 5 ns) = Std.Standard.Now ;
            test_report ( "ARCH00107" ,
              "One transport transaction occurred on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              correct ) ;
            test_report ( "ARCH00107" ,
              "Old transactions were removed on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              correct ) ;
--
         when others
         => -- No more transactions should have occurred
            test_report ( "ARCH00107" ,
              "Old transactions were removed on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              false ) ;
--
      end case ;
--
      savtime := Std.Standard.Now ;
      chk_st_rec2_vector <= transport counter after (1 us - savtime) ;
      counter := counter + 1;
--
   end process P2 ;
--
   PGEN_CHKP_3 :
   process ( chk_st_rec3_vector )
   begin
      if Std.Standard.Now > 0 ns then
         test_report ( "P3" ,
           "Transport transactions entirely completed",
           chk_st_rec3_vector = 4 ) ;
      end if ;
   end process PGEN_CHKP_3 ;
--
   P3 :
   process ( s_st_rec3_vector )
      variable correct : boolean ;
      variable counter : integer := 0 ;
      variable savtime : time ;
   begin
      case counter is
         when 0
         => s_st_rec3_vector(lowb).f2 <= transport
               c_st_rec3_vector_2(highb).f2 after 10 ns,
               c_st_rec3_vector_1(highb).f2 after 20 ns ;
--
         when 1
         => correct :=
               s_st_rec3_vector(lowb).f2 =
                 c_st_rec3_vector_2(highb).f2 and
               (savtime + 10 ns) = Std.Standard.Now ;
--
         when 2
         => correct :=
               correct and
               s_st_rec3_vector(lowb).f2 =
                 c_st_rec3_vector_1(highb).f2 and
               (savtime + 10 ns) = Std.Standard.Now ;
            test_report ( "ARCH00107.P3" ,
              "Multi transport transactions occurred on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              correct ) ;
            s_st_rec3_vector(lowb).f2 <= transport
               c_st_rec3_vector_2(highb).f2 after 10 ns ,
               c_st_rec3_vector_1(highb).f2 after 20 ns ,
               c_st_rec3_vector_2(highb).f2 after 30 ns ,
               c_st_rec3_vector_1(highb).f2 after 40 ns ;
--
         when 3
         => correct :=
               s_st_rec3_vector(lowb).f2 =
                 c_st_rec3_vector_2(highb).f2 and
               (savtime + 10 ns) = Std.Standard.Now ;
            s_st_rec3_vector(lowb).f2 <= transport
               c_st_rec3_vector_1(highb).f2 after 5 ns ;
--
         when 4
         => correct :=
               correct and
               s_st_rec3_vector(lowb).f2 =
                 c_st_rec3_vector_1(highb).f2 and
               (savtime + 5 ns) = Std.Standard.Now ;
            test_report ( "ARCH00107" ,
              "One transport transaction occurred on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              correct ) ;
            test_report ( "ARCH00107" ,
              "Old transactions were removed on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              correct ) ;
--
         when others
         => -- No more transactions should have occurred
            test_report ( "ARCH00107" ,
              "Old transactions were removed on signal " &
              "asg with selected name prefixed by an indexed name on LHS",
              false ) ;
--
      end case ;
--
      savtime := Std.Standard.Now ;
      chk_st_rec3_vector <= transport counter after (1 us - savtime) ;
      counter := counter + 1;
--
   end process P3 ;
--
--
end ARCH00107 ;
--
entity ENT00107_Test_Bench is
end ENT00107_Test_Bench ;
--
architecture ARCH00107_Test_Bench of ENT00107_Test_Bench is
begin
   L1:
   block
      component UUT
      end component ;
      for CIS1 : UUT use entity WORK.E00000 ( ARCH00107 ) ;
   begin
      CIS1 : UUT ;
   end block L1 ;
end ARCH00107_Test_Bench ;
