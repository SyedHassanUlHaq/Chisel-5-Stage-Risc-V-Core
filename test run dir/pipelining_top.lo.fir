circuit pipelining_top :
  module pC :
    input clock : Clock
    input reset : UInt<1>
    input io_in : SInt<32>
    output io_out : SInt<32>
    output io_pc4 : SInt<32>

    reg pc : SInt<32>, clock with :
      reset => (UInt<1>("h0"), pc) @[PC.scala 12:21]
    node _io_pc4_T = add(pc, asSInt(UInt<4>("h4"))) @[PC.scala 15:18]
    node _io_pc4_T_1 = tail(_io_pc4_T, 1) @[PC.scala 15:18]
    node _io_pc4_T_2 = asSInt(_io_pc4_T_1) @[PC.scala 15:18]
    io_out <= pc @[PC.scala 14:12]
    io_pc4 <= _io_pc4_T_2 @[PC.scala 15:12]
    pc <= mux(reset, asSInt(UInt<32>("h0")), io_in) @[PC.scala 12:21 PC.scala 12:21 PC.scala 13:8]

  module instrMem :
    input clock : Clock
    input reset : UInt<1>
    output io_instr : UInt<32>
    input io_addr : UInt<32>

    mem mem : @[InstrMem.scala 12:18]
      data-type => UInt<32>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => io_instr_MPORT
      read-under-write => undefined
    node _io_instr_T = bits(io_addr, 9, 0) @[InstrMem.scala 14:25]
    io_instr <= mem.io_instr_MPORT.data @[InstrMem.scala 14:14]
    mem.io_instr_MPORT.addr <= _io_instr_T @[InstrMem.scala 14:25]
    mem.io_instr_MPORT.en <= UInt<1>("h1") @[InstrMem.scala 14:25]
    mem.io_instr_MPORT.clk <= clock @[InstrMem.scala 14:25]

  module frwdUnit :
    input clock : Clock
    input reset : UInt<1>
    input io_exMem_reg_write : UInt<1>
    input io_memWb_reg_write : UInt<1>
    input io_mem_wb_rdAddr : UInt<5>
    input io_ex_mem_rdAddr : UInt<5>
    input io_id_ex_rs1Addr : UInt<5>
    input io_id_ex_rs2Addr : UInt<5>
    output io_frwdA : UInt<2>
    output io_frwdB : UInt<2>

    node _T = eq(io_exMem_reg_write, UInt<1>("h1")) @[ForwardingUnit.scala 21:29]
    node _T_1 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[ForwardingUnit.scala 21:60]
    node _T_2 = and(_T, _T_1) @[ForwardingUnit.scala 21:40]
    node _T_3 = eq(io_ex_mem_rdAddr, io_id_ex_rs1Addr) @[ForwardingUnit.scala 21:96]
    node _T_4 = and(_T_2, _T_3) @[ForwardingUnit.scala 21:75]
    node _T_5 = eq(io_ex_mem_rdAddr, io_id_ex_rs2Addr) @[ForwardingUnit.scala 21:139]
    node _T_6 = and(_T_4, _T_5) @[ForwardingUnit.scala 21:118]
    node _T_7 = eq(io_exMem_reg_write, UInt<1>("h1")) @[ForwardingUnit.scala 24:35]
    node _T_8 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[ForwardingUnit.scala 24:66]
    node _T_9 = and(_T_7, _T_8) @[ForwardingUnit.scala 24:46]
    node _T_10 = eq(io_ex_mem_rdAddr, io_id_ex_rs2Addr) @[ForwardingUnit.scala 24:102]
    node _T_11 = and(_T_9, _T_10) @[ForwardingUnit.scala 24:81]
    node _T_12 = eq(io_exMem_reg_write, UInt<1>("h1")) @[ForwardingUnit.scala 26:35]
    node _T_13 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[ForwardingUnit.scala 26:66]
    node _T_14 = and(_T_12, _T_13) @[ForwardingUnit.scala 26:46]
    node _T_15 = eq(io_ex_mem_rdAddr, io_id_ex_rs1Addr) @[ForwardingUnit.scala 26:102]
    node _T_16 = and(_T_14, _T_15) @[ForwardingUnit.scala 26:81]
    node _GEN_0 = mux(_T_16, UInt<1>("h1"), UInt<1>("h0")) @[ForwardingUnit.scala 26:124 ForwardingUnit.scala 27:26 ForwardingUnit.scala 17:14]
    node _GEN_1 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[ForwardingUnit.scala 24:124 ForwardingUnit.scala 25:26 ForwardingUnit.scala 18:14]
    node _GEN_2 = mux(_T_11, UInt<1>("h0"), _GEN_0) @[ForwardingUnit.scala 24:124 ForwardingUnit.scala 17:14]
    node _GEN_3 = mux(_T_6, UInt<1>("h1"), _GEN_2) @[ForwardingUnit.scala 21:161 ForwardingUnit.scala 22:18]
    node _GEN_4 = mux(_T_6, UInt<1>("h1"), _GEN_1) @[ForwardingUnit.scala 21:161 ForwardingUnit.scala 23:26]
    node _T_17 = eq(io_memWb_reg_write, UInt<1>("h1")) @[ForwardingUnit.scala 31:29]
    node _T_18 = neq(io_mem_wb_rdAddr, UInt<1>("h0")) @[ForwardingUnit.scala 31:60]
    node _T_19 = and(_T_17, _T_18) @[ForwardingUnit.scala 31:40]
    node _T_20 = eq(io_exMem_reg_write, UInt<1>("h1")) @[ForwardingUnit.scala 31:100]
    node _T_21 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[ForwardingUnit.scala 31:133]
    node _T_22 = and(_T_20, _T_21) @[ForwardingUnit.scala 31:112]
    node _T_23 = eq(io_ex_mem_rdAddr, io_id_ex_rs1Addr) @[ForwardingUnit.scala 31:170]
    node _T_24 = and(_T_22, _T_23) @[ForwardingUnit.scala 31:149]
    node _T_25 = eq(io_ex_mem_rdAddr, io_id_ex_rs2Addr) @[ForwardingUnit.scala 31:213]
    node _T_26 = and(_T_24, _T_25) @[ForwardingUnit.scala 31:192]
    node _T_27 = not(_T_26) @[ForwardingUnit.scala 31:78]
    node _T_28 = and(_T_19, _T_27) @[ForwardingUnit.scala 31:75]
    node _T_29 = eq(io_mem_wb_rdAddr, io_id_ex_rs1Addr) @[ForwardingUnit.scala 31:257]
    node _T_30 = and(_T_28, _T_29) @[ForwardingUnit.scala 31:236]
    node _T_31 = eq(io_mem_wb_rdAddr, io_id_ex_rs2Addr) @[ForwardingUnit.scala 31:300]
    node _T_32 = and(_T_30, _T_31) @[ForwardingUnit.scala 31:279]
    node _T_33 = eq(io_memWb_reg_write, UInt<1>("h1")) @[ForwardingUnit.scala 34:35]
    node _T_34 = neq(io_mem_wb_rdAddr, UInt<1>("h0")) @[ForwardingUnit.scala 34:66]
    node _T_35 = and(_T_33, _T_34) @[ForwardingUnit.scala 34:46]
    node _T_36 = eq(io_exMem_reg_write, UInt<1>("h1")) @[ForwardingUnit.scala 34:106]
    node _T_37 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[ForwardingUnit.scala 34:139]
    node _T_38 = and(_T_36, _T_37) @[ForwardingUnit.scala 34:118]
    node _T_39 = eq(io_ex_mem_rdAddr, io_id_ex_rs2Addr) @[ForwardingUnit.scala 34:176]
    node _T_40 = and(_T_38, _T_39) @[ForwardingUnit.scala 34:155]
    node _T_41 = not(_T_40) @[ForwardingUnit.scala 34:84]
    node _T_42 = and(_T_35, _T_41) @[ForwardingUnit.scala 34:81]
    node _T_43 = eq(io_mem_wb_rdAddr, io_id_ex_rs2Addr) @[ForwardingUnit.scala 34:220]
    node _T_44 = and(_T_42, _T_43) @[ForwardingUnit.scala 34:199]
    node _T_45 = eq(io_memWb_reg_write, UInt<1>("h1")) @[ForwardingUnit.scala 36:35]
    node _T_46 = neq(io_mem_wb_rdAddr, UInt<1>("h0")) @[ForwardingUnit.scala 36:66]
    node _T_47 = and(_T_45, _T_46) @[ForwardingUnit.scala 36:46]
    node _T_48 = eq(io_exMem_reg_write, UInt<1>("h1")) @[ForwardingUnit.scala 36:106]
    node _T_49 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[ForwardingUnit.scala 36:139]
    node _T_50 = and(_T_48, _T_49) @[ForwardingUnit.scala 36:118]
    node _T_51 = eq(io_ex_mem_rdAddr, io_id_ex_rs2Addr) @[ForwardingUnit.scala 36:176]
    node _T_52 = and(_T_50, _T_51) @[ForwardingUnit.scala 36:155]
    node _T_53 = not(_T_52) @[ForwardingUnit.scala 36:84]
    node _T_54 = and(_T_47, _T_53) @[ForwardingUnit.scala 36:81]
    node _T_55 = eq(io_mem_wb_rdAddr, io_id_ex_rs1Addr) @[ForwardingUnit.scala 36:221]
    node _T_56 = and(_T_54, _T_55) @[ForwardingUnit.scala 36:200]
    node _GEN_5 = mux(_T_56, UInt<2>("h2"), _GEN_3) @[ForwardingUnit.scala 36:243 ForwardingUnit.scala 37:18]
    node _GEN_6 = mux(_T_44, UInt<2>("h2"), _GEN_4) @[ForwardingUnit.scala 34:242 ForwardingUnit.scala 35:22]
    node _GEN_7 = mux(_T_44, _GEN_3, _GEN_5) @[ForwardingUnit.scala 34:242]
    node _GEN_8 = mux(_T_32, UInt<2>("h2"), _GEN_7) @[ForwardingUnit.scala 31:322 ForwardingUnit.scala 32:18]
    node _GEN_9 = mux(_T_32, UInt<2>("h2"), _GEN_6) @[ForwardingUnit.scala 31:322 ForwardingUnit.scala 33:18]
    io_frwdA <= _GEN_8
    io_frwdB <= _GEN_9

  module decode_frwd :
    input clock : Clock
    input reset : UInt<1>
    input io_id_ex_rdAddr : UInt<5>
    input io_id_ex_memRead : UInt<1>
    input io_ex_mem_rdAddr : UInt<5>
    input io_ex_mem_memRead : UInt<1>
    input io_mem_wr_rdAddr : UInt<5>
    input io_mem_wr_memRead : UInt<1>
    input io_rs1Addr : UInt<5>
    input io_rs2Addr : UInt<5>
    input io_c_branch : UInt<1>
    output io_frwd_A : UInt<4>
    output io_frwd_B : UInt<4>

    node _T = eq(io_c_branch, UInt<1>("h1")) @[BranchForward.scala 22:22]
    node _T_1 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 24:30]
    node _T_2 = neq(io_id_ex_memRead, UInt<1>("h1")) @[BranchForward.scala 24:65]
    node _T_3 = and(_T_1, _T_2) @[BranchForward.scala 24:45]
    node _T_4 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 24:93]
    node _T_5 = and(_T_3, _T_4) @[BranchForward.scala 24:73]
    node _T_6 = eq(io_id_ex_rdAddr, io_rs2Addr) @[BranchForward.scala 24:129]
    node _T_7 = and(_T_5, _T_6) @[BranchForward.scala 24:109]
    node _T_8 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 27:36]
    node _T_9 = neq(io_id_ex_memRead, UInt<1>("h1")) @[BranchForward.scala 27:71]
    node _T_10 = and(_T_8, _T_9) @[BranchForward.scala 27:51]
    node _T_11 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 27:99]
    node _T_12 = and(_T_10, _T_11) @[BranchForward.scala 27:79]
    node _T_13 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 29:36]
    node _T_14 = neq(io_id_ex_memRead, UInt<1>("h1")) @[BranchForward.scala 29:71]
    node _T_15 = and(_T_13, _T_14) @[BranchForward.scala 29:51]
    node _T_16 = eq(io_id_ex_rdAddr, io_rs2Addr) @[BranchForward.scala 29:99]
    node _T_17 = and(_T_15, _T_16) @[BranchForward.scala 29:79]
    node _GEN_0 = mux(_T_17, UInt<1>("h1"), UInt<1>("h0")) @[BranchForward.scala 29:116 BranchForward.scala 30:23 BranchForward.scala 21:15]
    node _GEN_1 = mux(_T_12, UInt<1>("h1"), UInt<1>("h0")) @[BranchForward.scala 27:116 BranchForward.scala 28:23 BranchForward.scala 20:15]
    node _GEN_2 = mux(_T_12, UInt<1>("h0"), _GEN_0) @[BranchForward.scala 27:116 BranchForward.scala 21:15]
    node _GEN_3 = mux(_T_7, UInt<1>("h1"), _GEN_1) @[BranchForward.scala 24:146 BranchForward.scala 25:23]
    node _GEN_4 = mux(_T_7, UInt<1>("h1"), _GEN_2) @[BranchForward.scala 24:146 BranchForward.scala 26:23]
    node _T_18 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 34:31]
    node _T_19 = neq(io_ex_mem_memRead, UInt<1>("h1")) @[BranchForward.scala 34:67]
    node _T_20 = and(_T_18, _T_19) @[BranchForward.scala 34:46]
    node _T_21 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 35:28]
    node _T_22 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 35:64]
    node _T_23 = and(_T_21, _T_22) @[BranchForward.scala 35:44]
    node _T_24 = eq(io_id_ex_rdAddr, io_rs2Addr) @[BranchForward.scala 35:100]
    node _T_25 = and(_T_23, _T_24) @[BranchForward.scala 35:80]
    node _T_26 = not(_T_25) @[BranchForward.scala 35:9]
    node _T_27 = and(_T_20, _T_26) @[BranchForward.scala 34:75]
    node _T_28 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 36:27]
    node _T_29 = and(_T_27, _T_28) @[BranchForward.scala 35:117]
    node _T_30 = eq(io_ex_mem_rdAddr, io_rs2Addr) @[BranchForward.scala 36:64]
    node _T_31 = and(_T_29, _T_30) @[BranchForward.scala 36:43]
    node _T_32 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 39:37]
    node _T_33 = neq(io_ex_mem_memRead, UInt<1>("h1")) @[BranchForward.scala 39:73]
    node _T_34 = and(_T_32, _T_33) @[BranchForward.scala 39:52]
    node _T_35 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 40:28]
    node _T_36 = eq(io_id_ex_rdAddr, io_rs2Addr) @[BranchForward.scala 40:64]
    node _T_37 = and(_T_35, _T_36) @[BranchForward.scala 40:44]
    node _T_38 = not(_T_37) @[BranchForward.scala 40:9]
    node _T_39 = and(_T_34, _T_38) @[BranchForward.scala 39:81]
    node _T_40 = eq(io_ex_mem_rdAddr, io_rs2Addr) @[BranchForward.scala 41:27]
    node _T_41 = and(_T_39, _T_40) @[BranchForward.scala 40:81]
    node _T_42 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 43:37]
    node _T_43 = neq(io_ex_mem_memRead, UInt<1>("h1")) @[BranchForward.scala 43:73]
    node _T_44 = and(_T_42, _T_43) @[BranchForward.scala 43:52]
    node _T_45 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 44:28]
    node _T_46 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 44:64]
    node _T_47 = and(_T_45, _T_46) @[BranchForward.scala 44:44]
    node _T_48 = not(_T_47) @[BranchForward.scala 44:9]
    node _T_49 = and(_T_44, _T_48) @[BranchForward.scala 43:81]
    node _T_50 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 45:27]
    node _T_51 = and(_T_49, _T_50) @[BranchForward.scala 44:81]
    node _T_52 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 47:37]
    node _T_53 = eq(io_ex_mem_memRead, UInt<1>("h1")) @[BranchForward.scala 47:73]
    node _T_54 = and(_T_52, _T_53) @[BranchForward.scala 47:52]
    node _T_55 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 48:28]
    node _T_56 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 48:64]
    node _T_57 = and(_T_55, _T_56) @[BranchForward.scala 48:44]
    node _T_58 = eq(io_id_ex_rdAddr, io_rs2Addr) @[BranchForward.scala 48:100]
    node _T_59 = and(_T_57, _T_58) @[BranchForward.scala 48:80]
    node _T_60 = not(_T_59) @[BranchForward.scala 48:9]
    node _T_61 = and(_T_54, _T_60) @[BranchForward.scala 47:81]
    node _T_62 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 49:27]
    node _T_63 = and(_T_61, _T_62) @[BranchForward.scala 48:117]
    node _T_64 = eq(io_ex_mem_rdAddr, io_rs2Addr) @[BranchForward.scala 49:64]
    node _T_65 = and(_T_63, _T_64) @[BranchForward.scala 49:43]
    node _T_66 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 54:37]
    node _T_67 = eq(io_ex_mem_memRead, UInt<1>("h1")) @[BranchForward.scala 54:73]
    node _T_68 = and(_T_66, _T_67) @[BranchForward.scala 54:52]
    node _T_69 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 55:28]
    node _T_70 = eq(io_id_ex_rdAddr, io_rs2Addr) @[BranchForward.scala 55:64]
    node _T_71 = and(_T_69, _T_70) @[BranchForward.scala 55:44]
    node _T_72 = not(_T_71) @[BranchForward.scala 55:9]
    node _T_73 = and(_T_68, _T_72) @[BranchForward.scala 54:81]
    node _T_74 = eq(io_ex_mem_rdAddr, io_rs2Addr) @[BranchForward.scala 56:27]
    node _T_75 = and(_T_73, _T_74) @[BranchForward.scala 55:81]
    node _T_76 = eq(io_c_branch, UInt<1>("h1")) @[BranchForward.scala 58:32]
    node _T_77 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 58:60]
    node _T_78 = and(_T_76, _T_77) @[BranchForward.scala 58:40]
    node _T_79 = eq(io_ex_mem_memRead, UInt<1>("h1")) @[BranchForward.scala 58:96]
    node _T_80 = and(_T_78, _T_79) @[BranchForward.scala 58:75]
    node _T_81 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 59:28]
    node _T_82 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 59:64]
    node _T_83 = and(_T_81, _T_82) @[BranchForward.scala 59:44]
    node _T_84 = not(_T_83) @[BranchForward.scala 59:9]
    node _T_85 = and(_T_80, _T_84) @[BranchForward.scala 58:104]
    node _T_86 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 60:27]
    node _T_87 = and(_T_85, _T_86) @[BranchForward.scala 59:81]
    node _GEN_5 = mux(_T_87, UInt<3>("h4"), _GEN_3) @[BranchForward.scala 60:43 BranchForward.scala 61:23]
    node _GEN_6 = mux(_T_75, UInt<3>("h4"), _GEN_4) @[BranchForward.scala 56:43 BranchForward.scala 57:23]
    node _GEN_7 = mux(_T_75, _GEN_3, _GEN_5) @[BranchForward.scala 56:43]
    node _GEN_8 = mux(_T_65, UInt<3>("h4"), _GEN_7) @[BranchForward.scala 49:81 BranchForward.scala 51:23]
    node _GEN_9 = mux(_T_65, UInt<3>("h4"), _GEN_6) @[BranchForward.scala 49:81 BranchForward.scala 52:23]
    node _GEN_10 = mux(_T_51, UInt<2>("h2"), _GEN_8) @[BranchForward.scala 45:43 BranchForward.scala 46:23]
    node _GEN_11 = mux(_T_51, _GEN_4, _GEN_9) @[BranchForward.scala 45:43]
    node _GEN_12 = mux(_T_41, UInt<2>("h2"), _GEN_11) @[BranchForward.scala 41:43 BranchForward.scala 42:23]
    node _GEN_13 = mux(_T_41, _GEN_3, _GEN_10) @[BranchForward.scala 41:43]
    node _GEN_14 = mux(_T_31, UInt<2>("h2"), _GEN_13) @[BranchForward.scala 36:80 BranchForward.scala 37:23]
    node _GEN_15 = mux(_T_31, UInt<2>("h2"), _GEN_12) @[BranchForward.scala 36:80 BranchForward.scala 38:23]
    node _T_88 = neq(io_mem_wr_rdAddr, UInt<1>("h0")) @[BranchForward.scala 65:31]
    node _T_89 = neq(io_mem_wr_memRead, UInt<1>("h1")) @[BranchForward.scala 65:67]
    node _T_90 = and(_T_88, _T_89) @[BranchForward.scala 65:46]
    node _T_91 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 67:28]
    node _T_92 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 67:64]
    node _T_93 = and(_T_91, _T_92) @[BranchForward.scala 67:44]
    node _T_94 = eq(io_id_ex_rdAddr, io_rs2Addr) @[BranchForward.scala 67:100]
    node _T_95 = and(_T_93, _T_94) @[BranchForward.scala 67:80]
    node _T_96 = not(_T_95) @[BranchForward.scala 67:9]
    node _T_97 = and(_T_90, _T_96) @[BranchForward.scala 65:75]
    node _T_98 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 69:29]
    node _T_99 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 69:66]
    node _T_100 = and(_T_98, _T_99) @[BranchForward.scala 69:45]
    node _T_101 = eq(io_ex_mem_rdAddr, io_rs2Addr) @[BranchForward.scala 69:103]
    node _T_102 = and(_T_100, _T_101) @[BranchForward.scala 69:82]
    node _T_103 = not(_T_102) @[BranchForward.scala 69:9]
    node _T_104 = and(_T_97, _T_103) @[BranchForward.scala 67:117]
    node _T_105 = eq(io_mem_wr_rdAddr, io_rs1Addr) @[BranchForward.scala 70:27]
    node _T_106 = and(_T_104, _T_105) @[BranchForward.scala 69:120]
    node _T_107 = eq(io_mem_wr_rdAddr, io_rs2Addr) @[BranchForward.scala 70:64]
    node _T_108 = and(_T_106, _T_107) @[BranchForward.scala 70:43]
    node _T_109 = neq(io_mem_wr_rdAddr, UInt<1>("h0")) @[BranchForward.scala 73:37]
    node _T_110 = neq(io_mem_wr_memRead, UInt<1>("h1")) @[BranchForward.scala 73:73]
    node _T_111 = and(_T_109, _T_110) @[BranchForward.scala 73:52]
    node _T_112 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 75:28]
    node _T_113 = eq(io_id_ex_rdAddr, io_rs2Addr) @[BranchForward.scala 75:64]
    node _T_114 = and(_T_112, _T_113) @[BranchForward.scala 75:44]
    node _T_115 = not(_T_114) @[BranchForward.scala 75:9]
    node _T_116 = and(_T_111, _T_115) @[BranchForward.scala 73:81]
    node _T_117 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 77:29]
    node _T_118 = eq(io_ex_mem_rdAddr, io_rs2Addr) @[BranchForward.scala 77:66]
    node _T_119 = and(_T_117, _T_118) @[BranchForward.scala 77:45]
    node _T_120 = not(_T_119) @[BranchForward.scala 77:9]
    node _T_121 = and(_T_116, _T_120) @[BranchForward.scala 75:81]
    node _T_122 = eq(io_mem_wr_rdAddr, io_rs2Addr) @[BranchForward.scala 78:27]
    node _T_123 = and(_T_121, _T_122) @[BranchForward.scala 77:83]
    node _T_124 = neq(io_mem_wr_rdAddr, UInt<1>("h0")) @[BranchForward.scala 80:37]
    node _T_125 = neq(io_mem_wr_memRead, UInt<1>("h1")) @[BranchForward.scala 80:73]
    node _T_126 = and(_T_124, _T_125) @[BranchForward.scala 80:52]
    node _T_127 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 82:28]
    node _T_128 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 82:64]
    node _T_129 = and(_T_127, _T_128) @[BranchForward.scala 82:44]
    node _T_130 = not(_T_129) @[BranchForward.scala 82:9]
    node _T_131 = and(_T_126, _T_130) @[BranchForward.scala 80:81]
    node _T_132 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 84:29]
    node _T_133 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 84:66]
    node _T_134 = and(_T_132, _T_133) @[BranchForward.scala 84:45]
    node _T_135 = not(_T_134) @[BranchForward.scala 84:9]
    node _T_136 = and(_T_131, _T_135) @[BranchForward.scala 82:81]
    node _T_137 = eq(io_mem_wr_rdAddr, io_rs1Addr) @[BranchForward.scala 85:27]
    node _T_138 = and(_T_136, _T_137) @[BranchForward.scala 84:83]
    node _T_139 = neq(io_mem_wr_rdAddr, UInt<1>("h0")) @[BranchForward.scala 87:37]
    node _T_140 = eq(io_mem_wr_memRead, UInt<1>("h1")) @[BranchForward.scala 87:73]
    node _T_141 = and(_T_139, _T_140) @[BranchForward.scala 87:52]
    node _T_142 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 89:28]
    node _T_143 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 89:64]
    node _T_144 = and(_T_142, _T_143) @[BranchForward.scala 89:44]
    node _T_145 = eq(io_id_ex_rdAddr, io_rs2Addr) @[BranchForward.scala 89:100]
    node _T_146 = and(_T_144, _T_145) @[BranchForward.scala 89:80]
    node _T_147 = not(_T_146) @[BranchForward.scala 89:9]
    node _T_148 = and(_T_141, _T_147) @[BranchForward.scala 87:81]
    node _T_149 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 91:29]
    node _T_150 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 91:66]
    node _T_151 = and(_T_149, _T_150) @[BranchForward.scala 91:45]
    node _T_152 = eq(io_ex_mem_rdAddr, io_rs2Addr) @[BranchForward.scala 91:103]
    node _T_153 = and(_T_151, _T_152) @[BranchForward.scala 91:82]
    node _T_154 = not(_T_153) @[BranchForward.scala 91:9]
    node _T_155 = and(_T_148, _T_154) @[BranchForward.scala 89:117]
    node _T_156 = eq(io_mem_wr_rdAddr, io_rs1Addr) @[BranchForward.scala 92:27]
    node _T_157 = and(_T_155, _T_156) @[BranchForward.scala 91:120]
    node _T_158 = eq(io_mem_wr_rdAddr, io_rs2Addr) @[BranchForward.scala 92:64]
    node _T_159 = and(_T_157, _T_158) @[BranchForward.scala 92:43]
    node _T_160 = neq(io_mem_wr_rdAddr, UInt<1>("h0")) @[BranchForward.scala 96:37]
    node _T_161 = eq(io_mem_wr_memRead, UInt<1>("h1")) @[BranchForward.scala 96:73]
    node _T_162 = and(_T_160, _T_161) @[BranchForward.scala 96:52]
    node _T_163 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 98:28]
    node _T_164 = eq(io_id_ex_rdAddr, io_rs2Addr) @[BranchForward.scala 98:64]
    node _T_165 = and(_T_163, _T_164) @[BranchForward.scala 98:44]
    node _T_166 = not(_T_165) @[BranchForward.scala 98:9]
    node _T_167 = and(_T_162, _T_166) @[BranchForward.scala 96:81]
    node _T_168 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 100:29]
    node _T_169 = eq(io_ex_mem_rdAddr, io_rs2Addr) @[BranchForward.scala 100:66]
    node _T_170 = and(_T_168, _T_169) @[BranchForward.scala 100:45]
    node _T_171 = not(_T_170) @[BranchForward.scala 100:9]
    node _T_172 = and(_T_167, _T_171) @[BranchForward.scala 98:81]
    node _T_173 = eq(io_mem_wr_rdAddr, io_rs2Addr) @[BranchForward.scala 101:27]
    node _T_174 = and(_T_172, _T_173) @[BranchForward.scala 100:83]
    node _T_175 = neq(io_mem_wr_rdAddr, UInt<1>("h0")) @[BranchForward.scala 103:37]
    node _T_176 = eq(io_mem_wr_memRead, UInt<1>("h1")) @[BranchForward.scala 103:73]
    node _T_177 = and(_T_175, _T_176) @[BranchForward.scala 103:52]
    node _T_178 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 105:28]
    node _T_179 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 105:64]
    node _T_180 = and(_T_178, _T_179) @[BranchForward.scala 105:44]
    node _T_181 = not(_T_180) @[BranchForward.scala 105:9]
    node _T_182 = and(_T_177, _T_181) @[BranchForward.scala 103:81]
    node _T_183 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 107:29]
    node _T_184 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 107:66]
    node _T_185 = and(_T_183, _T_184) @[BranchForward.scala 107:45]
    node _T_186 = not(_T_185) @[BranchForward.scala 107:9]
    node _T_187 = and(_T_182, _T_186) @[BranchForward.scala 105:81]
    node _T_188 = eq(io_mem_wr_rdAddr, io_rs1Addr) @[BranchForward.scala 108:27]
    node _T_189 = and(_T_187, _T_188) @[BranchForward.scala 107:82]
    node _GEN_16 = mux(_T_189, UInt<3>("h5"), _GEN_14) @[BranchForward.scala 108:44 BranchForward.scala 109:23]
    node _GEN_17 = mux(_T_174, UInt<3>("h5"), _GEN_15) @[BranchForward.scala 101:44 BranchForward.scala 102:23]
    node _GEN_18 = mux(_T_174, _GEN_14, _GEN_16) @[BranchForward.scala 101:44]
    node _GEN_19 = mux(_T_159, UInt<3>("h5"), _GEN_18) @[BranchForward.scala 92:80 BranchForward.scala 94:23]
    node _GEN_20 = mux(_T_159, UInt<3>("h5"), _GEN_17) @[BranchForward.scala 92:80 BranchForward.scala 95:23]
    node _GEN_21 = mux(_T_138, UInt<2>("h3"), _GEN_19) @[BranchForward.scala 85:44 BranchForward.scala 86:23]
    node _GEN_22 = mux(_T_138, _GEN_15, _GEN_20) @[BranchForward.scala 85:44]
    node _GEN_23 = mux(_T_123, UInt<2>("h3"), _GEN_22) @[BranchForward.scala 78:44 BranchForward.scala 79:23]
    node _GEN_24 = mux(_T_123, _GEN_14, _GEN_21) @[BranchForward.scala 78:44]
    node _GEN_25 = mux(_T_108, UInt<2>("h3"), _GEN_24) @[BranchForward.scala 70:81 BranchForward.scala 71:23]
    node _GEN_26 = mux(_T_108, UInt<2>("h3"), _GEN_23) @[BranchForward.scala 70:81 BranchForward.scala 72:23]
    node _T_190 = eq(io_c_branch, UInt<1>("h0")) @[BranchForward.scala 111:28]
    node _T_191 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 113:30]
    node _T_192 = neq(io_id_ex_memRead, UInt<1>("h1")) @[BranchForward.scala 113:65]
    node _T_193 = and(_T_191, _T_192) @[BranchForward.scala 113:45]
    node _T_194 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 113:93]
    node _T_195 = and(_T_193, _T_194) @[BranchForward.scala 113:73]
    node _GEN_27 = mux(_T_195, UInt<3>("h6"), UInt<1>("h0")) @[BranchForward.scala 113:109 BranchForward.scala 114:23 BranchForward.scala 20:15]
    node _T_196 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 117:31]
    node _T_197 = neq(io_ex_mem_memRead, UInt<1>("h1")) @[BranchForward.scala 117:67]
    node _T_198 = and(_T_196, _T_197) @[BranchForward.scala 117:46]
    node _T_199 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 118:28]
    node _T_200 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 118:64]
    node _T_201 = and(_T_199, _T_200) @[BranchForward.scala 118:44]
    node _T_202 = not(_T_201) @[BranchForward.scala 118:9]
    node _T_203 = and(_T_198, _T_202) @[BranchForward.scala 117:75]
    node _T_204 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 119:27]
    node _T_205 = and(_T_203, _T_204) @[BranchForward.scala 118:81]
    node _T_206 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 121:37]
    node _T_207 = eq(io_ex_mem_memRead, UInt<1>("h1")) @[BranchForward.scala 121:73]
    node _T_208 = and(_T_206, _T_207) @[BranchForward.scala 121:52]
    node _T_209 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 122:28]
    node _T_210 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 122:64]
    node _T_211 = and(_T_209, _T_210) @[BranchForward.scala 122:44]
    node _T_212 = not(_T_211) @[BranchForward.scala 122:9]
    node _T_213 = and(_T_208, _T_212) @[BranchForward.scala 121:81]
    node _T_214 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 123:27]
    node _T_215 = and(_T_213, _T_214) @[BranchForward.scala 122:81]
    node _GEN_28 = mux(_T_215, UInt<4>("h9"), _GEN_27) @[BranchForward.scala 123:43 BranchForward.scala 125:23]
    node _GEN_29 = mux(_T_205, UInt<3>("h7"), _GEN_28) @[BranchForward.scala 119:43 BranchForward.scala 120:23]
    node _T_216 = neq(io_mem_wr_rdAddr, UInt<1>("h0")) @[BranchForward.scala 128:31]
    node _T_217 = neq(io_mem_wr_memRead, UInt<1>("h1")) @[BranchForward.scala 128:67]
    node _T_218 = and(_T_216, _T_217) @[BranchForward.scala 128:46]
    node _T_219 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 130:28]
    node _T_220 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 130:64]
    node _T_221 = and(_T_219, _T_220) @[BranchForward.scala 130:44]
    node _T_222 = not(_T_221) @[BranchForward.scala 130:9]
    node _T_223 = and(_T_218, _T_222) @[BranchForward.scala 128:75]
    node _T_224 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 132:29]
    node _T_225 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 132:66]
    node _T_226 = and(_T_224, _T_225) @[BranchForward.scala 132:45]
    node _T_227 = not(_T_226) @[BranchForward.scala 132:9]
    node _T_228 = and(_T_223, _T_227) @[BranchForward.scala 130:81]
    node _T_229 = eq(io_mem_wr_rdAddr, io_rs1Addr) @[BranchForward.scala 133:27]
    node _T_230 = and(_T_228, _T_229) @[BranchForward.scala 132:83]
    node _T_231 = neq(io_mem_wr_rdAddr, UInt<1>("h0")) @[BranchForward.scala 135:37]
    node _T_232 = eq(io_mem_wr_memRead, UInt<1>("h1")) @[BranchForward.scala 135:73]
    node _T_233 = and(_T_231, _T_232) @[BranchForward.scala 135:52]
    node _T_234 = neq(io_id_ex_rdAddr, UInt<1>("h0")) @[BranchForward.scala 137:28]
    node _T_235 = eq(io_id_ex_rdAddr, io_rs1Addr) @[BranchForward.scala 137:64]
    node _T_236 = and(_T_234, _T_235) @[BranchForward.scala 137:44]
    node _T_237 = not(_T_236) @[BranchForward.scala 137:9]
    node _T_238 = and(_T_233, _T_237) @[BranchForward.scala 135:81]
    node _T_239 = neq(io_ex_mem_rdAddr, UInt<1>("h0")) @[BranchForward.scala 139:29]
    node _T_240 = eq(io_ex_mem_rdAddr, io_rs1Addr) @[BranchForward.scala 139:66]
    node _T_241 = and(_T_239, _T_240) @[BranchForward.scala 139:45]
    node _T_242 = not(_T_241) @[BranchForward.scala 139:9]
    node _T_243 = and(_T_238, _T_242) @[BranchForward.scala 137:81]
    node _T_244 = eq(io_mem_wr_rdAddr, io_rs1Addr) @[BranchForward.scala 140:27]
    node _T_245 = and(_T_243, _T_244) @[BranchForward.scala 139:83]
    node _GEN_30 = mux(_T_245, UInt<4>("ha"), _GEN_29) @[BranchForward.scala 140:44 BranchForward.scala 142:23]
    node _GEN_31 = mux(_T_230, UInt<4>("h8"), _GEN_30) @[BranchForward.scala 133:43 BranchForward.scala 134:23]
    node _GEN_32 = mux(_T_190, _GEN_31, UInt<1>("h0")) @[BranchForward.scala 111:36 BranchForward.scala 20:15]
    node _GEN_33 = mux(_T, _GEN_25, _GEN_32) @[BranchForward.scala 22:30]
    node _GEN_34 = mux(_T, _GEN_26, UInt<1>("h0")) @[BranchForward.scala 22:30 BranchForward.scala 21:15]
    io_frwd_A <= _GEN_33
    io_frwd_B <= _GEN_34

  module structuralDetector :
    input clock : Clock
    input reset : UInt<1>
    input io_rs1Addr : UInt<5>
    input io_rs2Addr : UInt<5>
    input io_mem_wb_regWr : UInt<1>
    input io_mem_wb_rdAddr : UInt<5>
    output io_frwd_A : UInt<1>
    output io_frwd_B : UInt<1>

    node _T = eq(io_mem_wb_regWr, UInt<1>("h1")) @[structural detector.scala 17:26]
    node _T_1 = eq(io_mem_wb_rdAddr, io_rs1Addr) @[structural detector.scala 17:55]
    node _T_2 = and(_T, _T_1) @[structural detector.scala 17:34]
    node _GEN_0 = mux(_T_2, UInt<1>("h1"), UInt<1>("h0")) @[structural detector.scala 17:71 structural detector.scala 18:19 structural detector.scala 20:19]
    node _T_3 = eq(io_mem_wb_regWr, UInt<1>("h1")) @[structural detector.scala 22:26]
    node _T_4 = eq(io_mem_wb_rdAddr, io_rs2Addr) @[structural detector.scala 22:54]
    node _T_5 = and(_T_3, _T_4) @[structural detector.scala 22:34]
    node _GEN_1 = mux(_T_5, UInt<1>("h1"), UInt<1>("h0")) @[structural detector.scala 22:70 structural detector.scala 23:19 structural detector.scala 25:19]
    io_frwd_A <= _GEN_0
    io_frwd_B <= _GEN_1

  module hazardDetection :
    input clock : Clock
    input reset : UInt<1>
    input io_id_ex_memRead : UInt<1>
    input io_id_ex_rdAddr : UInt<5>
    input io_if_id_in_inst : UInt<32>
    input io_in_pc : SInt<32>
    input io_in_pc4 : SInt<32>
    output io_inst_frwd : UInt<1>
    output io_pc_frwd : UInt<1>
    output io_ctrl_frwd : UInt<1>
    output io_if_id_inst_out : UInt<32>
    output io_pc4_out : SInt<32>
    output io_pc_out : SInt<32>

    node rs1Addr = bits(io_if_id_in_inst, 19, 15) @[hazardDetection.scala 21:35]
    node rs2Addr = bits(io_if_id_in_inst, 24, 20) @[hazardDetection.scala 22:35]
    node _T = eq(io_id_ex_memRead, UInt<1>("h1")) @[hazardDetection.scala 23:27]
    node _T_1 = eq(io_id_ex_rdAddr, rs1Addr) @[hazardDetection.scala 23:59]
    node _T_2 = eq(io_id_ex_rdAddr, rs2Addr) @[hazardDetection.scala 23:91]
    node _T_3 = or(_T_1, _T_2) @[hazardDetection.scala 23:72]
    node _T_4 = and(_T, _T_3) @[hazardDetection.scala 23:38]
    node _GEN_0 = mux(_T_4, UInt<1>("h1"), UInt<1>("h0")) @[hazardDetection.scala 23:105 hazardDetection.scala 24:22 hazardDetection.scala 31:22]
    node _GEN_1 = mux(_T_4, io_if_id_in_inst, io_if_id_in_inst) @[hazardDetection.scala 23:105 hazardDetection.scala 27:27 hazardDetection.scala 34:27]
    node _GEN_2 = mux(_T_4, io_in_pc, io_in_pc) @[hazardDetection.scala 23:105 hazardDetection.scala 28:19 hazardDetection.scala 36:19]
    node _GEN_3 = mux(_T_4, io_in_pc4, io_in_pc4) @[hazardDetection.scala 23:105 hazardDetection.scala 29:20 hazardDetection.scala 35:20]
    io_inst_frwd <= _GEN_0
    io_pc_frwd <= _GEN_0
    io_ctrl_frwd <= _GEN_0
    io_if_id_inst_out <= _GEN_1
    io_pc4_out <= _GEN_3
    io_pc_out <= _GEN_2

  module if_id :
    input clock : Clock
    input reset : UInt<1>
    input io_in_pc : SInt<32>
    input io_in_pc4 : SInt<32>
    input io_in_inst : UInt<32>
    output io_pc_out : SInt<32>
    output io_pc4_out : SInt<32>
    output io_inst_out : UInt<32>

    reg reg_opCode : UInt<32>, clock with :
      reset => (UInt<1>("h0"), reg_opCode) @[IF-ID reg.scala 33:29]
    reg reg_pc : SInt<32>, clock with :
      reset => (UInt<1>("h0"), reg_pc) @[IF-ID reg.scala 34:25]
    reg reg_pc4 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), reg_pc4) @[IF-ID reg.scala 35:26]
    reg reg_imm : UInt<32>, clock with :
      reset => (UInt<1>("h0"), reg_imm) @[IF-ID reg.scala 36:26]
    reg reg_inst : UInt<32>, clock with :
      reset => (UInt<1>("h0"), reg_inst) @[IF-ID reg.scala 42:27]
    io_pc_out <= reg_pc @[IF-ID reg.scala 57:15]
    io_pc4_out <= reg_pc4 @[IF-ID reg.scala 58:16]
    io_inst_out <= reg_inst @[IF-ID reg.scala 55:17]
    reg_opCode <= mux(reset, UInt<32>("h0"), reg_opCode) @[IF-ID reg.scala 33:29 IF-ID reg.scala 33:29 IF-ID reg.scala 33:29]
    reg_pc <= mux(reset, asSInt(UInt<32>("h0")), io_in_pc) @[IF-ID reg.scala 34:25 IF-ID reg.scala 34:25 IF-ID reg.scala 46:12]
    reg_pc4 <= mux(reset, asSInt(UInt<32>("h0")), io_in_pc4) @[IF-ID reg.scala 35:26 IF-ID reg.scala 35:26 IF-ID reg.scala 47:13]
    reg_imm <= mux(reset, UInt<32>("h0"), reg_imm) @[IF-ID reg.scala 36:26 IF-ID reg.scala 36:26 IF-ID reg.scala 36:26]
    reg_inst <= mux(reset, UInt<32>("h0"), io_in_inst) @[IF-ID reg.scala 42:27 IF-ID reg.scala 42:27 IF-ID reg.scala 44:14]

  module id_ex :
    input clock : Clock
    input reset : UInt<1>
    input io_in_c_memWrite : UInt<1>
    input io_in_c_branch : UInt<1>
    input io_in_c_memRead : UInt<1>
    input io_in_c_regWrite : UInt<1>
    input io_in_c_memToReg : UInt<1>
    input io_in_c_alu_Operation : UInt<3>
    input io_in_c_operand_A : UInt<2>
    input io_in_c_operand_B : UInt<1>
    input io_in_c_nextPc : UInt<2>
    input io_in_pc : SInt<32>
    input io_in_pc4 : SInt<32>
    input io_in_imm : SInt<32>
    input io_in_rs1 : SInt<32>
    input io_in_rs2 : SInt<32>
    input io_in_rs1Addr : UInt<5>
    input io_in_rs2Addr : UInt<5>
    input io_in_Rdaddr : UInt<5>
    input io_in_aluCout : UInt<11>
    input io_in_func3 : UInt<3>
    input io_in_func7 : UInt<7>
    output io_c_memWrite_out : UInt<1>
    output io_c_branch_out : UInt<1>
    output io_c_memRead_out : UInt<1>
    output io_c_regWrite_out : UInt<1>
    output io_c_memToReg_out : UInt<1>
    output io_c_alu_Operation_out : UInt<3>
    output io_c_operand_A_out : UInt<2>
    output io_c_operand_B_out : UInt<1>
    output io_c_nextPc_out : UInt<2>
    output io_pc_out : SInt<32>
    output io_pc4_out : SInt<32>
    output io_imm_out : SInt<32>
    output io_rs1_out : SInt<32>
    output io_rs2_out : SInt<32>
    output io_rs1Addr_out : UInt<5>
    output io_rs2Addr_out : UInt<5>
    output io_rdaddr_out : UInt<5>
    output io_aluCout_out : UInt<11>
    output io_func3_out : UInt<3>
    output io_func7_out : UInt<7>

    reg regc_memWrite : UInt<1>, clock with :
      reset => (UInt<1>("h0"), regc_memWrite) @[ID-EX.scala 50:32]
    reg regc_branch : UInt<1>, clock with :
      reset => (UInt<1>("h0"), regc_branch) @[ID-EX.scala 51:30]
    reg regc_memRead : UInt<1>, clock with :
      reset => (UInt<1>("h0"), regc_memRead) @[ID-EX.scala 52:31]
    reg regc_regWrite : UInt<1>, clock with :
      reset => (UInt<1>("h0"), regc_regWrite) @[ID-EX.scala 53:32]
    reg regc_memToReg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), regc_memToReg) @[ID-EX.scala 54:32]
    reg regc_alu_Operation : UInt<3>, clock with :
      reset => (UInt<1>("h0"), regc_alu_Operation) @[ID-EX.scala 55:37]
    reg regc_operand_A : UInt<2>, clock with :
      reset => (UInt<1>("h0"), regc_operand_A) @[ID-EX.scala 56:33]
    reg regc_operand_B : UInt<1>, clock with :
      reset => (UInt<1>("h0"), regc_operand_B) @[ID-EX.scala 57:33]
    reg regc_nextPc : UInt<2>, clock with :
      reset => (UInt<1>("h0"), regc_nextPc) @[ID-EX.scala 58:30]
    reg regpc : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regpc) @[ID-EX.scala 59:24]
    reg regpc4 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regpc4) @[ID-EX.scala 60:25]
    reg regimm : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regimm) @[ID-EX.scala 61:25]
    reg regrs1 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regrs1) @[ID-EX.scala 62:25]
    reg regrs2 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), regrs2) @[ID-EX.scala 63:25]
    reg regrs1_Addr : UInt<5>, clock with :
      reset => (UInt<1>("h0"), regrs1_Addr) @[ID-EX.scala 64:30]
    reg regrs2_Addr : UInt<5>, clock with :
      reset => (UInt<1>("h0"), regrs2_Addr) @[ID-EX.scala 65:30]
    reg regrd_addr : UInt<5>, clock with :
      reset => (UInt<1>("h0"), regrd_addr) @[ID-EX.scala 66:29]
    reg regAluCout : UInt<11>, clock with :
      reset => (UInt<1>("h0"), regAluCout) @[ID-EX.scala 67:29]
    reg regFunc3 : UInt<3>, clock with :
      reset => (UInt<1>("h0"), regFunc3) @[ID-EX.scala 68:27]
    reg regFunc7 : UInt<7>, clock with :
      reset => (UInt<1>("h0"), regFunc7) @[ID-EX.scala 69:27]
    io_c_memWrite_out <= regc_memWrite @[ID-EX.scala 92:23]
    io_c_branch_out <= regc_branch @[ID-EX.scala 93:21]
    io_c_memRead_out <= regc_memRead @[ID-EX.scala 94:22]
    io_c_regWrite_out <= regc_regWrite @[ID-EX.scala 95:23]
    io_c_memToReg_out <= regc_memToReg @[ID-EX.scala 96:23]
    io_c_alu_Operation_out <= regc_alu_Operation @[ID-EX.scala 97:28]
    io_c_operand_A_out <= regc_operand_A @[ID-EX.scala 98:24]
    io_c_operand_B_out <= regc_operand_B @[ID-EX.scala 99:24]
    io_c_nextPc_out <= regc_nextPc @[ID-EX.scala 108:21]
    io_pc_out <= regpc @[ID-EX.scala 100:15]
    io_pc4_out <= regpc4 @[ID-EX.scala 101:16]
    io_imm_out <= regimm @[ID-EX.scala 102:16]
    io_rs1_out <= regrs1 @[ID-EX.scala 104:16]
    io_rs2_out <= regrs2 @[ID-EX.scala 105:16]
    io_rs1Addr_out <= regrs1_Addr @[ID-EX.scala 106:20]
    io_rs2Addr_out <= regrs2_Addr @[ID-EX.scala 107:20]
    io_rdaddr_out <= regrd_addr @[ID-EX.scala 103:19]
    io_aluCout_out <= regAluCout @[ID-EX.scala 109:20]
    io_func3_out <= regFunc3 @[ID-EX.scala 110:18]
    io_func7_out <= regFunc7 @[ID-EX.scala 111:18]
    regc_memWrite <= mux(reset, UInt<1>("h0"), io_in_c_memWrite) @[ID-EX.scala 50:32 ID-EX.scala 50:32 ID-EX.scala 71:19]
    regc_branch <= mux(reset, UInt<1>("h0"), io_in_c_branch) @[ID-EX.scala 51:30 ID-EX.scala 51:30 ID-EX.scala 72:17]
    regc_memRead <= mux(reset, UInt<1>("h0"), io_in_c_memRead) @[ID-EX.scala 52:31 ID-EX.scala 52:31 ID-EX.scala 73:18]
    regc_regWrite <= mux(reset, UInt<1>("h0"), io_in_c_regWrite) @[ID-EX.scala 53:32 ID-EX.scala 53:32 ID-EX.scala 74:19]
    regc_memToReg <= mux(reset, UInt<1>("h0"), io_in_c_memToReg) @[ID-EX.scala 54:32 ID-EX.scala 54:32 ID-EX.scala 75:19]
    regc_alu_Operation <= mux(reset, UInt<3>("h0"), io_in_c_alu_Operation) @[ID-EX.scala 55:37 ID-EX.scala 55:37 ID-EX.scala 76:24]
    regc_operand_A <= mux(reset, UInt<2>("h0"), io_in_c_operand_A) @[ID-EX.scala 56:33 ID-EX.scala 56:33 ID-EX.scala 77:20]
    regc_operand_B <= mux(reset, UInt<1>("h0"), io_in_c_operand_B) @[ID-EX.scala 57:33 ID-EX.scala 57:33 ID-EX.scala 78:20]
    regc_nextPc <= mux(reset, UInt<2>("h0"), io_in_c_nextPc) @[ID-EX.scala 58:30 ID-EX.scala 58:30 ID-EX.scala 87:17]
    regpc <= mux(reset, asSInt(UInt<32>("h0")), io_in_pc) @[ID-EX.scala 59:24 ID-EX.scala 59:24 ID-EX.scala 79:11]
    regpc4 <= mux(reset, asSInt(UInt<32>("h0")), io_in_pc4) @[ID-EX.scala 60:25 ID-EX.scala 60:25 ID-EX.scala 80:12]
    regimm <= mux(reset, asSInt(UInt<32>("h0")), io_in_imm) @[ID-EX.scala 61:25 ID-EX.scala 61:25 ID-EX.scala 81:12]
    regrs1 <= mux(reset, asSInt(UInt<32>("h0")), io_in_rs1) @[ID-EX.scala 62:25 ID-EX.scala 62:25 ID-EX.scala 83:12]
    regrs2 <= mux(reset, asSInt(UInt<32>("h0")), io_in_rs2) @[ID-EX.scala 63:25 ID-EX.scala 63:25 ID-EX.scala 84:12]
    regrs1_Addr <= mux(reset, UInt<5>("h0"), io_in_rs1Addr) @[ID-EX.scala 64:30 ID-EX.scala 64:30 ID-EX.scala 85:17]
    regrs2_Addr <= mux(reset, UInt<5>("h0"), io_in_rs2Addr) @[ID-EX.scala 65:30 ID-EX.scala 65:30 ID-EX.scala 86:17]
    regrd_addr <= mux(reset, UInt<5>("h0"), io_in_Rdaddr) @[ID-EX.scala 66:29 ID-EX.scala 66:29 ID-EX.scala 82:16]
    regAluCout <= mux(reset, UInt<11>("h0"), io_in_aluCout) @[ID-EX.scala 67:29 ID-EX.scala 67:29 ID-EX.scala 88:16]
    regFunc3 <= mux(reset, UInt<3>("h0"), io_in_func3) @[ID-EX.scala 68:27 ID-EX.scala 68:27 ID-EX.scala 89:14]
    regFunc7 <= mux(reset, UInt<7>("h0"), io_in_func7) @[ID-EX.scala 69:27 ID-EX.scala 69:27 ID-EX.scala 90:14]

  module ex_mem :
    input clock : Clock
    input reset : UInt<1>
    input io_in_c_memwr : UInt<1>
    input io_in_c_memrd : UInt<1>
    input io_in_c_memtoreg : UInt<1>
    input io_in_rs2 : SInt<32>
    input io_in_Rdaddr : UInt<5>
    input io_in_Rs2addr : UInt<5>
    input io_in_ALUout : SInt<32>
    input io_in_c_regWrite : UInt<1>
    output io_memwr_out : UInt<1>
    output io_memrd_out : UInt<1>
    output io_memtoreg_out : UInt<1>
    output io_rs2_out : SInt<32>
    output io_rdaddr_out : UInt<5>
    output io_rs2addr_out : UInt<5>
    output io_ALUout_out : SInt<32>
    output io_reg_write_out : UInt<1>

    reg reg_memwr : UInt<1>, clock with :
      reset => (UInt<1>("h0"), reg_memwr) @[EX-MEM.scala 26:28]
    reg reg_memrd : UInt<1>, clock with :
      reset => (UInt<1>("h0"), reg_memrd) @[EX-MEM.scala 27:28]
    reg reg_memtoreg : UInt<1>, clock with :
      reset => (UInt<1>("h0"), reg_memtoreg) @[EX-MEM.scala 28:31]
    reg reg_rs2 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), reg_rs2) @[EX-MEM.scala 29:26]
    reg reg_Rdaddr : UInt<5>, clock with :
      reset => (UInt<1>("h0"), reg_Rdaddr) @[EX-MEM.scala 30:29]
    reg reg_Rs2addr : UInt<5>, clock with :
      reset => (UInt<1>("h0"), reg_Rs2addr) @[EX-MEM.scala 31:30]
    reg reg_Aluout : SInt<32>, clock with :
      reset => (UInt<1>("h0"), reg_Aluout) @[EX-MEM.scala 32:29]
    reg reg_regWrite : UInt<1>, clock with :
      reset => (UInt<1>("h0"), reg_regWrite) @[EX-MEM.scala 33:31]
    io_memwr_out <= reg_memwr @[EX-MEM.scala 44:18]
    io_memrd_out <= reg_memrd @[EX-MEM.scala 45:18]
    io_memtoreg_out <= reg_memtoreg @[EX-MEM.scala 46:21]
    io_rs2_out <= reg_rs2 @[EX-MEM.scala 47:16]
    io_rdaddr_out <= reg_Rdaddr @[EX-MEM.scala 48:19]
    io_rs2addr_out <= reg_Rs2addr @[EX-MEM.scala 49:20]
    io_ALUout_out <= reg_Aluout @[EX-MEM.scala 50:19]
    io_reg_write_out <= reg_regWrite @[EX-MEM.scala 51:22]
    reg_memwr <= mux(reset, UInt<1>("h0"), io_in_c_memwr) @[EX-MEM.scala 26:28 EX-MEM.scala 26:28 EX-MEM.scala 35:15]
    reg_memrd <= mux(reset, UInt<1>("h0"), io_in_c_memrd) @[EX-MEM.scala 27:28 EX-MEM.scala 27:28 EX-MEM.scala 36:15]
    reg_memtoreg <= mux(reset, UInt<1>("h0"), io_in_c_memtoreg) @[EX-MEM.scala 28:31 EX-MEM.scala 28:31 EX-MEM.scala 37:18]
    reg_rs2 <= mux(reset, asSInt(UInt<32>("h0")), io_in_rs2) @[EX-MEM.scala 29:26 EX-MEM.scala 29:26 EX-MEM.scala 38:13]
    reg_Rdaddr <= mux(reset, UInt<5>("h0"), io_in_Rdaddr) @[EX-MEM.scala 30:29 EX-MEM.scala 30:29 EX-MEM.scala 39:16]
    reg_Rs2addr <= mux(reset, UInt<5>("h0"), io_in_Rs2addr) @[EX-MEM.scala 31:30 EX-MEM.scala 31:30 EX-MEM.scala 40:17]
    reg_Aluout <= mux(reset, asSInt(UInt<32>("h0")), io_in_ALUout) @[EX-MEM.scala 32:29 EX-MEM.scala 32:29 EX-MEM.scala 41:16]
    reg_regWrite <= mux(reset, UInt<1>("h0"), io_in_c_regWrite) @[EX-MEM.scala 33:31 EX-MEM.scala 33:31 EX-MEM.scala 42:18]

  module mem_wr :
    input clock : Clock
    input reset : UInt<1>
    input io_in_c_memtoreg : UInt<1>
    input io_in_dataOut : SInt<32>
    input io_in_aluOut : SInt<32>
    input io_in_Rdaddr : UInt<5>
    input io_in_c_regWrite : UInt<1>
    input io_in_c_memRead : UInt<1>
    output io_c_memtoreg_out : UInt<1>
    output io_dataOut_out : SInt<32>
    output io_aluOut_out : SInt<32>
    output io_Rdaddr_out : UInt<5>
    output io_c_regWrite_out : UInt<1>
    output io_c_memRead_out : UInt<1>

    reg Reg_nextPc : UInt<1>, clock with :
      reset => (UInt<1>("h0"), Reg_nextPc) @[Mem-WR.scala 22:29]
    reg Reg_dataOut : SInt<32>, clock with :
      reset => (UInt<1>("h0"), Reg_dataOut) @[Mem-WR.scala 23:30]
    reg Reg_aluOut : SInt<32>, clock with :
      reset => (UInt<1>("h0"), Reg_aluOut) @[Mem-WR.scala 24:29]
    reg Reg_Rdaddr : UInt<5>, clock with :
      reset => (UInt<1>("h0"), Reg_Rdaddr) @[Mem-WR.scala 25:29]
    reg Reg_regWrite : UInt<1>, clock with :
      reset => (UInt<1>("h0"), Reg_regWrite) @[Mem-WR.scala 26:31]
    reg Reg_memRead : UInt<1>, clock with :
      reset => (UInt<1>("h0"), Reg_memRead) @[Mem-WR.scala 27:30]
    io_c_memtoreg_out <= Reg_nextPc @[Mem-WR.scala 36:23]
    io_dataOut_out <= Reg_dataOut @[Mem-WR.scala 37:20]
    io_aluOut_out <= Reg_aluOut @[Mem-WR.scala 38:19]
    io_Rdaddr_out <= Reg_Rdaddr @[Mem-WR.scala 39:19]
    io_c_regWrite_out <= Reg_regWrite @[Mem-WR.scala 40:23]
    io_c_memRead_out <= Reg_memRead @[Mem-WR.scala 41:22]
    Reg_nextPc <= mux(reset, UInt<1>("h0"), io_in_c_memtoreg) @[Mem-WR.scala 22:29 Mem-WR.scala 22:29 Mem-WR.scala 29:16]
    Reg_dataOut <= mux(reset, asSInt(UInt<32>("h0")), io_in_dataOut) @[Mem-WR.scala 23:30 Mem-WR.scala 23:30 Mem-WR.scala 30:17]
    Reg_aluOut <= mux(reset, asSInt(UInt<32>("h0")), io_in_aluOut) @[Mem-WR.scala 24:29 Mem-WR.scala 24:29 Mem-WR.scala 31:16]
    Reg_Rdaddr <= mux(reset, UInt<5>("h0"), io_in_Rdaddr) @[Mem-WR.scala 25:29 Mem-WR.scala 25:29 Mem-WR.scala 32:16]
    Reg_regWrite <= mux(reset, UInt<1>("h0"), io_in_c_regWrite) @[Mem-WR.scala 26:31 Mem-WR.scala 26:31 Mem-WR.scala 33:18]
    Reg_memRead <= mux(reset, UInt<1>("h0"), io_in_c_memRead) @[Mem-WR.scala 27:30 Mem-WR.scala 27:30 Mem-WR.scala 34:17]

  module dataMemory :
    input clock : Clock
    input reset : UInt<1>
    input io_writeData : UInt<1>
    input io_readData : UInt<1>
    input io_rdAddr : UInt<10>
    input io_dataIn : SInt<32>
    output io_dataOut : SInt<32>

    mem mem : @[DataMem.scala 15:15]
      data-type => SInt<32>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => io_dataOut_MPORT
      writer => MPORT
      read-under-write => undefined
    node _T = eq(io_writeData, UInt<1>("h1")) @[DataMem.scala 16:24]
    node _GEN_0 = validif(_T, io_rdAddr) @[DataMem.scala 16:32]
    node _GEN_1 = validif(_T, clock) @[DataMem.scala 16:32]
    node _GEN_2 = mux(_T, UInt<1>("h1"), UInt<1>("h0")) @[DataMem.scala 16:32 DataMem.scala 15:15]
    node _GEN_3 = validif(_T, UInt<1>("h1")) @[DataMem.scala 16:32]
    node _GEN_4 = validif(_T, io_dataIn) @[DataMem.scala 16:32]
    node _T_1 = eq(io_readData, UInt<1>("h1")) @[DataMem.scala 19:22]
    node _GEN_5 = validif(_T_1, io_rdAddr) @[DataMem.scala 19:29 DataMem.scala 20:31]
    node _GEN_6 = validif(_T_1, clock) @[DataMem.scala 19:29 DataMem.scala 20:31]
    node _GEN_7 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[DataMem.scala 19:29 DataMem.scala 20:31 DataMem.scala 15:15]
    node _GEN_8 = mux(_T_1, mem.io_dataOut_MPORT.data, asSInt(UInt<1>("h0"))) @[DataMem.scala 19:29 DataMem.scala 20:20 DataMem.scala 22:20]
    io_dataOut <= _GEN_8
    mem.io_dataOut_MPORT.addr <= _GEN_5
    mem.io_dataOut_MPORT.en <= _GEN_7
    mem.io_dataOut_MPORT.clk <= _GEN_6
    mem.MPORT.addr <= _GEN_0
    mem.MPORT.en <= _GEN_2
    mem.MPORT.clk <= _GEN_1
    mem.MPORT.data <= _GEN_4
    mem.MPORT.mask <= _GEN_3

  module control :
    input clock : Clock
    input reset : UInt<1>
    input io_op_code : UInt<7>
    output io_memWrite : UInt<1>
    output io_branch : UInt<1>
    output io_memRead : UInt<1>
    output io_regWrite : UInt<1>
    output io_memToReg : UInt<1>
    output io_alu_Operation : UInt<3>
    output io_operand_A : UInt<2>
    output io_operand_B : UInt<1>
    output io_extend_Sel : UInt<2>
    output io_nextPc_Sel : UInt<2>

    node _T = eq(io_op_code, UInt<6>("h33")) @[ControlUnit.scala 20:21]
    node _T_1 = eq(io_op_code, UInt<5>("h13")) @[ControlUnit.scala 31:27]
    node _T_2 = eq(io_op_code, UInt<2>("h3")) @[ControlUnit.scala 42:27]
    node _T_3 = eq(io_op_code, UInt<6>("h23")) @[ControlUnit.scala 53:27]
    node _T_4 = eq(io_op_code, UInt<7>("h63")) @[ControlUnit.scala 64:27]
    node _T_5 = eq(io_op_code, UInt<6>("h37")) @[ControlUnit.scala 75:27]
    node _T_6 = eq(io_op_code, UInt<7>("h6f")) @[ControlUnit.scala 86:27]
    node _T_7 = eq(io_op_code, UInt<5>("h17")) @[ControlUnit.scala 97:27]
    node _T_8 = eq(io_op_code, UInt<7>("h67")) @[ControlUnit.scala 108:27]
    node _GEN_0 = validif(_T_8, UInt<1>("h0")) @[ControlUnit.scala 108:44 ControlUnit.scala 109:21]
    node _GEN_1 = validif(_T_8, UInt<1>("h1")) @[ControlUnit.scala 108:44 ControlUnit.scala 112:21]
    node _GEN_2 = validif(_T_8, UInt<2>("h3")) @[ControlUnit.scala 108:44 ControlUnit.scala 114:26]
    node _GEN_3 = validif(_T_8, UInt<2>("h2")) @[ControlUnit.scala 108:44 ControlUnit.scala 115:22]
    node _GEN_4 = mux(_T_7, UInt<1>("h0"), _GEN_0) @[ControlUnit.scala 97:44 ControlUnit.scala 98:21]
    node _GEN_5 = mux(_T_7, UInt<1>("h1"), _GEN_1) @[ControlUnit.scala 97:44 ControlUnit.scala 101:21]
    node _GEN_6 = mux(_T_7, UInt<3>("h7"), _GEN_2) @[ControlUnit.scala 97:44 ControlUnit.scala 103:26]
    node _GEN_7 = mux(_T_7, UInt<2>("h2"), _GEN_3) @[ControlUnit.scala 97:44 ControlUnit.scala 104:22]
    node _GEN_8 = mux(_T_7, UInt<2>("h2"), _GEN_0) @[ControlUnit.scala 97:44 ControlUnit.scala 106:23]
    node _GEN_9 = mux(_T_7, UInt<1>("h0"), _GEN_2) @[ControlUnit.scala 97:44 ControlUnit.scala 107:23]
    node _GEN_10 = mux(_T_6, UInt<1>("h0"), _GEN_4) @[ControlUnit.scala 86:44 ControlUnit.scala 87:21]
    node _GEN_11 = mux(_T_6, UInt<1>("h1"), _GEN_5) @[ControlUnit.scala 86:44 ControlUnit.scala 90:21]
    node _GEN_12 = mux(_T_6, UInt<2>("h3"), _GEN_6) @[ControlUnit.scala 86:44 ControlUnit.scala 92:26]
    node _GEN_13 = mux(_T_6, UInt<2>("h2"), _GEN_7) @[ControlUnit.scala 86:44 ControlUnit.scala 93:22]
    node _GEN_14 = mux(_T_6, UInt<1>("h0"), _GEN_5) @[ControlUnit.scala 86:44 ControlUnit.scala 94:22]
    node _GEN_15 = mux(_T_6, UInt<1>("h0"), _GEN_8) @[ControlUnit.scala 86:44 ControlUnit.scala 95:23]
    node _GEN_16 = mux(_T_6, UInt<2>("h2"), _GEN_9) @[ControlUnit.scala 86:44 ControlUnit.scala 96:23]
    node _GEN_17 = mux(_T_5, UInt<1>("h0"), _GEN_10) @[ControlUnit.scala 75:44 ControlUnit.scala 76:21]
    node _GEN_18 = mux(_T_5, UInt<1>("h1"), _GEN_11) @[ControlUnit.scala 75:44 ControlUnit.scala 79:21]
    node _GEN_19 = mux(_T_5, UInt<3>("h6"), _GEN_12) @[ControlUnit.scala 75:44 ControlUnit.scala 81:26]
    node _GEN_20 = mux(_T_5, UInt<2>("h3"), _GEN_13) @[ControlUnit.scala 75:44 ControlUnit.scala 82:22]
    node _GEN_21 = mux(_T_5, UInt<1>("h1"), _GEN_14) @[ControlUnit.scala 75:44 ControlUnit.scala 83:22]
    node _GEN_22 = mux(_T_5, UInt<2>("h2"), _GEN_15) @[ControlUnit.scala 75:44 ControlUnit.scala 84:23]
    node _GEN_23 = mux(_T_5, UInt<1>("h0"), _GEN_16) @[ControlUnit.scala 75:44 ControlUnit.scala 85:23]
    node _GEN_24 = mux(_T_4, UInt<1>("h0"), _GEN_17) @[ControlUnit.scala 64:44 ControlUnit.scala 65:21]
    node _GEN_25 = mux(_T_4, UInt<1>("h1"), _GEN_17) @[ControlUnit.scala 64:44 ControlUnit.scala 66:19]
    node _GEN_26 = mux(_T_4, UInt<1>("h0"), _GEN_18) @[ControlUnit.scala 64:44 ControlUnit.scala 68:21]
    node _GEN_27 = mux(_T_4, UInt<2>("h2"), _GEN_19) @[ControlUnit.scala 64:44 ControlUnit.scala 70:26]
    node _GEN_28 = mux(_T_4, UInt<1>("h0"), _GEN_20) @[ControlUnit.scala 64:44 ControlUnit.scala 71:22]
    node _GEN_29 = mux(_T_4, UInt<1>("h0"), _GEN_21) @[ControlUnit.scala 64:44 ControlUnit.scala 72:22]
    node _GEN_30 = mux(_T_4, UInt<1>("h0"), _GEN_22) @[ControlUnit.scala 64:44 ControlUnit.scala 73:23]
    node _GEN_31 = mux(_T_4, UInt<1>("h1"), _GEN_23) @[ControlUnit.scala 64:44 ControlUnit.scala 74:23]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_24) @[ControlUnit.scala 53:44 ControlUnit.scala 54:21]
    node _GEN_33 = mux(_T_3, UInt<1>("h0"), _GEN_25) @[ControlUnit.scala 53:44 ControlUnit.scala 55:19]
    node _GEN_34 = mux(_T_3, UInt<1>("h0"), _GEN_24) @[ControlUnit.scala 53:44 ControlUnit.scala 56:20]
    node _GEN_35 = mux(_T_3, UInt<1>("h0"), _GEN_26) @[ControlUnit.scala 53:44 ControlUnit.scala 57:21]
    node _GEN_36 = mux(_T_3, UInt<3>("h5"), _GEN_27) @[ControlUnit.scala 53:44 ControlUnit.scala 59:26]
    node _GEN_37 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[ControlUnit.scala 53:44 ControlUnit.scala 60:22]
    node _GEN_38 = mux(_T_3, UInt<1>("h1"), _GEN_29) @[ControlUnit.scala 53:44 ControlUnit.scala 61:22]
    node _GEN_39 = mux(_T_3, UInt<1>("h1"), _GEN_30) @[ControlUnit.scala 53:44 ControlUnit.scala 62:23]
    node _GEN_40 = mux(_T_3, UInt<1>("h0"), _GEN_31) @[ControlUnit.scala 53:44 ControlUnit.scala 63:23]
    node _GEN_41 = mux(_T_2, UInt<1>("h0"), _GEN_32) @[ControlUnit.scala 42:44 ControlUnit.scala 43:21]
    node _GEN_42 = mux(_T_2, UInt<1>("h0"), _GEN_33) @[ControlUnit.scala 42:44 ControlUnit.scala 44:19]
    node _GEN_43 = mux(_T_2, UInt<1>("h1"), _GEN_34) @[ControlUnit.scala 42:44 ControlUnit.scala 45:20]
    node _GEN_44 = mux(_T_2, UInt<1>("h1"), _GEN_35) @[ControlUnit.scala 42:44 ControlUnit.scala 46:21]
    node _GEN_45 = mux(_T_2, UInt<3>("h4"), _GEN_36) @[ControlUnit.scala 42:44 ControlUnit.scala 48:26]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_37) @[ControlUnit.scala 42:44 ControlUnit.scala 49:22]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_38) @[ControlUnit.scala 42:44 ControlUnit.scala 50:22]
    node _GEN_48 = mux(_T_2, UInt<1>("h0"), _GEN_39) @[ControlUnit.scala 42:44 ControlUnit.scala 51:23]
    node _GEN_49 = mux(_T_2, UInt<1>("h0"), _GEN_40) @[ControlUnit.scala 42:44 ControlUnit.scala 52:23]
    node _GEN_50 = mux(_T_1, UInt<1>("h0"), _GEN_41) @[ControlUnit.scala 31:44 ControlUnit.scala 32:21]
    node _GEN_51 = mux(_T_1, UInt<1>("h0"), _GEN_42) @[ControlUnit.scala 31:44 ControlUnit.scala 33:19]
    node _GEN_52 = mux(_T_1, UInt<1>("h0"), _GEN_43) @[ControlUnit.scala 31:44 ControlUnit.scala 34:20]
    node _GEN_53 = mux(_T_1, UInt<1>("h1"), _GEN_44) @[ControlUnit.scala 31:44 ControlUnit.scala 35:21]
    node _GEN_54 = mux(_T_1, UInt<1>("h1"), _GEN_45) @[ControlUnit.scala 31:44 ControlUnit.scala 37:26]
    node _GEN_55 = mux(_T_1, UInt<1>("h0"), _GEN_46) @[ControlUnit.scala 31:44 ControlUnit.scala 38:22]
    node _GEN_56 = mux(_T_1, UInt<1>("h1"), _GEN_47) @[ControlUnit.scala 31:44 ControlUnit.scala 39:22]
    node _GEN_57 = mux(_T_1, UInt<1>("h0"), _GEN_48) @[ControlUnit.scala 31:44 ControlUnit.scala 40:23]
    node _GEN_58 = mux(_T_1, UInt<1>("h0"), _GEN_49) @[ControlUnit.scala 31:44 ControlUnit.scala 41:23]
    node _GEN_59 = mux(_T, UInt<1>("h0"), _GEN_50) @[ControlUnit.scala 20:38 ControlUnit.scala 21:21]
    node _GEN_60 = mux(_T, UInt<1>("h0"), _GEN_51) @[ControlUnit.scala 20:38 ControlUnit.scala 22:19]
    node _GEN_61 = mux(_T, UInt<1>("h0"), _GEN_52) @[ControlUnit.scala 20:38 ControlUnit.scala 23:20]
    node _GEN_62 = mux(_T, UInt<1>("h1"), _GEN_53) @[ControlUnit.scala 20:38 ControlUnit.scala 24:21]
    node _GEN_63 = mux(_T, UInt<1>("h0"), _GEN_54) @[ControlUnit.scala 20:38 ControlUnit.scala 26:26]
    node _GEN_64 = mux(_T, UInt<1>("h0"), _GEN_55) @[ControlUnit.scala 20:38 ControlUnit.scala 27:22]
    node _GEN_65 = mux(_T, UInt<1>("h0"), _GEN_56) @[ControlUnit.scala 20:38 ControlUnit.scala 28:22]
    node _GEN_66 = mux(_T, UInt<1>("h0"), _GEN_57) @[ControlUnit.scala 20:38 ControlUnit.scala 29:23]
    node _GEN_67 = mux(_T, UInt<1>("h0"), _GEN_58) @[ControlUnit.scala 20:38 ControlUnit.scala 30:23]
    io_memWrite <= _GEN_59
    io_branch <= _GEN_60
    io_memRead <= _GEN_61
    io_regWrite <= _GEN_62
    io_memToReg <= _GEN_61
    io_alu_Operation <= _GEN_63
    io_operand_A <= _GEN_64
    io_operand_B <= _GEN_65
    io_extend_Sel <= _GEN_66
    io_nextPc_Sel <= _GEN_67

  module immdValGen :
    input clock : Clock
    input reset : UInt<1>
    input io_instr : UInt<32>
    input io_pc : SInt<32>
    output io_s_imm : SInt<32>
    output io_sb_imm : SInt<32>
    output io_u_imm : SInt<32>
    output io_uj_imm : SInt<32>
    output io_i_imm : SInt<32>

    node s1 = bits(io_instr, 11, 7) @[ImmGen.scala 17:22]
    node s2 = bits(io_instr, 31, 25) @[ImmGen.scala 18:22]
    node s3 = cat(s2, s1) @[Cat.scala 30:58]
    node _s4_T = bits(s3, 11, 11) @[ImmGen.scala 20:29]
    node _s4_T_1 = bits(_s4_T, 0, 0) @[Bitwise.scala 72:15]
    node s4_hi = mux(_s4_T_1, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node s4 = cat(s4_hi, s3) @[Cat.scala 30:58]
    node _io_s_imm_T = asSInt(s4) @[ImmGen.scala 21:26]
    node sb1 = bits(io_instr, 11, 8) @[ImmGen.scala 23:23]
    node sb2 = bits(io_instr, 30, 25) @[ImmGen.scala 24:23]
    node sb3 = bits(io_instr, 7, 7) @[ImmGen.scala 25:23]
    node sb4 = bits(io_instr, 31, 31) @[ImmGen.scala 26:23]
    node sb5_lo_lo = asUInt(asSInt(UInt<1>("h0"))) @[Cat.scala 30:58]
    node sb5_lo = cat(sb1, sb5_lo_lo) @[Cat.scala 30:58]
    node sb5_hi_hi = cat(sb4, sb3) @[Cat.scala 30:58]
    node sb5_hi = cat(sb5_hi_hi, sb2) @[Cat.scala 30:58]
    node sb5 = cat(sb5_hi, sb5_lo) @[Cat.scala 30:58]
    node _sb6_T = bits(sb5, 12, 12) @[ImmGen.scala 28:31]
    node _sb6_T_1 = bits(_sb6_T, 0, 0) @[Bitwise.scala 72:15]
    node sb6_hi = mux(_sb6_T_1, UInt<19>("h7ffff"), UInt<19>("h0")) @[Bitwise.scala 72:12]
    node _sb6_T_2 = cat(sb6_hi, sb5) @[Cat.scala 30:58]
    node sb6 = asSInt(_sb6_T_2) @[ImmGen.scala 28:49]
    node _io_sb_imm_T = add(sb6, io_pc) @[ImmGen.scala 29:22]
    node _io_sb_imm_T_1 = tail(_io_sb_imm_T, 1) @[ImmGen.scala 29:22]
    node _io_sb_imm_T_2 = asSInt(_io_sb_imm_T_1) @[ImmGen.scala 29:22]
    node u1 = bits(io_instr, 31, 12) @[ImmGen.scala 31:22]
    node _u2_T = bits(u1, 19, 19) @[ImmGen.scala 32:29]
    node _u2_T_1 = bits(_u2_T, 0, 0) @[Bitwise.scala 72:15]
    node u2_hi = mux(_u2_T_1, UInt<12>("hfff"), UInt<12>("h0")) @[Bitwise.scala 72:12]
    node u2 = cat(u2_hi, u1) @[Cat.scala 30:58]
    node u3 = dshl(u2, UInt<4>("hc")) @[ImmGen.scala 33:17]
    node _io_u_imm_T = asSInt(u3) @[ImmGen.scala 34:26]
    node uj1 = bits(io_instr, 30, 21) @[ImmGen.scala 36:23]
    node uj2 = bits(io_instr, 20, 20) @[ImmGen.scala 37:23]
    node uj3 = bits(io_instr, 19, 12) @[ImmGen.scala 38:23]
    node uj4 = bits(io_instr, 31, 31) @[ImmGen.scala 39:23]
    node uj5_lo_lo = asUInt(asSInt(UInt<1>("h0"))) @[Cat.scala 30:58]
    node uj5_lo = cat(uj1, uj5_lo_lo) @[Cat.scala 30:58]
    node uj5_hi_hi = cat(uj4, uj3) @[Cat.scala 30:58]
    node uj5_hi = cat(uj5_hi_hi, uj2) @[Cat.scala 30:58]
    node uj5 = cat(uj5_hi, uj5_lo) @[Cat.scala 30:58]
    node _uj6_T = bits(uj5, 20, 20) @[ImmGen.scala 41:31]
    node _uj6_T_1 = bits(_uj6_T, 0, 0) @[Bitwise.scala 72:15]
    node uj6_hi = mux(_uj6_T_1, UInt<11>("h7ff"), UInt<11>("h0")) @[Bitwise.scala 72:12]
    node _uj6_T_2 = cat(uj6_hi, uj5) @[Cat.scala 30:58]
    node uj6 = asSInt(_uj6_T_2) @[ImmGen.scala 41:49]
    node _io_uj_imm_T = add(uj6, io_pc) @[ImmGen.scala 42:22]
    node _io_uj_imm_T_1 = tail(_io_uj_imm_T, 1) @[ImmGen.scala 42:22]
    node _io_uj_imm_T_2 = asSInt(_io_uj_imm_T_1) @[ImmGen.scala 42:22]
    node i1 = bits(io_instr, 31, 20) @[ImmGen.scala 44:22]
    node _i2_T = bits(i1, 11, 11) @[ImmGen.scala 45:29]
    node _i2_T_1 = bits(_i2_T, 0, 0) @[Bitwise.scala 72:15]
    node i2_hi = mux(_i2_T_1, UInt<20>("hfffff"), UInt<20>("h0")) @[Bitwise.scala 72:12]
    node i2 = cat(i2_hi, i1) @[Cat.scala 30:58]
    node _io_i_imm_T = asSInt(i2) @[ImmGen.scala 46:26]
    io_s_imm <= _io_s_imm_T @[ImmGen.scala 21:14]
    io_sb_imm <= _io_sb_imm_T_2 @[ImmGen.scala 29:15]
    io_u_imm <= asSInt(bits(_io_u_imm_T, 31, 0)) @[ImmGen.scala 34:14]
    io_uj_imm <= _io_uj_imm_T_2 @[ImmGen.scala 42:15]
    io_i_imm <= _io_i_imm_T @[ImmGen.scala 46:14]

  module aluControl :
    input clock : Clock
    input reset : UInt<1>
    input io_alu_Operation : UInt<3>
    input io_func3 : UInt<3>
    input io_func7 : UInt<7>
    output io_out : UInt<11>

    node _T = eq(io_alu_Operation, UInt<1>("h0")) @[ALU_Control.scala 14:27]
    node io_out_hi = cat(UInt<1>("h0"), io_func7) @[Cat.scala 30:58]
    node _io_out_T = cat(io_out_hi, io_func3) @[Cat.scala 30:58]
    node _T_1 = eq(io_alu_Operation, UInt<1>("h1")) @[ALU_Control.scala 16:33]
    node io_out_hi_1 = cat(UInt<1>("h0"), UInt<1>("h0")) @[Cat.scala 30:58]
    node _io_out_T_1 = cat(io_out_hi_1, io_func3) @[Cat.scala 30:58]
    node _T_2 = eq(io_alu_Operation, UInt<3>("h5")) @[ALU_Control.scala 18:33]
    node _T_3 = eq(io_alu_Operation, UInt<2>("h2")) @[ALU_Control.scala 20:33]
    node _io_out_T_2 = cat(UInt<8>("h80"), io_func3) @[Cat.scala 30:58]
    node _T_4 = eq(io_alu_Operation, UInt<3>("h6")) @[ALU_Control.scala 22:33]
    node _T_5 = eq(io_alu_Operation, UInt<2>("h3")) @[ALU_Control.scala 24:33]
    node _T_6 = eq(io_alu_Operation, UInt<3>("h4")) @[ALU_Control.scala 26:33]
    node _T_7 = eq(io_alu_Operation, UInt<3>("h7")) @[ALU_Control.scala 28:33]
    node _GEN_0 = validif(_T_7, UInt<1>("h0")) @[ALU_Control.scala 28:46 ALU_Control.scala 29:16]
    node _GEN_1 = mux(_T_6, UInt<1>("h0"), _GEN_0) @[ALU_Control.scala 26:46 ALU_Control.scala 27:16]
    node _GEN_2 = mux(_T_5, UInt<11>("h7ff"), _GEN_1) @[ALU_Control.scala 24:46 ALU_Control.scala 25:16]
    node _GEN_3 = mux(_T_4, UInt<1>("h0"), _GEN_2) @[ALU_Control.scala 22:46 ALU_Control.scala 23:16]
    node _GEN_4 = mux(_T_3, _io_out_T_2, _GEN_3) @[ALU_Control.scala 20:46 ALU_Control.scala 21:16]
    node _GEN_5 = mux(_T_2, UInt<1>("h0"), _GEN_4) @[ALU_Control.scala 18:46 ALU_Control.scala 19:16]
    node _GEN_6 = mux(_T_1, _io_out_T_1, _GEN_5) @[ALU_Control.scala 16:46 ALU_Control.scala 17:16]
    node _GEN_7 = mux(_T, _io_out_T, _GEN_6) @[ALU_Control.scala 14:40 ALU_Control.scala 15:16]
    io_out <= _GEN_7

  module ALU :
    input clock : Clock
    input reset : UInt<1>
    input io_in_A : SInt<32>
    input io_in_B : SInt<32>
    input io_alu_Op : UInt<11>
    output io_out : SInt<32>

    node _T = eq(UInt<11>("h0"), io_alu_Op) @[Conditional.scala 37:30]
    node _io_out_T = add(io_in_A, io_in_B) @[ALU.scala 37:31]
    node _io_out_T_1 = tail(_io_out_T, 1) @[ALU.scala 37:31]
    node _io_out_T_2 = asSInt(_io_out_T_1) @[ALU.scala 37:31]
    node _T_1 = eq(UInt<11>("h8"), io_alu_Op) @[Conditional.scala 37:30]
    node _io_out_T_3 = sub(io_in_A, io_in_B) @[ALU.scala 40:31]
    node _io_out_T_4 = tail(_io_out_T_3, 1) @[ALU.scala 40:31]
    node _io_out_T_5 = asSInt(_io_out_T_4) @[ALU.scala 40:31]
    node _T_2 = eq(UInt<11>("h2"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_3 = lt(io_in_A, io_in_B) @[ALU.scala 43:26]
    node _GEN_0 = mux(_T_3, asSInt(UInt<2>("h1")), asSInt(UInt<1>("h0"))) @[ALU.scala 43:37 ALU.scala 44:24 ALU.scala 46:24]
    node _T_4 = eq(UInt<11>("h3"), io_alu_Op) @[Conditional.scala 37:30]
    node _T_5 = asUInt(io_in_A) @[ALU.scala 50:26]
    node _T_6 = asUInt(io_in_B) @[ALU.scala 50:43]
    node _T_7 = lt(_T_5, _T_6) @[ALU.scala 50:33]
    node _GEN_1 = mux(_T_7, asSInt(UInt<2>("h1")), asSInt(UInt<1>("h0"))) @[ALU.scala 50:51 ALU.scala 51:24 ALU.scala 53:24]
    node _T_8 = eq(UInt<11>("h1d"), io_alu_Op) @[Conditional.scala 37:30]
    node _io_out_T_6 = bits(io_in_B, 4, 0) @[ALU.scala 57:41]
    node _io_out_T_7 = dshr(io_in_A, _io_out_T_6) @[ALU.scala 57:31]
    node _T_9 = eq(UInt<11>("h5"), io_alu_Op) @[Conditional.scala 37:30]
    node _io_out_T_8 = bits(io_in_B, 4, 0) @[ALU.scala 60:41]
    node _io_out_T_9 = dshr(io_in_A, _io_out_T_8) @[ALU.scala 60:31]
    node _T_10 = eq(UInt<11>("h1"), io_alu_Op) @[Conditional.scala 37:30]
    node sr = bits(io_in_B, 4, 0) @[ALU.scala 63:29]
    node _io_out_T_10 = dshl(io_in_A, sr) @[ALU.scala 64:31]
    node _T_11 = eq(UInt<11>("h7"), io_alu_Op) @[Conditional.scala 37:30]
    node _io_out_T_11 = and(io_in_A, io_in_B) @[ALU.scala 67:31]
    node _io_out_T_12 = asSInt(_io_out_T_11) @[ALU.scala 67:31]
    node _T_12 = eq(UInt<11>("h6"), io_alu_Op) @[Conditional.scala 37:30]
    node _io_out_T_13 = or(io_in_A, io_in_B) @[ALU.scala 70:29]
    node _io_out_T_14 = asSInt(_io_out_T_13) @[ALU.scala 70:29]
    node _T_13 = eq(UInt<11>("h4"), io_alu_Op) @[Conditional.scala 37:30]
    node _io_out_T_15 = xor(io_in_A, io_in_B) @[ALU.scala 73:28]
    node _io_out_T_16 = asSInt(_io_out_T_15) @[ALU.scala 73:28]
    node _T_14 = eq(UInt<11>("h1f"), io_alu_Op) @[Conditional.scala 37:30]
    node _GEN_2 = mux(_T_14, io_in_A, asSInt(UInt<1>("h0"))) @[Conditional.scala 39:67 ALU.scala 76:20 ALU.scala 33:12]
    node _GEN_3 = mux(_T_13, _io_out_T_16, _GEN_2) @[Conditional.scala 39:67 ALU.scala 73:16]
    node _GEN_4 = mux(_T_12, _io_out_T_14, _GEN_3) @[Conditional.scala 39:67 ALU.scala 70:19]
    node _GEN_5 = mux(_T_11, _io_out_T_12, _GEN_4) @[Conditional.scala 39:67 ALU.scala 67:20]
    node _GEN_6 = mux(_T_10, _io_out_T_10, _GEN_5) @[Conditional.scala 39:67 ALU.scala 64:20]
    node _GEN_7 = mux(_T_9, _io_out_T_9, _GEN_6) @[Conditional.scala 39:67 ALU.scala 60:20]
    node _GEN_8 = mux(_T_8, _io_out_T_7, _GEN_7) @[Conditional.scala 39:67 ALU.scala 57:20]
    node _GEN_9 = mux(_T_4, _GEN_1, _GEN_8) @[Conditional.scala 39:67]
    node _GEN_10 = mux(_T_2, _GEN_0, _GEN_9) @[Conditional.scala 39:67]
    node _GEN_11 = mux(_T_1, _io_out_T_5, _GEN_10) @[Conditional.scala 39:67 ALU.scala 40:20]
    node _GEN_12 = mux(_T, _io_out_T_2, _GEN_11) @[Conditional.scala 40:58 ALU.scala 37:20]
    io_out <= asSInt(bits(_GEN_12, 31, 0))

  module regFile :
    input clock : Clock
    input reset : UInt<1>
    input io_writeData : SInt<32>
    input io_rs1_addr : UInt<5>
    input io_rs2_addr : UInt<5>
    input io_rd_addr : UInt<5>
    output io_rs1 : SInt<32>
    output io_rs2 : SInt<32>
    input io_regWrite : UInt<1>

    reg register_0 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_0) @[Reg_Unit.scala 16:27]
    reg register_1 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_1) @[Reg_Unit.scala 16:27]
    reg register_2 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_2) @[Reg_Unit.scala 16:27]
    reg register_3 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_3) @[Reg_Unit.scala 16:27]
    reg register_4 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_4) @[Reg_Unit.scala 16:27]
    reg register_5 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_5) @[Reg_Unit.scala 16:27]
    reg register_6 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_6) @[Reg_Unit.scala 16:27]
    reg register_7 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_7) @[Reg_Unit.scala 16:27]
    reg register_8 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_8) @[Reg_Unit.scala 16:27]
    reg register_9 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_9) @[Reg_Unit.scala 16:27]
    reg register_10 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_10) @[Reg_Unit.scala 16:27]
    reg register_11 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_11) @[Reg_Unit.scala 16:27]
    reg register_12 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_12) @[Reg_Unit.scala 16:27]
    reg register_13 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_13) @[Reg_Unit.scala 16:27]
    reg register_14 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_14) @[Reg_Unit.scala 16:27]
    reg register_15 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_15) @[Reg_Unit.scala 16:27]
    reg register_16 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_16) @[Reg_Unit.scala 16:27]
    reg register_17 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_17) @[Reg_Unit.scala 16:27]
    reg register_18 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_18) @[Reg_Unit.scala 16:27]
    reg register_19 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_19) @[Reg_Unit.scala 16:27]
    reg register_20 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_20) @[Reg_Unit.scala 16:27]
    reg register_21 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_21) @[Reg_Unit.scala 16:27]
    reg register_22 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_22) @[Reg_Unit.scala 16:27]
    reg register_23 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_23) @[Reg_Unit.scala 16:27]
    reg register_24 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_24) @[Reg_Unit.scala 16:27]
    reg register_25 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_25) @[Reg_Unit.scala 16:27]
    reg register_26 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_26) @[Reg_Unit.scala 16:27]
    reg register_27 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_27) @[Reg_Unit.scala 16:27]
    reg register_28 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_28) @[Reg_Unit.scala 16:27]
    reg register_29 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_29) @[Reg_Unit.scala 16:27]
    reg register_30 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_30) @[Reg_Unit.scala 16:27]
    reg register_31 : SInt<32>, clock with :
      reset => (UInt<1>("h0"), register_31) @[Reg_Unit.scala 16:27]
    node _GEN_0 = validif(eq(UInt<1>("h0"), io_rs1_addr), register_0) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_1 = mux(eq(UInt<1>("h1"), io_rs1_addr), register_1, _GEN_0) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_2 = mux(eq(UInt<2>("h2"), io_rs1_addr), register_2, _GEN_1) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_3 = mux(eq(UInt<2>("h3"), io_rs1_addr), register_3, _GEN_2) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_4 = mux(eq(UInt<3>("h4"), io_rs1_addr), register_4, _GEN_3) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_5 = mux(eq(UInt<3>("h5"), io_rs1_addr), register_5, _GEN_4) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_6 = mux(eq(UInt<3>("h6"), io_rs1_addr), register_6, _GEN_5) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_7 = mux(eq(UInt<3>("h7"), io_rs1_addr), register_7, _GEN_6) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_8 = mux(eq(UInt<4>("h8"), io_rs1_addr), register_8, _GEN_7) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_9 = mux(eq(UInt<4>("h9"), io_rs1_addr), register_9, _GEN_8) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_10 = mux(eq(UInt<4>("ha"), io_rs1_addr), register_10, _GEN_9) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_11 = mux(eq(UInt<4>("hb"), io_rs1_addr), register_11, _GEN_10) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_12 = mux(eq(UInt<4>("hc"), io_rs1_addr), register_12, _GEN_11) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_13 = mux(eq(UInt<4>("hd"), io_rs1_addr), register_13, _GEN_12) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_14 = mux(eq(UInt<4>("he"), io_rs1_addr), register_14, _GEN_13) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_15 = mux(eq(UInt<4>("hf"), io_rs1_addr), register_15, _GEN_14) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_16 = mux(eq(UInt<5>("h10"), io_rs1_addr), register_16, _GEN_15) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_17 = mux(eq(UInt<5>("h11"), io_rs1_addr), register_17, _GEN_16) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_18 = mux(eq(UInt<5>("h12"), io_rs1_addr), register_18, _GEN_17) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_19 = mux(eq(UInt<5>("h13"), io_rs1_addr), register_19, _GEN_18) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_20 = mux(eq(UInt<5>("h14"), io_rs1_addr), register_20, _GEN_19) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_21 = mux(eq(UInt<5>("h15"), io_rs1_addr), register_21, _GEN_20) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_22 = mux(eq(UInt<5>("h16"), io_rs1_addr), register_22, _GEN_21) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_23 = mux(eq(UInt<5>("h17"), io_rs1_addr), register_23, _GEN_22) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_24 = mux(eq(UInt<5>("h18"), io_rs1_addr), register_24, _GEN_23) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_25 = mux(eq(UInt<5>("h19"), io_rs1_addr), register_25, _GEN_24) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_26 = mux(eq(UInt<5>("h1a"), io_rs1_addr), register_26, _GEN_25) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_27 = mux(eq(UInt<5>("h1b"), io_rs1_addr), register_27, _GEN_26) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_28 = mux(eq(UInt<5>("h1c"), io_rs1_addr), register_28, _GEN_27) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_29 = mux(eq(UInt<5>("h1d"), io_rs1_addr), register_29, _GEN_28) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_30 = mux(eq(UInt<5>("h1e"), io_rs1_addr), register_30, _GEN_29) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_31 = mux(eq(UInt<5>("h1f"), io_rs1_addr), register_31, _GEN_30) @[Reg_Unit.scala 18:12 Reg_Unit.scala 18:12]
    node _GEN_32 = validif(eq(UInt<1>("h0"), io_rs2_addr), register_0) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_33 = mux(eq(UInt<1>("h1"), io_rs2_addr), register_1, _GEN_32) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_34 = mux(eq(UInt<2>("h2"), io_rs2_addr), register_2, _GEN_33) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_35 = mux(eq(UInt<2>("h3"), io_rs2_addr), register_3, _GEN_34) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_36 = mux(eq(UInt<3>("h4"), io_rs2_addr), register_4, _GEN_35) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_37 = mux(eq(UInt<3>("h5"), io_rs2_addr), register_5, _GEN_36) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_38 = mux(eq(UInt<3>("h6"), io_rs2_addr), register_6, _GEN_37) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_39 = mux(eq(UInt<3>("h7"), io_rs2_addr), register_7, _GEN_38) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_40 = mux(eq(UInt<4>("h8"), io_rs2_addr), register_8, _GEN_39) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_41 = mux(eq(UInt<4>("h9"), io_rs2_addr), register_9, _GEN_40) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_42 = mux(eq(UInt<4>("ha"), io_rs2_addr), register_10, _GEN_41) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_43 = mux(eq(UInt<4>("hb"), io_rs2_addr), register_11, _GEN_42) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_44 = mux(eq(UInt<4>("hc"), io_rs2_addr), register_12, _GEN_43) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_45 = mux(eq(UInt<4>("hd"), io_rs2_addr), register_13, _GEN_44) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_46 = mux(eq(UInt<4>("he"), io_rs2_addr), register_14, _GEN_45) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_47 = mux(eq(UInt<4>("hf"), io_rs2_addr), register_15, _GEN_46) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_48 = mux(eq(UInt<5>("h10"), io_rs2_addr), register_16, _GEN_47) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_49 = mux(eq(UInt<5>("h11"), io_rs2_addr), register_17, _GEN_48) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_50 = mux(eq(UInt<5>("h12"), io_rs2_addr), register_18, _GEN_49) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_51 = mux(eq(UInt<5>("h13"), io_rs2_addr), register_19, _GEN_50) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_52 = mux(eq(UInt<5>("h14"), io_rs2_addr), register_20, _GEN_51) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_53 = mux(eq(UInt<5>("h15"), io_rs2_addr), register_21, _GEN_52) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_54 = mux(eq(UInt<5>("h16"), io_rs2_addr), register_22, _GEN_53) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_55 = mux(eq(UInt<5>("h17"), io_rs2_addr), register_23, _GEN_54) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_56 = mux(eq(UInt<5>("h18"), io_rs2_addr), register_24, _GEN_55) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_57 = mux(eq(UInt<5>("h19"), io_rs2_addr), register_25, _GEN_56) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_58 = mux(eq(UInt<5>("h1a"), io_rs2_addr), register_26, _GEN_57) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_59 = mux(eq(UInt<5>("h1b"), io_rs2_addr), register_27, _GEN_58) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_60 = mux(eq(UInt<5>("h1c"), io_rs2_addr), register_28, _GEN_59) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_61 = mux(eq(UInt<5>("h1d"), io_rs2_addr), register_29, _GEN_60) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_62 = mux(eq(UInt<5>("h1e"), io_rs2_addr), register_30, _GEN_61) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _GEN_63 = mux(eq(UInt<5>("h1f"), io_rs2_addr), register_31, _GEN_62) @[Reg_Unit.scala 19:12 Reg_Unit.scala 19:12]
    node _T = eq(io_rd_addr, UInt<1>("h0")) @[Reg_Unit.scala 20:21]
    node _register_io_rd_addr = pad(asSInt(UInt<1>("h0")), 32) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30]
    node _GEN_64 = mux(eq(UInt<1>("h0"), io_rd_addr), _register_io_rd_addr, asSInt(UInt<1>("h0"))) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 17:17]
    node _GEN_65 = mux(eq(UInt<1>("h1"), io_rd_addr), _register_io_rd_addr, register_1) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_66 = mux(eq(UInt<2>("h2"), io_rd_addr), _register_io_rd_addr, register_2) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_67 = mux(eq(UInt<2>("h3"), io_rd_addr), _register_io_rd_addr, register_3) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_68 = mux(eq(UInt<3>("h4"), io_rd_addr), _register_io_rd_addr, register_4) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_69 = mux(eq(UInt<3>("h5"), io_rd_addr), _register_io_rd_addr, register_5) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_70 = mux(eq(UInt<3>("h6"), io_rd_addr), _register_io_rd_addr, register_6) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_71 = mux(eq(UInt<3>("h7"), io_rd_addr), _register_io_rd_addr, register_7) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_72 = mux(eq(UInt<4>("h8"), io_rd_addr), _register_io_rd_addr, register_8) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_73 = mux(eq(UInt<4>("h9"), io_rd_addr), _register_io_rd_addr, register_9) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_74 = mux(eq(UInt<4>("ha"), io_rd_addr), _register_io_rd_addr, register_10) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_75 = mux(eq(UInt<4>("hb"), io_rd_addr), _register_io_rd_addr, register_11) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_76 = mux(eq(UInt<4>("hc"), io_rd_addr), _register_io_rd_addr, register_12) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_77 = mux(eq(UInt<4>("hd"), io_rd_addr), _register_io_rd_addr, register_13) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_78 = mux(eq(UInt<4>("he"), io_rd_addr), _register_io_rd_addr, register_14) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_79 = mux(eq(UInt<4>("hf"), io_rd_addr), _register_io_rd_addr, register_15) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_80 = mux(eq(UInt<5>("h10"), io_rd_addr), _register_io_rd_addr, register_16) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_81 = mux(eq(UInt<5>("h11"), io_rd_addr), _register_io_rd_addr, register_17) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_82 = mux(eq(UInt<5>("h12"), io_rd_addr), _register_io_rd_addr, register_18) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_83 = mux(eq(UInt<5>("h13"), io_rd_addr), _register_io_rd_addr, register_19) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_84 = mux(eq(UInt<5>("h14"), io_rd_addr), _register_io_rd_addr, register_20) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_85 = mux(eq(UInt<5>("h15"), io_rd_addr), _register_io_rd_addr, register_21) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_86 = mux(eq(UInt<5>("h16"), io_rd_addr), _register_io_rd_addr, register_22) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_87 = mux(eq(UInt<5>("h17"), io_rd_addr), _register_io_rd_addr, register_23) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_88 = mux(eq(UInt<5>("h18"), io_rd_addr), _register_io_rd_addr, register_24) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_89 = mux(eq(UInt<5>("h19"), io_rd_addr), _register_io_rd_addr, register_25) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_90 = mux(eq(UInt<5>("h1a"), io_rd_addr), _register_io_rd_addr, register_26) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_91 = mux(eq(UInt<5>("h1b"), io_rd_addr), _register_io_rd_addr, register_27) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_92 = mux(eq(UInt<5>("h1c"), io_rd_addr), _register_io_rd_addr, register_28) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_93 = mux(eq(UInt<5>("h1d"), io_rd_addr), _register_io_rd_addr, register_29) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_94 = mux(eq(UInt<5>("h1e"), io_rd_addr), _register_io_rd_addr, register_30) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _GEN_95 = mux(eq(UInt<5>("h1f"), io_rd_addr), _register_io_rd_addr, register_31) @[Reg_Unit.scala 21:30 Reg_Unit.scala 21:30 Reg_Unit.scala 16:27]
    node _register_io_rd_addr_0 = io_writeData @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30]
    node _GEN_96 = mux(eq(UInt<1>("h0"), io_rd_addr), _register_io_rd_addr_0, asSInt(UInt<1>("h0"))) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 17:17]
    node _GEN_97 = mux(eq(UInt<1>("h1"), io_rd_addr), _register_io_rd_addr_0, register_1) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_98 = mux(eq(UInt<2>("h2"), io_rd_addr), _register_io_rd_addr_0, register_2) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_99 = mux(eq(UInt<2>("h3"), io_rd_addr), _register_io_rd_addr_0, register_3) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_100 = mux(eq(UInt<3>("h4"), io_rd_addr), _register_io_rd_addr_0, register_4) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_101 = mux(eq(UInt<3>("h5"), io_rd_addr), _register_io_rd_addr_0, register_5) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_102 = mux(eq(UInt<3>("h6"), io_rd_addr), _register_io_rd_addr_0, register_6) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_103 = mux(eq(UInt<3>("h7"), io_rd_addr), _register_io_rd_addr_0, register_7) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_104 = mux(eq(UInt<4>("h8"), io_rd_addr), _register_io_rd_addr_0, register_8) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_105 = mux(eq(UInt<4>("h9"), io_rd_addr), _register_io_rd_addr_0, register_9) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_106 = mux(eq(UInt<4>("ha"), io_rd_addr), _register_io_rd_addr_0, register_10) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_107 = mux(eq(UInt<4>("hb"), io_rd_addr), _register_io_rd_addr_0, register_11) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_108 = mux(eq(UInt<4>("hc"), io_rd_addr), _register_io_rd_addr_0, register_12) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_109 = mux(eq(UInt<4>("hd"), io_rd_addr), _register_io_rd_addr_0, register_13) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_110 = mux(eq(UInt<4>("he"), io_rd_addr), _register_io_rd_addr_0, register_14) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_111 = mux(eq(UInt<4>("hf"), io_rd_addr), _register_io_rd_addr_0, register_15) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_112 = mux(eq(UInt<5>("h10"), io_rd_addr), _register_io_rd_addr_0, register_16) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_113 = mux(eq(UInt<5>("h11"), io_rd_addr), _register_io_rd_addr_0, register_17) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_114 = mux(eq(UInt<5>("h12"), io_rd_addr), _register_io_rd_addr_0, register_18) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_115 = mux(eq(UInt<5>("h13"), io_rd_addr), _register_io_rd_addr_0, register_19) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_116 = mux(eq(UInt<5>("h14"), io_rd_addr), _register_io_rd_addr_0, register_20) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_117 = mux(eq(UInt<5>("h15"), io_rd_addr), _register_io_rd_addr_0, register_21) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_118 = mux(eq(UInt<5>("h16"), io_rd_addr), _register_io_rd_addr_0, register_22) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_119 = mux(eq(UInt<5>("h17"), io_rd_addr), _register_io_rd_addr_0, register_23) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_120 = mux(eq(UInt<5>("h18"), io_rd_addr), _register_io_rd_addr_0, register_24) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_121 = mux(eq(UInt<5>("h19"), io_rd_addr), _register_io_rd_addr_0, register_25) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_122 = mux(eq(UInt<5>("h1a"), io_rd_addr), _register_io_rd_addr_0, register_26) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_123 = mux(eq(UInt<5>("h1b"), io_rd_addr), _register_io_rd_addr_0, register_27) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_124 = mux(eq(UInt<5>("h1c"), io_rd_addr), _register_io_rd_addr_0, register_28) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_125 = mux(eq(UInt<5>("h1d"), io_rd_addr), _register_io_rd_addr_0, register_29) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_126 = mux(eq(UInt<5>("h1e"), io_rd_addr), _register_io_rd_addr_0, register_30) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_127 = mux(eq(UInt<5>("h1f"), io_rd_addr), _register_io_rd_addr_0, register_31) @[Reg_Unit.scala 23:30 Reg_Unit.scala 23:30 Reg_Unit.scala 16:27]
    node _GEN_128 = mux(_T, _GEN_64, _GEN_96) @[Reg_Unit.scala 20:36]
    node _GEN_129 = mux(_T, _GEN_65, _GEN_97) @[Reg_Unit.scala 20:36]
    node _GEN_130 = mux(_T, _GEN_66, _GEN_98) @[Reg_Unit.scala 20:36]
    node _GEN_131 = mux(_T, _GEN_67, _GEN_99) @[Reg_Unit.scala 20:36]
    node _GEN_132 = mux(_T, _GEN_68, _GEN_100) @[Reg_Unit.scala 20:36]
    node _GEN_133 = mux(_T, _GEN_69, _GEN_101) @[Reg_Unit.scala 20:36]
    node _GEN_134 = mux(_T, _GEN_70, _GEN_102) @[Reg_Unit.scala 20:36]
    node _GEN_135 = mux(_T, _GEN_71, _GEN_103) @[Reg_Unit.scala 20:36]
    node _GEN_136 = mux(_T, _GEN_72, _GEN_104) @[Reg_Unit.scala 20:36]
    node _GEN_137 = mux(_T, _GEN_73, _GEN_105) @[Reg_Unit.scala 20:36]
    node _GEN_138 = mux(_T, _GEN_74, _GEN_106) @[Reg_Unit.scala 20:36]
    node _GEN_139 = mux(_T, _GEN_75, _GEN_107) @[Reg_Unit.scala 20:36]
    node _GEN_140 = mux(_T, _GEN_76, _GEN_108) @[Reg_Unit.scala 20:36]
    node _GEN_141 = mux(_T, _GEN_77, _GEN_109) @[Reg_Unit.scala 20:36]
    node _GEN_142 = mux(_T, _GEN_78, _GEN_110) @[Reg_Unit.scala 20:36]
    node _GEN_143 = mux(_T, _GEN_79, _GEN_111) @[Reg_Unit.scala 20:36]
    node _GEN_144 = mux(_T, _GEN_80, _GEN_112) @[Reg_Unit.scala 20:36]
    node _GEN_145 = mux(_T, _GEN_81, _GEN_113) @[Reg_Unit.scala 20:36]
    node _GEN_146 = mux(_T, _GEN_82, _GEN_114) @[Reg_Unit.scala 20:36]
    node _GEN_147 = mux(_T, _GEN_83, _GEN_115) @[Reg_Unit.scala 20:36]
    node _GEN_148 = mux(_T, _GEN_84, _GEN_116) @[Reg_Unit.scala 20:36]
    node _GEN_149 = mux(_T, _GEN_85, _GEN_117) @[Reg_Unit.scala 20:36]
    node _GEN_150 = mux(_T, _GEN_86, _GEN_118) @[Reg_Unit.scala 20:36]
    node _GEN_151 = mux(_T, _GEN_87, _GEN_119) @[Reg_Unit.scala 20:36]
    node _GEN_152 = mux(_T, _GEN_88, _GEN_120) @[Reg_Unit.scala 20:36]
    node _GEN_153 = mux(_T, _GEN_89, _GEN_121) @[Reg_Unit.scala 20:36]
    node _GEN_154 = mux(_T, _GEN_90, _GEN_122) @[Reg_Unit.scala 20:36]
    node _GEN_155 = mux(_T, _GEN_91, _GEN_123) @[Reg_Unit.scala 20:36]
    node _GEN_156 = mux(_T, _GEN_92, _GEN_124) @[Reg_Unit.scala 20:36]
    node _GEN_157 = mux(_T, _GEN_93, _GEN_125) @[Reg_Unit.scala 20:36]
    node _GEN_158 = mux(_T, _GEN_94, _GEN_126) @[Reg_Unit.scala 20:36]
    node _GEN_159 = mux(_T, _GEN_95, _GEN_127) @[Reg_Unit.scala 20:36]
    node _register_WIRE_0 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_1 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_2 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_3 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_4 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_5 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_6 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_7 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_8 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_9 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_10 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_11 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_12 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_13 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_14 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_15 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_16 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_17 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_18 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_19 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_20 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_21 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_22 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_23 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_24 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_25 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_26 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_27 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_28 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_29 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_30 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_WIRE_31 = asSInt(UInt<32>("h0")) @[Reg_Unit.scala 16:35 Reg_Unit.scala 16:35]
    node _register_io_rs1_addr = _GEN_31 @[Reg_Unit.scala 18:12]
    node _register_io_rs2_addr = _GEN_63 @[Reg_Unit.scala 19:12]
    io_rs1 <= _register_io_rs1_addr @[Reg_Unit.scala 18:12]
    io_rs2 <= _register_io_rs2_addr @[Reg_Unit.scala 19:12]
    register_0 <= mux(reset, _register_WIRE_0, _GEN_128) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_1 <= mux(reset, _register_WIRE_1, _GEN_129) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_2 <= mux(reset, _register_WIRE_2, _GEN_130) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_3 <= mux(reset, _register_WIRE_3, _GEN_131) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_4 <= mux(reset, _register_WIRE_4, _GEN_132) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_5 <= mux(reset, _register_WIRE_5, _GEN_133) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_6 <= mux(reset, _register_WIRE_6, _GEN_134) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_7 <= mux(reset, _register_WIRE_7, _GEN_135) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_8 <= mux(reset, _register_WIRE_8, _GEN_136) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_9 <= mux(reset, _register_WIRE_9, _GEN_137) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_10 <= mux(reset, _register_WIRE_10, _GEN_138) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_11 <= mux(reset, _register_WIRE_11, _GEN_139) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_12 <= mux(reset, _register_WIRE_12, _GEN_140) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_13 <= mux(reset, _register_WIRE_13, _GEN_141) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_14 <= mux(reset, _register_WIRE_14, _GEN_142) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_15 <= mux(reset, _register_WIRE_15, _GEN_143) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_16 <= mux(reset, _register_WIRE_16, _GEN_144) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_17 <= mux(reset, _register_WIRE_17, _GEN_145) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_18 <= mux(reset, _register_WIRE_18, _GEN_146) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_19 <= mux(reset, _register_WIRE_19, _GEN_147) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_20 <= mux(reset, _register_WIRE_20, _GEN_148) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_21 <= mux(reset, _register_WIRE_21, _GEN_149) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_22 <= mux(reset, _register_WIRE_22, _GEN_150) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_23 <= mux(reset, _register_WIRE_23, _GEN_151) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_24 <= mux(reset, _register_WIRE_24, _GEN_152) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_25 <= mux(reset, _register_WIRE_25, _GEN_153) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_26 <= mux(reset, _register_WIRE_26, _GEN_154) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_27 <= mux(reset, _register_WIRE_27, _GEN_155) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_28 <= mux(reset, _register_WIRE_28, _GEN_156) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_29 <= mux(reset, _register_WIRE_29, _GEN_157) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_30 <= mux(reset, _register_WIRE_30, _GEN_158) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]
    register_31 <= mux(reset, _register_WIRE_31, _GEN_159) @[Reg_Unit.scala 16:27 Reg_Unit.scala 16:27]

  module branchControl :
    input clock : Clock
    input reset : UInt<1>
    input io_in_A : SInt<32>
    input io_in_B : SInt<32>
    input io_br_func3 : UInt<3>
    output io_branch_out : UInt<1>

    node _T = eq(UInt<3>("h0"), io_br_func3) @[Conditional.scala 37:30]
    node _T_1 = eq(io_in_A, io_in_B) @[branchControl.scala 23:27]
    node _GEN_0 = mux(_T_1, UInt<1>("h1"), UInt<1>("h0")) @[branchControl.scala 23:39 branchControl.scala 24:31 branchControl.scala 26:31]
    node _T_2 = eq(UInt<3>("h1"), io_br_func3) @[Conditional.scala 37:30]
    node _T_3 = neq(io_in_A, io_in_B) @[branchControl.scala 30:27]
    node _GEN_1 = mux(_T_3, UInt<1>("h1"), UInt<1>("h0")) @[branchControl.scala 30:39 branchControl.scala 31:31 branchControl.scala 33:31]
    node _T_4 = eq(UInt<3>("h4"), io_br_func3) @[Conditional.scala 37:30]
    node _T_5 = lt(io_in_A, io_in_B) @[branchControl.scala 37:27]
    node _GEN_2 = mux(_T_5, UInt<1>("h1"), UInt<1>("h0")) @[branchControl.scala 37:37 branchControl.scala 38:31 branchControl.scala 40:31]
    node _T_6 = eq(UInt<3>("h5"), io_br_func3) @[Conditional.scala 37:30]
    node _T_7 = gt(io_in_A, io_in_B) @[branchControl.scala 44:26]
    node _GEN_3 = mux(_T_7, UInt<1>("h1"), UInt<1>("h0")) @[branchControl.scala 44:36 branchControl.scala 45:31 branchControl.scala 47:31]
    node _GEN_4 = mux(_T_6, _GEN_3, UInt<1>("h0")) @[Conditional.scala 39:67 branchControl.scala 20:19]
    node _GEN_5 = mux(_T_4, _GEN_2, _GEN_4) @[Conditional.scala 39:67]
    node _GEN_6 = mux(_T_2, _GEN_1, _GEN_5) @[Conditional.scala 39:67]
    node _GEN_7 = mux(_T, _GEN_0, _GEN_6) @[Conditional.scala 40:58]
    io_branch_out <= _GEN_7

  module jalr :
    input clock : Clock
    input reset : UInt<1>
    input io_rs1 : UInt<32>
    input io_imm : UInt<32>
    output io_pcVal : UInt<32>

    node _sum_T = add(io_rs1, io_imm) @[jalr.scala 12:31]
    node _sum_T_1 = tail(_sum_T, 1) @[jalr.scala 12:31]
    node sum = _sum_T_1
    node _io_pcVal_T = and(sum, UInt<32>("hfffffffe")) @[jalr.scala 13:21]
    io_pcVal <= _io_pcVal_T @[jalr.scala 13:14]

  module pipelining_top :
    input clock : Clock
    input reset : UInt<1>
    output io_out : UInt<32>

    inst pC_mod of pC @[Pipe_Top_File.scala 13:24]
    inst instrMem_mod of instrMem @[Pipe_Top_File.scala 15:30]
    inst frwdunit_mod of frwdUnit @[Pipe_Top_File.scala 17:30]
    inst branch_frwd_mod of decode_frwd @[Pipe_Top_File.scala 19:33]
    inst strc_detect_mod of structuralDetector @[Pipe_Top_File.scala 21:33]
    inst hazardDetection_mod of hazardDetection @[Pipe_Top_File.scala 23:37]
    inst if_id_mod of if_id @[Pipe_Top_File.scala 25:27]
    inst id_ex_mod of id_ex @[Pipe_Top_File.scala 27:27]
    inst ex_mem_mod of ex_mem @[Pipe_Top_File.scala 29:28]
    inst mem_wr_mod of mem_wr @[Pipe_Top_File.scala 31:28]
    inst dataMem_mod of dataMemory @[Pipe_Top_File.scala 33:29]
    inst control_mod of control @[Pipe_Top_File.scala 35:29]
    inst immdGen_mod of immdValGen @[Pipe_Top_File.scala 37:29]
    inst aluControl_mod of aluControl @[Pipe_Top_File.scala 39:32]
    inst alu_mod of ALU @[Pipe_Top_File.scala 41:25]
    inst regFile_mod of regFile @[Pipe_Top_File.scala 43:29]
    inst brControl_mod of branchControl @[Pipe_Top_File.scala 45:31]
    inst jalr_mod of jalr @[Pipe_Top_File.scala 47:26]
    node _instrMem_mod_io_addr_T = bits(pC_mod.io_out, 21, 2) @[Pipe_Top_File.scala 52:42]
    node _control_mod_io_op_code_T = bits(if_id_mod.io_inst_out, 6, 0) @[Pipe_Top_File.scala 59:52]
    node _imm_mux_T = eq(UInt<1>("h1"), control_mod.io_extend_Sel) @[Mux.scala 80:60]
    node _imm_mux_T_1 = mux(_imm_mux_T, immdGen_mod.io_s_imm, immdGen_mod.io_i_imm) @[Mux.scala 80:57]
    node _imm_mux_T_2 = eq(UInt<2>("h2"), control_mod.io_extend_Sel) @[Mux.scala 80:60]
    node _imm_mux_T_3 = mux(_imm_mux_T_2, immdGen_mod.io_u_imm, _imm_mux_T_1) @[Mux.scala 80:57]
    node _imm_mux_T_4 = eq(UInt<2>("h3"), control_mod.io_extend_Sel) @[Mux.scala 80:60]
    node imm_mux = mux(_imm_mux_T_4, asSInt(UInt<1>("h0")), _imm_mux_T_3) @[Mux.scala 80:57]
    node _regFile_mod_io_rs1_addr_T = bits(if_id_mod.io_inst_out, 19, 15) @[Pipe_Top_File.scala 72:53]
    node _regFile_mod_io_rs2_addr_T = bits(if_id_mod.io_inst_out, 24, 20) @[Pipe_Top_File.scala 73:53]
    node _readData1Mux_T = eq(UInt<1>("h1"), control_mod.io_operand_A) @[Mux.scala 80:60]
    node _readData1Mux_T_1 = mux(_readData1Mux_T, if_id_mod.io_pc4_out, regFile_mod.io_rs1) @[Mux.scala 80:57]
    node _readData1Mux_T_2 = eq(UInt<2>("h2"), control_mod.io_operand_A) @[Mux.scala 80:60]
    node _readData1Mux_T_3 = mux(_readData1Mux_T_2, if_id_mod.io_pc_out, _readData1Mux_T_1) @[Mux.scala 80:57]
    node _readData1Mux_T_4 = eq(UInt<2>("h3"), control_mod.io_operand_A) @[Mux.scala 80:60]
    node readData1Mux = mux(_readData1Mux_T_4, regFile_mod.io_rs1, _readData1Mux_T_3) @[Mux.scala 80:57]
    node _readData2Mux_T = bits(control_mod.io_operand_B, 0, 0) @[Pipe_Top_File.scala 83:59]
    node readData2Mux = mux(_readData2Mux_T, imm_mux, regFile_mod.io_rs2) @[Pipe_Top_File.scala 83:27]
    node _strc_detect_mod_io_rs1Addr_T = bits(if_id_mod.io_inst_out, 19, 15) @[Pipe_Top_File.scala 86:56]
    node _strc_detect_mod_io_rs2Addr_T = bits(if_id_mod.io_inst_out, 24, 20) @[Pipe_Top_File.scala 87:56]
    node _strc_fA_mux_T = bits(strc_detect_mod.io_frwd_A, 0, 0) @[Pipe_Top_File.scala 91:59]
    node strc_fA_mux = mux(_strc_fA_mux_T, mem_wr_mod.io_aluOut_out, readData1Mux) @[Pipe_Top_File.scala 91:26]
    node _strc_fB_mux_T = bits(strc_detect_mod.io_frwd_B, 0, 0) @[Pipe_Top_File.scala 95:59]
    node strc_fB_mux = mux(_strc_fB_mux_T, mem_wr_mod.io_aluOut_out, readData2Mux) @[Pipe_Top_File.scala 95:26]
    node _brControl_mod_io_br_func3_T = bits(if_id_mod.io_inst_out, 14, 12) @[Pipe_Top_File.scala 109:55]
    node _id_ex_mod_io_in_func3_T = bits(if_id_mod.io_inst_out, 14, 12) @[Pipe_Top_File.scala 117:51]
    node _id_ex_mod_io_in_func7_T = bits(if_id_mod.io_inst_out, 31, 25) @[Pipe_Top_File.scala 118:51]
    node _id_ex_mod_io_in_Rdaddr_T = bits(if_id_mod.io_inst_out, 11, 7) @[Pipe_Top_File.scala 120:52]
    node _dataMem_mod_io_rdAddr_T = bits(ex_mem_mod.io_ALUout_out, 11, 2) @[Pipe_Top_File.scala 153:54]
    node _dataMem_mux_T = bits(mem_wr_mod.io_c_memtoreg_out, 0, 0) @[Pipe_Top_File.scala 166:62]
    node dataMem_mux = mux(_dataMem_mux_T, mem_wr_mod.io_dataOut_out, mem_wr_mod.io_aluOut_out) @[Pipe_Top_File.scala 166:26]
    node _jalr_mod_io_rs1_T = asUInt(readData1Mux) @[Pipe_Top_File.scala 171:43]
    node _jalr_mod_io_imm_T = asUInt(imm_mux) @[Pipe_Top_File.scala 172:38]
    node _T = eq(id_ex_mod.io_c_operand_A_out, UInt<2>("h2")) @[Pipe_Top_File.scala 195:39]
    node _T_1 = eq(frwdunit_mod.io_frwdA, UInt<1>("h0")) @[Pipe_Top_File.scala 198:36]
    node _T_2 = eq(frwdunit_mod.io_frwdA, UInt<1>("h1")) @[Pipe_Top_File.scala 200:42]
    node _T_3 = eq(frwdunit_mod.io_frwdA, UInt<2>("h2")) @[Pipe_Top_File.scala 202:42]
    node _GEN_0 = mux(_T_3, regFile_mod.io_writeData, id_ex_mod.io_rs1_out) @[Pipe_Top_File.scala 202:54 Pipe_Top_File.scala 203:29 Pipe_Top_File.scala 205:29]
    node _GEN_1 = mux(_T_2, ex_mem_mod.io_ALUout_out, _GEN_0) @[Pipe_Top_File.scala 200:54 Pipe_Top_File.scala 201:29]
    node _GEN_2 = mux(_T_1, id_ex_mod.io_rs1_out, _GEN_1) @[Pipe_Top_File.scala 198:48 Pipe_Top_File.scala 199:29]
    node _GEN_3 = mux(_T, id_ex_mod.io_pc4_out, _GEN_2) @[Pipe_Top_File.scala 195:51 Pipe_Top_File.scala 196:25]
    node _T_4 = eq(id_ex_mod.io_c_operand_B_out, UInt<1>("h1")) @[Pipe_Top_File.scala 209:39]
    node _T_5 = eq(frwdunit_mod.io_frwdB, UInt<1>("h0")) @[Pipe_Top_File.scala 211:36]
    node _T_6 = eq(frwdunit_mod.io_frwdB, UInt<1>("h1")) @[Pipe_Top_File.scala 213:42]
    node _T_7 = eq(frwdunit_mod.io_frwdB, UInt<2>("h2")) @[Pipe_Top_File.scala 215:42]
    node _GEN_4 = mux(_T_7, regFile_mod.io_writeData, id_ex_mod.io_rs2_out) @[Pipe_Top_File.scala 215:55 Pipe_Top_File.scala 216:34 Pipe_Top_File.scala 218:34]
    node _GEN_5 = mux(_T_6, ex_mem_mod.io_ALUout_out, _GEN_4) @[Pipe_Top_File.scala 213:55 Pipe_Top_File.scala 214:34]
    node _GEN_6 = mux(_T_5, id_ex_mod.io_rs2_out, _GEN_5) @[Pipe_Top_File.scala 211:48 Pipe_Top_File.scala 212:34]
    node _T_8 = eq(frwdunit_mod.io_frwdB, UInt<1>("h0")) @[Pipe_Top_File.scala 221:36]
    node _T_9 = eq(frwdunit_mod.io_frwdB, UInt<1>("h1")) @[Pipe_Top_File.scala 224:38]
    node _T_10 = eq(frwdunit_mod.io_frwdB, UInt<2>("h2")) @[Pipe_Top_File.scala 227:38]
    node _GEN_7 = mux(_T_10, regFile_mod.io_writeData, id_ex_mod.io_rs2_out) @[Pipe_Top_File.scala 227:50 Pipe_Top_File.scala 228:25 Pipe_Top_File.scala 231:25]
    node _GEN_8 = mux(_T_9, ex_mem_mod.io_ALUout_out, _GEN_7) @[Pipe_Top_File.scala 224:50 Pipe_Top_File.scala 225:25]
    node _GEN_9 = mux(_T_8, id_ex_mod.io_rs2_out, _GEN_8) @[Pipe_Top_File.scala 221:48 Pipe_Top_File.scala 222:25]
    node _GEN_10 = mux(_T_4, id_ex_mod.io_imm_out, _GEN_9) @[Pipe_Top_File.scala 209:50 Pipe_Top_File.scala 210:25]
    node _GEN_11 = mux(_T_4, _GEN_6, _GEN_9) @[Pipe_Top_File.scala 209:50]
    node _T_11 = eq(hazardDetection_mod.io_inst_frwd, UInt<1>("h1")) @[Pipe_Top_File.scala 244:43]
    node _GEN_12 = mux(_T_11, hazardDetection_mod.io_if_id_inst_out, instrMem_mod.io_instr) @[Pipe_Top_File.scala 244:55 Pipe_Top_File.scala 245:30 Pipe_Top_File.scala 248:30]
    node _GEN_13 = mux(_T_11, hazardDetection_mod.io_pc_out, pC_mod.io_out) @[Pipe_Top_File.scala 244:55 Pipe_Top_File.scala 246:28 Pipe_Top_File.scala 55:24]
    node _T_12 = eq(hazardDetection_mod.io_pc_frwd, UInt<1>("h1")) @[Pipe_Top_File.scala 251:41]
    node _T_13 = eq(control_mod.io_nextPc_Sel, UInt<1>("h1")) @[Pipe_Top_File.scala 254:36]
    node _T_14 = eq(brControl_mod.io_branch_out, UInt<1>("h1")) @[Pipe_Top_File.scala 255:42]
    node _T_15 = eq(control_mod.io_branch, UInt<1>("h1")) @[Pipe_Top_File.scala 255:75]
    node _T_16 = and(_T_14, _T_15) @[Pipe_Top_File.scala 255:50]
    node _GEN_14 = mux(_T_16, immdGen_mod.io_sb_imm, pC_mod.io_pc4) @[Pipe_Top_File.scala 255:84 Pipe_Top_File.scala 256:26 Pipe_Top_File.scala 261:26]
    node _GEN_15 = mux(_T_16, asSInt(UInt<1>("h0")), _GEN_13) @[Pipe_Top_File.scala 255:84 Pipe_Top_File.scala 258:32]
    node _GEN_16 = mux(_T_16, UInt<1>("h0"), _GEN_12) @[Pipe_Top_File.scala 255:84 Pipe_Top_File.scala 259:34]
    node _T_17 = eq(control_mod.io_nextPc_Sel, UInt<2>("h2")) @[Pipe_Top_File.scala 263:42]
    node _GEN_17 = mux(_T_17, immdGen_mod.io_uj_imm, pC_mod.io_pc4) @[Pipe_Top_File.scala 263:55 Pipe_Top_File.scala 264:20 Pipe_Top_File.scala 268:20]
    node _GEN_18 = mux(_T_17, asSInt(UInt<1>("h0")), pC_mod.io_pc4) @[Pipe_Top_File.scala 263:55 Pipe_Top_File.scala 265:27 Pipe_Top_File.scala 56:25]
    node _GEN_19 = mux(_T_17, UInt<1>("h0"), _GEN_12) @[Pipe_Top_File.scala 263:55 Pipe_Top_File.scala 266:28]
    node _GEN_20 = mux(_T_13, _GEN_14, _GEN_17) @[Pipe_Top_File.scala 254:49]
    node _GEN_21 = mux(_T_13, _GEN_15, _GEN_13) @[Pipe_Top_File.scala 254:49]
    node _GEN_22 = mux(_T_13, _GEN_16, _GEN_19) @[Pipe_Top_File.scala 254:49]
    node _GEN_23 = mux(_T_13, pC_mod.io_pc4, _GEN_18) @[Pipe_Top_File.scala 254:49 Pipe_Top_File.scala 56:25]
    node _GEN_24 = mux(_T_12, hazardDetection_mod.io_pc_out, _GEN_20) @[Pipe_Top_File.scala 251:53 Pipe_Top_File.scala 252:22]
    node _GEN_25 = mux(_T_12, _GEN_13, _GEN_21) @[Pipe_Top_File.scala 251:53]
    node _GEN_26 = mux(_T_12, _GEN_12, _GEN_22) @[Pipe_Top_File.scala 251:53]
    node _GEN_27 = mux(_T_12, pC_mod.io_pc4, _GEN_23) @[Pipe_Top_File.scala 251:53 Pipe_Top_File.scala 56:25]
    node _T_18 = eq(hazardDetection_mod.io_ctrl_frwd, UInt<1>("h1")) @[Pipe_Top_File.scala 271:43]
    node _GEN_28 = mux(_T_18, UInt<1>("h0"), control_mod.io_memWrite) @[Pipe_Top_File.scala 271:55 Pipe_Top_File.scala 272:36 Pipe_Top_File.scala 282:36]
    node _GEN_29 = mux(_T_18, UInt<1>("h0"), control_mod.io_memRead) @[Pipe_Top_File.scala 271:55 Pipe_Top_File.scala 273:35 Pipe_Top_File.scala 283:35]
    node _GEN_30 = mux(_T_18, UInt<1>("h0"), control_mod.io_branch) @[Pipe_Top_File.scala 271:55 Pipe_Top_File.scala 274:34 Pipe_Top_File.scala 284:34]
    node _GEN_31 = mux(_T_18, UInt<1>("h0"), control_mod.io_regWrite) @[Pipe_Top_File.scala 271:55 Pipe_Top_File.scala 275:36 Pipe_Top_File.scala 285:36]
    node _GEN_32 = mux(_T_18, UInt<1>("h0"), control_mod.io_memToReg) @[Pipe_Top_File.scala 271:55 Pipe_Top_File.scala 276:36 Pipe_Top_File.scala 286:36]
    node _GEN_33 = mux(_T_18, UInt<1>("h0"), control_mod.io_alu_Operation) @[Pipe_Top_File.scala 271:55 Pipe_Top_File.scala 277:41 Pipe_Top_File.scala 287:41]
    node _GEN_34 = mux(_T_18, UInt<1>("h0"), control_mod.io_operand_A) @[Pipe_Top_File.scala 271:55 Pipe_Top_File.scala 278:37 Pipe_Top_File.scala 288:37]
    node _GEN_35 = mux(_T_18, UInt<1>("h0"), control_mod.io_operand_B) @[Pipe_Top_File.scala 271:55 Pipe_Top_File.scala 279:37 Pipe_Top_File.scala 289:37]
    node _GEN_36 = mux(_T_18, UInt<1>("h0"), control_mod.io_nextPc_Sel) @[Pipe_Top_File.scala 271:55 Pipe_Top_File.scala 280:34 Pipe_Top_File.scala 290:34]
    node _branch_frwd_mod_io_rs1Addr_T = bits(if_id_mod.io_inst_out, 19, 15) @[Pipe_Top_File.scala 300:56]
    node _branch_frwd_mod_io_rs2Addr_T = bits(if_id_mod.io_inst_out, 24, 20) @[Pipe_Top_File.scala 301:56]
    node _T_19 = eq(branch_frwd_mod.io_frwd_A, UInt<1>("h0")) @[Pipe_Top_File.scala 305:36]
    node _jalr_mod_io_rs1_T_1 = asUInt(regFile_mod.io_rs1) @[Pipe_Top_File.scala 307:53]
    node _T_20 = eq(branch_frwd_mod.io_frwd_A, UInt<1>("h1")) @[Pipe_Top_File.scala 308:42]
    node _jalr_mod_io_rs1_T_2 = asUInt(regFile_mod.io_rs1) @[Pipe_Top_File.scala 310:53]
    node _T_21 = eq(branch_frwd_mod.io_frwd_A, UInt<2>("h2")) @[Pipe_Top_File.scala 311:42]
    node _jalr_mod_io_rs1_T_3 = asUInt(regFile_mod.io_rs1) @[Pipe_Top_File.scala 313:53]
    node _T_22 = eq(branch_frwd_mod.io_frwd_A, UInt<2>("h3")) @[Pipe_Top_File.scala 314:42]
    node _jalr_mod_io_rs1_T_4 = asUInt(regFile_mod.io_rs1) @[Pipe_Top_File.scala 316:53]
    node _T_23 = eq(branch_frwd_mod.io_frwd_A, UInt<3>("h4")) @[Pipe_Top_File.scala 317:42]
    node _jalr_mod_io_rs1_T_5 = asUInt(regFile_mod.io_rs1) @[Pipe_Top_File.scala 319:53]
    node _T_24 = eq(branch_frwd_mod.io_frwd_A, UInt<3>("h5")) @[Pipe_Top_File.scala 320:42]
    node _jalr_mod_io_rs1_T_6 = asUInt(regFile_mod.io_rs1) @[Pipe_Top_File.scala 322:53]
    node _T_25 = eq(branch_frwd_mod.io_frwd_A, UInt<3>("h6")) @[Pipe_Top_File.scala 323:42]
    node _jalr_mod_io_rs1_T_7 = asUInt(alu_mod.io_out) @[Pipe_Top_File.scala 324:49]
    node _T_26 = eq(branch_frwd_mod.io_frwd_A, UInt<3>("h7")) @[Pipe_Top_File.scala 326:42]
    node _jalr_mod_io_rs1_T_8 = asUInt(ex_mem_mod.io_ALUout_out) @[Pipe_Top_File.scala 327:59]
    node _T_27 = eq(branch_frwd_mod.io_frwd_A, UInt<4>("h8")) @[Pipe_Top_File.scala 329:42]
    node _jalr_mod_io_rs1_T_9 = asUInt(regFile_mod.io_writeData) @[Pipe_Top_File.scala 330:59]
    node _T_28 = eq(branch_frwd_mod.io_frwd_A, UInt<4>("h9")) @[Pipe_Top_File.scala 332:42]
    node _jalr_mod_io_rs1_T_10 = asUInt(dataMem_mod.io_dataOut) @[Pipe_Top_File.scala 333:57]
    node _T_29 = eq(branch_frwd_mod.io_frwd_A, UInt<4>("ha")) @[Pipe_Top_File.scala 335:42]
    node _jalr_mod_io_rs1_T_11 = asUInt(regFile_mod.io_writeData) @[Pipe_Top_File.scala 336:59]
    node _jalr_mod_io_rs1_T_12 = asUInt(regFile_mod.io_rs1) @[Pipe_Top_File.scala 340:53]
    node _GEN_37 = mux(_T_29, _jalr_mod_io_rs1_T_11, _jalr_mod_io_rs1_T_12) @[Pipe_Top_File.scala 335:56 Pipe_Top_File.scala 336:25 Pipe_Top_File.scala 340:25]
    node _GEN_38 = mux(_T_29, regFile_mod.io_rs1, regFile_mod.io_rs1) @[Pipe_Top_File.scala 335:56 Pipe_Top_File.scala 337:31 Pipe_Top_File.scala 339:31]
    node _GEN_39 = mux(_T_28, _jalr_mod_io_rs1_T_10, _GEN_37) @[Pipe_Top_File.scala 332:56 Pipe_Top_File.scala 333:25]
    node _GEN_40 = mux(_T_28, regFile_mod.io_rs1, _GEN_38) @[Pipe_Top_File.scala 332:56 Pipe_Top_File.scala 334:31]
    node _GEN_41 = mux(_T_27, _jalr_mod_io_rs1_T_9, _GEN_39) @[Pipe_Top_File.scala 329:56 Pipe_Top_File.scala 330:25]
    node _GEN_42 = mux(_T_27, regFile_mod.io_rs1, _GEN_40) @[Pipe_Top_File.scala 329:56 Pipe_Top_File.scala 331:31]
    node _GEN_43 = mux(_T_26, _jalr_mod_io_rs1_T_8, _GEN_41) @[Pipe_Top_File.scala 326:56 Pipe_Top_File.scala 327:25]
    node _GEN_44 = mux(_T_26, regFile_mod.io_rs1, _GEN_42) @[Pipe_Top_File.scala 326:56 Pipe_Top_File.scala 328:31]
    node _GEN_45 = mux(_T_25, _jalr_mod_io_rs1_T_7, _GEN_43) @[Pipe_Top_File.scala 323:56 Pipe_Top_File.scala 324:25]
    node _GEN_46 = mux(_T_25, regFile_mod.io_rs1, _GEN_44) @[Pipe_Top_File.scala 323:56 Pipe_Top_File.scala 325:31]
    node _GEN_47 = mux(_T_24, regFile_mod.io_writeData, _GEN_46) @[Pipe_Top_File.scala 320:56 Pipe_Top_File.scala 321:31]
    node _GEN_48 = mux(_T_24, _jalr_mod_io_rs1_T_6, _GEN_45) @[Pipe_Top_File.scala 320:56 Pipe_Top_File.scala 322:25]
    node _GEN_49 = mux(_T_23, dataMem_mod.io_dataOut, _GEN_47) @[Pipe_Top_File.scala 317:56 Pipe_Top_File.scala 318:31]
    node _GEN_50 = mux(_T_23, _jalr_mod_io_rs1_T_5, _GEN_48) @[Pipe_Top_File.scala 317:56 Pipe_Top_File.scala 319:25]
    node _GEN_51 = mux(_T_22, regFile_mod.io_writeData, _GEN_49) @[Pipe_Top_File.scala 314:56 Pipe_Top_File.scala 315:31]
    node _GEN_52 = mux(_T_22, _jalr_mod_io_rs1_T_4, _GEN_50) @[Pipe_Top_File.scala 314:56 Pipe_Top_File.scala 316:25]
    node _GEN_53 = mux(_T_21, ex_mem_mod.io_ALUout_out, _GEN_51) @[Pipe_Top_File.scala 311:56 Pipe_Top_File.scala 312:31]
    node _GEN_54 = mux(_T_21, _jalr_mod_io_rs1_T_3, _GEN_52) @[Pipe_Top_File.scala 311:56 Pipe_Top_File.scala 313:25]
    node _GEN_55 = mux(_T_20, alu_mod.io_out, _GEN_53) @[Pipe_Top_File.scala 308:56 Pipe_Top_File.scala 309:31]
    node _GEN_56 = mux(_T_20, _jalr_mod_io_rs1_T_2, _GEN_54) @[Pipe_Top_File.scala 308:56 Pipe_Top_File.scala 310:25]
    node _GEN_57 = mux(_T_19, regFile_mod.io_rs1, _GEN_55) @[Pipe_Top_File.scala 305:50 Pipe_Top_File.scala 306:31]
    node _GEN_58 = mux(_T_19, _jalr_mod_io_rs1_T_1, _GEN_56) @[Pipe_Top_File.scala 305:50 Pipe_Top_File.scala 307:25]
    node _branch_frwdB_mux_T = eq(UInt<1>("h0"), branch_frwd_mod.io_frwd_B) @[Mux.scala 80:60]
    node _branch_frwdB_mux_T_1 = mux(_branch_frwdB_mux_T, regFile_mod.io_rs2, asSInt(UInt<1>("h0"))) @[Mux.scala 80:57]
    node _branch_frwdB_mux_T_2 = eq(UInt<1>("h1"), branch_frwd_mod.io_frwd_B) @[Mux.scala 80:60]
    node _branch_frwdB_mux_T_3 = mux(_branch_frwdB_mux_T_2, alu_mod.io_out, _branch_frwdB_mux_T_1) @[Mux.scala 80:57]
    node _branch_frwdB_mux_T_4 = eq(UInt<2>("h2"), branch_frwd_mod.io_frwd_B) @[Mux.scala 80:60]
    node _branch_frwdB_mux_T_5 = mux(_branch_frwdB_mux_T_4, ex_mem_mod.io_ALUout_out, _branch_frwdB_mux_T_3) @[Mux.scala 80:57]
    node _branch_frwdB_mux_T_6 = eq(UInt<2>("h3"), branch_frwd_mod.io_frwd_B) @[Mux.scala 80:60]
    node _branch_frwdB_mux_T_7 = mux(_branch_frwdB_mux_T_6, dataMem_mux, _branch_frwdB_mux_T_5) @[Mux.scala 80:57]
    node _branch_frwdB_mux_T_8 = eq(UInt<3>("h4"), branch_frwd_mod.io_frwd_B) @[Mux.scala 80:60]
    node _branch_frwdB_mux_T_9 = mux(_branch_frwdB_mux_T_8, dataMem_mod.io_dataOut, _branch_frwdB_mux_T_7) @[Mux.scala 80:57]
    node _branch_frwdB_mux_T_10 = eq(UInt<3>("h5"), branch_frwd_mod.io_frwd_B) @[Mux.scala 80:60]
    node branch_frwdB_mux = mux(_branch_frwdB_mux_T_10, dataMem_mux, _branch_frwdB_mux_T_9) @[Mux.scala 80:57]
    io_out <= instrMem_mod.io_instr @[Pipe_Top_File.scala 364:12]
    pC_mod.clock <= clock
    pC_mod.reset <= reset
    pC_mod.io_in <= _GEN_24
    instrMem_mod.clock <= clock
    instrMem_mod.reset <= reset
    instrMem_mod.io_addr <= _instrMem_mod_io_addr_T @[Pipe_Top_File.scala 52:26]
    frwdunit_mod.clock <= clock
    frwdunit_mod.reset <= reset
    frwdunit_mod.io_exMem_reg_write <= ex_mem_mod.io_reg_write_out @[Pipe_Top_File.scala 187:37]
    frwdunit_mod.io_memWb_reg_write <= mem_wr_mod.io_c_regWrite_out @[Pipe_Top_File.scala 188:37]
    frwdunit_mod.io_mem_wb_rdAddr <= mem_wr_mod.io_Rdaddr_out @[Pipe_Top_File.scala 190:35]
    frwdunit_mod.io_ex_mem_rdAddr <= ex_mem_mod.io_rdaddr_out @[Pipe_Top_File.scala 189:35]
    frwdunit_mod.io_id_ex_rs1Addr <= id_ex_mod.io_rs1Addr_out @[Pipe_Top_File.scala 191:35]
    frwdunit_mod.io_id_ex_rs2Addr <= id_ex_mod.io_rs2Addr_out @[Pipe_Top_File.scala 192:35]
    branch_frwd_mod.clock <= clock
    branch_frwd_mod.reset <= reset
    branch_frwd_mod.io_id_ex_rdAddr <= id_ex_mod.io_rdaddr_out @[Pipe_Top_File.scala 294:37]
    branch_frwd_mod.io_id_ex_memRead <= id_ex_mod.io_c_memRead_out @[Pipe_Top_File.scala 295:38]
    branch_frwd_mod.io_ex_mem_rdAddr <= ex_mem_mod.io_rdaddr_out @[Pipe_Top_File.scala 296:38]
    branch_frwd_mod.io_ex_mem_memRead <= ex_mem_mod.io_memrd_out @[Pipe_Top_File.scala 298:39]
    branch_frwd_mod.io_mem_wr_rdAddr <= mem_wr_mod.io_Rdaddr_out @[Pipe_Top_File.scala 297:38]
    branch_frwd_mod.io_mem_wr_memRead <= mem_wr_mod.io_c_memRead_out @[Pipe_Top_File.scala 299:39]
    branch_frwd_mod.io_rs1Addr <= _branch_frwd_mod_io_rs1Addr_T @[Pipe_Top_File.scala 300:32]
    branch_frwd_mod.io_rs2Addr <= _branch_frwd_mod_io_rs2Addr_T @[Pipe_Top_File.scala 301:32]
    branch_frwd_mod.io_c_branch <= control_mod.io_branch @[Pipe_Top_File.scala 302:33]
    strc_detect_mod.clock <= clock
    strc_detect_mod.reset <= reset
    strc_detect_mod.io_rs1Addr <= _strc_detect_mod_io_rs1Addr_T @[Pipe_Top_File.scala 86:32]
    strc_detect_mod.io_rs2Addr <= _strc_detect_mod_io_rs2Addr_T @[Pipe_Top_File.scala 87:32]
    strc_detect_mod.io_mem_wb_regWr <= mem_wr_mod.io_c_regWrite_out @[Pipe_Top_File.scala 89:37]
    strc_detect_mod.io_mem_wb_rdAddr <= mem_wr_mod.io_Rdaddr_out @[Pipe_Top_File.scala 88:38]
    hazardDetection_mod.clock <= clock
    hazardDetection_mod.reset <= reset
    hazardDetection_mod.io_id_ex_memRead <= id_ex_mod.io_c_memRead_out @[Pipe_Top_File.scala 238:42]
    hazardDetection_mod.io_id_ex_rdAddr <= id_ex_mod.io_rdaddr_out @[Pipe_Top_File.scala 239:41]
    hazardDetection_mod.io_if_id_in_inst <= if_id_mod.io_inst_out @[Pipe_Top_File.scala 240:42]
    hazardDetection_mod.io_in_pc <= if_id_mod.io_pc_out @[Pipe_Top_File.scala 241:34]
    hazardDetection_mod.io_in_pc4 <= if_id_mod.io_pc4_out @[Pipe_Top_File.scala 242:35]
    if_id_mod.clock <= clock
    if_id_mod.reset <= reset
    if_id_mod.io_in_pc <= _GEN_25
    if_id_mod.io_in_pc4 <= _GEN_27
    if_id_mod.io_in_inst <= _GEN_26
    id_ex_mod.clock <= clock
    id_ex_mod.reset <= reset
    id_ex_mod.io_in_c_memWrite <= _GEN_28
    id_ex_mod.io_in_c_branch <= _GEN_30
    id_ex_mod.io_in_c_memRead <= _GEN_29
    id_ex_mod.io_in_c_regWrite <= _GEN_31
    id_ex_mod.io_in_c_memToReg <= _GEN_32
    id_ex_mod.io_in_c_alu_Operation <= _GEN_33
    id_ex_mod.io_in_c_operand_A <= _GEN_34
    id_ex_mod.io_in_c_operand_B <= _GEN_35
    id_ex_mod.io_in_c_nextPc <= _GEN_36
    id_ex_mod.io_in_pc <= if_id_mod.io_pc_out @[Pipe_Top_File.scala 112:24]
    id_ex_mod.io_in_pc4 <= if_id_mod.io_pc4_out @[Pipe_Top_File.scala 113:25]
    id_ex_mod.io_in_imm <= imm_mux @[Pipe_Top_File.scala 119:25]
    id_ex_mod.io_in_rs1 <= strc_fA_mux @[Pipe_Top_File.scala 92:25]
    id_ex_mod.io_in_rs2 <= strc_fB_mux @[Pipe_Top_File.scala 96:25]
    id_ex_mod.io_in_rs1Addr <= regFile_mod.io_rs1_addr @[Pipe_Top_File.scala 121:29]
    id_ex_mod.io_in_rs2Addr <= regFile_mod.io_rs2_addr @[Pipe_Top_File.scala 122:29]
    id_ex_mod.io_in_Rdaddr <= _id_ex_mod_io_in_Rdaddr_T @[Pipe_Top_File.scala 120:28]
    id_ex_mod.io_in_aluCout <= aluControl_mod.io_out @[Pipe_Top_File.scala 123:29]
    id_ex_mod.io_in_func3 <= _id_ex_mod_io_in_func3_T @[Pipe_Top_File.scala 117:27]
    id_ex_mod.io_in_func7 <= _id_ex_mod_io_in_func7_T @[Pipe_Top_File.scala 118:27]
    ex_mem_mod.clock <= clock
    ex_mem_mod.reset <= reset
    ex_mem_mod.io_in_c_memwr <= id_ex_mod.io_c_memWrite_out @[Pipe_Top_File.scala 143:30]
    ex_mem_mod.io_in_c_memrd <= id_ex_mod.io_c_memRead_out @[Pipe_Top_File.scala 144:30]
    ex_mem_mod.io_in_c_memtoreg <= id_ex_mod.io_c_memToReg_out @[Pipe_Top_File.scala 145:33]
    ex_mem_mod.io_in_rs2 <= _GEN_11
    ex_mem_mod.io_in_Rdaddr <= id_ex_mod.io_rdaddr_out @[Pipe_Top_File.scala 147:29]
    ex_mem_mod.io_in_Rs2addr <= id_ex_mod.io_rs2Addr_out @[Pipe_Top_File.scala 148:30]
    ex_mem_mod.io_in_ALUout <= alu_mod.io_out @[Pipe_Top_File.scala 146:29]
    ex_mem_mod.io_in_c_regWrite <= id_ex_mod.io_c_regWrite_out @[Pipe_Top_File.scala 149:33]
    mem_wr_mod.clock <= clock
    mem_wr_mod.reset <= reset
    mem_wr_mod.io_in_c_memtoreg <= ex_mem_mod.io_memtoreg_out @[Pipe_Top_File.scala 159:33]
    mem_wr_mod.io_in_dataOut <= dataMem_mod.io_dataOut @[Pipe_Top_File.scala 160:30]
    mem_wr_mod.io_in_aluOut <= ex_mem_mod.io_ALUout_out @[Pipe_Top_File.scala 161:29]
    mem_wr_mod.io_in_Rdaddr <= ex_mem_mod.io_rdaddr_out @[Pipe_Top_File.scala 162:29]
    mem_wr_mod.io_in_c_regWrite <= ex_mem_mod.io_reg_write_out @[Pipe_Top_File.scala 164:33]
    mem_wr_mod.io_in_c_memRead <= ex_mem_mod.io_memrd_out @[Pipe_Top_File.scala 163:32]
    dataMem_mod.clock <= clock
    dataMem_mod.reset <= reset
    dataMem_mod.io_writeData <= ex_mem_mod.io_memwr_out @[Pipe_Top_File.scala 155:30]
    dataMem_mod.io_readData <= ex_mem_mod.io_memrd_out @[Pipe_Top_File.scala 156:29]
    dataMem_mod.io_rdAddr <= _dataMem_mod_io_rdAddr_T @[Pipe_Top_File.scala 153:27]
    dataMem_mod.io_dataIn <= ex_mem_mod.io_rs2_out @[Pipe_Top_File.scala 154:27]
    control_mod.clock <= clock
    control_mod.reset <= reset
    control_mod.io_op_code <= _control_mod_io_op_code_T @[Pipe_Top_File.scala 59:28]
    immdGen_mod.clock <= clock
    immdGen_mod.reset <= reset
    immdGen_mod.io_instr <= if_id_mod.io_inst_out @[Pipe_Top_File.scala 62:26]
    immdGen_mod.io_pc <= if_id_mod.io_pc_out @[Pipe_Top_File.scala 63:23]
    aluControl_mod.clock <= clock
    aluControl_mod.reset <= reset
    aluControl_mod.io_alu_Operation <= control_mod.io_alu_Operation @[Pipe_Top_File.scala 101:37]
    aluControl_mod.io_func3 <= id_ex_mod.io_func3_out @[Pipe_Top_File.scala 104:29]
    aluControl_mod.io_func7 <= id_ex_mod.io_func7_out @[Pipe_Top_File.scala 105:29]
    alu_mod.clock <= clock
    alu_mod.reset <= reset
    alu_mod.io_in_A <= _GEN_3
    alu_mod.io_in_B <= _GEN_10
    alu_mod.io_alu_Op <= id_ex_mod.io_aluCout_out @[Pipe_Top_File.scala 137:23]
    regFile_mod.clock <= clock
    regFile_mod.reset <= reset
    regFile_mod.io_writeData <= dataMem_mux @[Pipe_Top_File.scala 168:30]
    regFile_mod.io_rs1_addr <= _regFile_mod_io_rs1_addr_T @[Pipe_Top_File.scala 72:29]
    regFile_mod.io_rs2_addr <= _regFile_mod_io_rs2_addr_T @[Pipe_Top_File.scala 73:29]
    regFile_mod.io_rd_addr <= mem_wr_mod.io_Rdaddr_out @[Pipe_Top_File.scala 74:28]
    regFile_mod.io_regWrite <= control_mod.io_regWrite @[Pipe_Top_File.scala 75:29]
    brControl_mod.clock <= clock
    brControl_mod.reset <= reset
    brControl_mod.io_in_A <= _GEN_57
    brControl_mod.io_in_B <= branch_frwdB_mux @[Pipe_Top_File.scala 351:27]
    brControl_mod.io_br_func3 <= _brControl_mod_io_br_func3_T @[Pipe_Top_File.scala 109:31]
    jalr_mod.clock <= clock
    jalr_mod.reset <= reset
    jalr_mod.io_rs1 <= _GEN_58
    jalr_mod.io_imm <= _jalr_mod_io_imm_T @[Pipe_Top_File.scala 172:21]
