VSim
====

VSim is a VHDL simulator project aimed at developing methods of compiling VHDL code
into a high-level language (Haskell). Currently it is able to compile simple
VHDL programs, containing plain integer types, 1-dimentional arrays, records. It
supports processes, procedures, functions (partly). Breakpoints and wait
statements should work.

Simulator compiles VHDL into Haskell in several steps.

Firstly, VHDL is translated into VIR-file by a translator written in Java (see
tr/ folder and runtr function in ./simenv shell script). VIR file is a lisp-like
file, describing vhdl entities in a less complex manner. It contains all the
port maps expanded, and concurrent signal assignments replaced with
corresponding processes.

Secondly, the VSim tool is used to translate VIR into Haskell (see src/ 
folder and runsim functino in ./simenv). VSim is a small program which translates VIR
line-by-line into a Haskell program. haskell-src-exts is used to build the AST
and print it to stdout.

Finaly, the Haskell program should be compiled into binary with ghc with runtime
library included (refer to src\_r/ folder and runsim function in ./simenv).
The runtime is the heart of the simulator and is its largest part.

The Java poption of code is our main headache, because it is big, unsupported and has bugs
lurking here and there. The Haskell part is smaller and cleaner, but VHDL-standard
coverage is very poor. For example, signal assignments are working as if they
are declared with transport delay mechanism. Another problem is missing enum
support except of several pre-defined types like Char or Boolean.

Installing
----------

1. Install recent 'Haskell Platform' bundle

2. Unpack the sources into work dir

3. CD to work dir

4. Build java translator

	$ cd tr ; make clean all

5. Install compiler build tools

    $ cabal install happy alex

6. Generate lexer and parser

    $ alex src/Vir/VIR/Lexer.x

    $ happy src/Vir/VIR/AST.y

7. Build the sources

    $ cabal configure

    $ cabal build

Also consult ./build-minimal.sh

Running
-------

To run an example (say, vhdl/assign4.vhd), one has to do the following:

1. Setup bash environment

    $ . simenv

2. Run the VHDL-to-VIR translator, combined with VIR-to-Haskell code generator

    $ vsim vhdl/assign4.vhd > src_r/Test/Autogen.hs

3. Build the model (run GHC interactive console)

    $ cd src_r ; ghci Test/Autogen.hs

4. Run the model from the console

    *Main> :main

Design notes
------------

* Java part is buggy and works better on Windows (cygwin)

* ./simenv is a bash function lib able to run all the stuff here.
  ./revtest is an automatic testing tool

* Every VHDL value represented

    data Value t x = Value String t x
        deriving(Show)

  where t is a type and x is a (IORef r) where r is some structure representing
  values of type t. For Integers it is Int, for arrays it is (ArrayR Int [x])

* The simulation is carried out by VSim monad which tracks running and breaking
  in breakpoints. Breakpoint placement is semi-automatical. You should
  manually place 'breakpoint' function in a Haskell program before compiling it

* VHDL processes and procedures are VProc (which contains VSim). VProc can pause
  execution in wait statements and do C-style returns.

* Elaboration is performed in Elab monad which is cabable of changing simulator
  internal state (mis)named Memory.

* Main simulation routine is in src\_r/Vsim/Runtime/Timewheel.hs. timewheel
  function returns the time of next event plus set of processes to kick. It is
  very inefficient since it scans every signal in the model in order to get it's
  time of activation. Suprisingly, this approach is the best I were able to
  implement (I've tried to sort global signal list and parallelisation)

* Signal assignments work as if they were declared as 'transport' (BUG)

Webserver
---------

Webserver located in happstack/ folder and was used to track progress in test
coverage. Tests can be run using ./revtest script. It takes git revision as
an argument (HEAD by default) and produces a record in test database directory
(see DB var in ./revtest).

To run it on Windows as a service:

	$ cygwin ~/proj/vsim $ cygrunsrv.exe -I websim \
		--path `pwd`/happstack/WebServer.exe -c `pwd` --args . -i
	$ cygwin ~/proj/vsim $ cygrunsrv.exe -S websim

On Linux just make a cronjob or alike

Example
-------

Here is a simple VHDL program

    entity test is
    end entity test;

    entity unit is
        port (
           inum : in integer;
           oled : out integer);
    end entity unit;

    architecture unit_a of unit is
        subtype  oneten is integer range 1 to 10 ;
        signal a : oneten := 1;
    begin
        oled <= inum + a;
    end architecture unit_a;


    architecture test_arch of test is
        subtype  onetwo is integer range 1 to 2 ;
        constant CYCLES : integer := 100;
        signal clk : integer := 0;
        signal i : integer := 0;
        signal o1,o2 : integer;
    begin

        terminator : process(clk)
        begin
            if clk >= CYCLES then
                assert false report "end of simulation" severity failure;
            -- else
            -- 	report "tick";
            end if;
        end process;

        u1:entity unit(unit_a) port map(inum=>i, oled=>o1);
        u2:entity unit(unit_a) port map(inum=>i, oled=>o2);

        clk <= clk + 1 after 1 us;

    end architecture test_arch;

It should be translated into equivalent Haskell code. Note, that Haskell code
has bits of standard VHDL library included.

    {-# LANGUAGE RecursiveDo #-}
    module Main where
    import VSim.Runtime

    elab :: Elab IO ()
    elab
      = mdo
           cycles_test <- (alloc_constant integer_standard_std
                             (assign (int 100)))
           onetwo_test <- alloc_subtype (alloc_range (int 1) (int 2))
                            integer_standard_std
           oneten_u1_test <- alloc_subtype (alloc_range (int 1) (int 10))
                               integer_standard_std
           oneten_u2_test <- alloc_subtype (alloc_range (int 1) (int 10))
                               integer_standard_std
           (severity_level_standard_std,
            [note, warning, error, failure]) <- alloc_enum_type 4
           (boolean_standard_std, [false, true]) <- alloc_enum_type 2
           integer_standard_std <- alloc_ranged_type
                                     (alloc_range (int (-2147483648)) (int 2147483647))
           clk_test <- alloc_signal "clk_test" integer_standard_std
                         (assign (int 0))
           i_test <- alloc_signal "i_test" integer_standard_std
                       (assign (int 0))
           o1_test <- alloc_signal "o1_test" integer_standard_std defval
           o2_test <- alloc_signal "o2_test" integer_standard_std defval
           terminator_test <- alloc_process_let "terminator_test" [clk_test]
                                (do return
                                      (do iF (greater_eq (pure clk_test) (pure cycles_test)) (do assert)
                                            (do return ())
                                          return ()))
           inum_u1_test <- alloc_port "inum_u1_test" integer_standard_std
                             (assign (pure i_test))
           oled_u1_test <- alloc_port "oled_u1_test" integer_standard_std
                             (assign (pure o1_test))
           a_u1_test <- alloc_signal "a_u1_test" oneten_u1_test
                          (assign (int 1))
           autoprocess_u1_test <- alloc_process_let "autoprocess_u1_test"
                                    [inum_u1_test, a_u1_test]
                                    (do return
                                          (do (.<=.) (pure oled_u1_test)
                                                (next,
                                                 (assign (add (pure inum_u1_test) (pure a_u1_test))))
                                              return ()))
           inum_u2_test <- alloc_port "inum_u2_test" integer_standard_std
                             (assign (pure i_test))
           oled_u2_test <- alloc_port "oled_u2_test" integer_standard_std
                             (assign (pure o2_test))
           a_u2_test <- alloc_signal "a_u2_test" oneten_u2_test
                          (assign (int 1))
           autoprocess0_u2_test <- alloc_process_let "autoprocess0_u2_test"
                                     [inum_u2_test, a_u2_test]
                                     (do return
                                           (do (.<=.) (pure oled_u2_test)
                                                 (next,
                                                  (assign (add (pure inum_u2_test) (pure a_u2_test))))
                                               return ()))
           autoprocess1_test <- alloc_process_let "autoprocess1_test"
                                  [clk_test]
                                  (do return
                                        (do (.<=.) (pure clk_test)
                                              ((us 1), (assign (add (pure clk_test) (int 1))))
                                            return ()))
           return ()
    main = do sim maxBound elab

Further development
-------------------

VSim was developed as a part of VHDL project carried out by Prosoft company.
Unfortunately, I can't support the code any more. I hope it still can be used as
an inspiration for someone.

Tasks:

* get rid of java-part. One have to write VHDL parser outputting VHDL AST. File
  ./grammar/vhdl-grammar containes more or less formalized grammar, manually
  extracted from VHDL2008\_Standard.pdf

* Better track type information. Currently, VIR-files don't provide such info
  for constants. It prevented me from implementing enum support

* Work out {#- RecursiveDo #-} problem. RecursiveDo is a hack which makes
  recursive calls possible. Unfortunately, GHC can't compile it in some cases.

* VHDL allows pure functions to be used as an initializers. Vsim requires
  functions to live in (VProc VSim IO) monad which is not ready on elaboration
  phaze. Thus, pure functions are not supported. Probably, one should redesign
  monad stack.

Author
------

Sergey Mironov (except Java part)
ierton@gmail.com

