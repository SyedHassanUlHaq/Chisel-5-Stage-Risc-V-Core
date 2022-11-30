package pipelining

import chisel3._
import chisel3.util._

class pipelining_top extends Module{
    val io = IO(new Bundle{
        val out = Output(UInt(32.W))
    })
    io.out := 0.U

    
    val pC_mod = Module(new pC)
    dontTouch(pC_mod.io)
    val instrMem_mod = Module(new instrMem)
    dontTouch(instrMem_mod.io)
    val frwdunit_mod = Module(new frwdUnit)
    dontTouch(frwdunit_mod.io)
    val branch_frwd_mod = Module(new decode_frwd)
    dontTouch(branch_frwd_mod.io)
    val strc_detect_mod = Module(new structuralDetector)
    dontTouch(strc_detect_mod.io)
    val hazardDetection_mod = Module(new hazardDetection)
    dontTouch(hazardDetection_mod.io)
    val if_id_mod = Module(new if_id)
    dontTouch(if_id_mod.io)
    val id_ex_mod = Module(new id_ex)
    dontTouch(id_ex_mod.io)
    val ex_mem_mod = Module(new ex_mem)
    dontTouch(ex_mem_mod.io)
    val mem_wr_mod = Module(new mem_wr)
    dontTouch(mem_wr_mod.io)
    val dataMem_mod = Module(new dataMemory)
    dontTouch(dataMem_mod.io)
    val control_mod = Module(new control)
    dontTouch(control_mod.io)
    val immdGen_mod = Module(new immdValGen)
    dontTouch(immdGen_mod.io)
    val aluControl_mod = Module(new aluControl)
    dontTouch(aluControl_mod.io)
    val alu_mod = Module(new ALU)
    dontTouch(alu_mod.io)
    val regFile_mod = Module(new regFile)
    dontTouch(regFile_mod.io)
    val brControl_mod = Module(new branchControl)
    dontTouch(brControl_mod.io)
    val jalr_mod = Module(new jalr)
    dontTouch(jalr_mod.io)
    
//  PC AND INSTR MEMORY
    pC_mod.io.in := pC_mod.io.pc4
    instrMem_mod.io.addr := pC_mod.io.out(21, 2).asUInt()

//  if/id pipeline registers input
    if_id_mod.io.in_pc := pC_mod.io.out
    if_id_mod.io.in_pc4 := pC_mod.io.pc4
    if_id_mod.io.in_inst := instrMem_mod.io.instr

    control_mod.io.op_code := if_id_mod.io.inst_out(6, 0)
    
//  IMM GEN
    immdGen_mod.io.instr := if_id_mod.io.inst_out
    immdGen_mod.io.pc := if_id_mod.io.pc_out
    val imm_mux = MuxLookup(control_mod.io.extend_Sel, 0.S, Array(
    ("b00".U) -> immdGen_mod.io.i_imm,
    ("b01".U) -> immdGen_mod.io.s_imm,
    ("b10".U) -> immdGen_mod.io.u_imm,
    ("b11".U) -> 0.S
    ))
        
//  REG FILE
    regFile_mod.io.rs1_addr := if_id_mod.io.inst_out(19, 15)
    regFile_mod.io.rs2_addr := if_id_mod.io.inst_out(24, 20)
    regFile_mod.io.rd_addr := mem_wr_mod.io.Rdaddr_out
    regFile_mod.io.regWrite := control_mod.io.regWrite

    val readData1Mux = MuxLookup(control_mod.io.operand_A, 0.S, Array(
    ("b00".U) -> regFile_mod.io.rs1,
    ("b01".U) -> if_id_mod.io.pc4_out,
    ("b10".U) -> if_id_mod.io.pc_out,
    ("b11".U) -> regFile_mod.io.rs1
    ))
    val readData2Mux = Mux(control_mod.io.operand_B.asBool(), imm_mux, regFile_mod.io.rs2)

//  structural detector
    strc_detect_mod.io.rs1Addr := if_id_mod.io.inst_out(19, 15)
    strc_detect_mod.io.rs2Addr := if_id_mod.io.inst_out(24, 20)
    strc_detect_mod.io.mem_wb_rdAddr := mem_wr_mod.io.Rdaddr_out
    strc_detect_mod.io.mem_wb_regWr := mem_wr_mod.io.c_regWrite_out
//
    val strc_fA_mux = Mux(strc_detect_mod.io.frwd_A.asBool(), mem_wr_mod.io.aluOut_out, readData1Mux)
    id_ex_mod.io.in_rs1 := strc_fA_mux
    dontTouch(strc_fA_mux)

    val strc_fB_mux = Mux(strc_detect_mod.io.frwd_B.asBool(), mem_wr_mod.io.aluOut_out, readData2Mux)
    id_ex_mod.io.in_rs2 := strc_fB_mux
    dontTouch(strc_fB_mux)
   // io.out := instrMem_mod.io.instr

//  ALU CONTROL
    aluControl_mod.io.alu_Operation := control_mod.io.alu_Operation
  //  val func3 = id_ex_mod.io.in_func3
  //  val func7 = id_ex_mod.io.in_func7
    aluControl_mod.io.func3 := id_ex_mod.io.func3_out
    aluControl_mod.io.func7 := id_ex_mod.io.func7_out

  //  brControl_mod.io.in_A := regFile_mod.io.rs1
  //  brControl_mod.io.in_B := regFile_mod.io.rs2
    brControl_mod.io.br_func3 := if_id_mod.io.inst_out(14, 12)

//  id/ex pipeline registers
    id_ex_mod.io.in_pc := if_id_mod.io.pc_out
    id_ex_mod.io.in_pc4 := if_id_mod.io.pc4_out
  //  id_ex_mod.io.in_c_alu_Operation := control_mod.io.alu_Operation
  //  id_ex_mod.io.in_rs1 := readData1Mux
  //  id_ex_mod.io.in_rs2 := readData2Mux
    id_ex_mod.io.in_func3 := if_id_mod.io.inst_out(14, 12)
    id_ex_mod.io.in_func7 := if_id_mod.io.inst_out(31, 25)
    id_ex_mod.io.in_imm := imm_mux
    id_ex_mod.io.in_Rdaddr := if_id_mod.io.inst_out(11, 7)
    id_ex_mod.io.in_rs1Addr := regFile_mod.io.rs1_addr
    id_ex_mod.io.in_rs2Addr := regFile_mod.io.rs2_addr
    id_ex_mod.io.in_aluCout := aluControl_mod.io.out

//  id_ex_mod.io.in_c_nextPc := control_mod.io.nextPc_Sel
    
//  REG FILE MUX
   // val readData1Mux = MuxLookup(id_ex_mod.io.c_operand_A_out, 0.S, Array(
   // ("b00".U) -> id_ex_mod.io.rs1_out,
   // ("b01".U) -> id_ex_mod.io.pc4_out,
   // ("b10".U) -> id_ex_mod.io.pc_out,
   // ("b11".U) -> id_ex_mod.io.rs1_out
   // ))
   // val readData2Mux = Mux(id_ex_mod.io.c_operand_B_out.asBool(), id_ex_mod.io.in_imm, id_ex_mod.io.rs2_out)
    
//  ALU AND BRANCH
    alu_mod.io.alu_Op := id_ex_mod.io.aluCout_out
 //   brControl_mod.io.in_A := regFile_mod.io.rs1
 //   brControl_mod.io.in_B := regFile_mod.io.rs2
 //   brControl_mod.io.br_Op := aluControl_mod.io.out

//  EX/MEM pipeline register
    ex_mem_mod.io.in_c_memwr := id_ex_mod.io.c_memWrite_out
    ex_mem_mod.io.in_c_memrd := id_ex_mod.io.c_memRead_out
    ex_mem_mod.io.in_c_memtoreg := id_ex_mod.io.c_memToReg_out
    ex_mem_mod.io.in_ALUout := alu_mod.io.out
    ex_mem_mod.io.in_Rdaddr := id_ex_mod.io.rdaddr_out
    ex_mem_mod.io.in_Rs2addr := id_ex_mod.io.rs2Addr_out
    ex_mem_mod.io.in_c_regWrite := id_ex_mod.io.c_regWrite_out
    ex_mem_mod.io.in_rs2 := readData2Mux

//  DATA MEMORY           
    dataMem_mod.io.rdAddr := ex_mem_mod.io.ALUout_out(11, 2)
    dataMem_mod.io.dataIn := ex_mem_mod.io.rs2_out
    dataMem_mod.io.writeData := ex_mem_mod.io.memwr_out
    dataMem_mod.io.readData := ex_mem_mod.io.memrd_out

//  MEM/WR pipeline registers
    mem_wr_mod.io.in_c_memtoreg := ex_mem_mod.io.memtoreg_out
    mem_wr_mod.io.in_dataOut := dataMem_mod.io.dataOut
    mem_wr_mod.io.in_aluOut := ex_mem_mod.io.ALUout_out
    mem_wr_mod.io.in_Rdaddr := ex_mem_mod.io.rdaddr_out
    mem_wr_mod.io.in_c_memRead := ex_mem_mod.io.memrd_out
    mem_wr_mod.io.in_c_regWrite := ex_mem_mod.io.reg_write_out

    val dataMem_mux = Mux(mem_wr_mod.io.c_memtoreg_out.asBool(), mem_wr_mod.io.dataOut_out, mem_wr_mod.io.aluOut_out.asSInt())

    regFile_mod.io.writeData := dataMem_mux

  //  val branch_and = control_mod.io.branch & brControl_mod.io.branch_out.asBool()
    jalr_mod.io.rs1 := readData1Mux.asUInt()
    jalr_mod.io.imm := imm_mux.asUInt()

//    jalr.io.input_a := reg_file.io.rs1
//jalr.io.input_b := imm_generation.io.i_imm

  //  val branchMux = Mux(branch_and.asBool(),  immdGen_mod.io.sb_imm, pC_mod.io.pc4)
 //   val pc_mux = MuxLookup(control_mod.io.nextPc_Sel, 0.S, Array(
 //   ("b00".U) -> if_id_mod.io.pc4_out,
 //   ("b01".U) -> branchMux,
 //   ("b10".U) -> immdGen_mod.io.uj_imm,
 //   ("b11".U) -> jalr_mod.io.pcVal.asSInt()
 //   ))
 //   pC_mod.io.in := pc_mux

//  Forwarding Unit
    frwdunit_mod.io.exMem_reg_write := ex_mem_mod.io.reg_write_out
    frwdunit_mod.io.memWb_reg_write := mem_wr_mod.io.c_regWrite_out
    frwdunit_mod.io.ex_mem_rdAddr := ex_mem_mod.io.rdaddr_out
    frwdunit_mod.io.mem_wb_rdAddr := mem_wr_mod.io.Rdaddr_out
    frwdunit_mod.io.id_ex_rs1Addr := id_ex_mod.io.rs1Addr_out
    frwdunit_mod.io.id_ex_rs2Addr := id_ex_mod.io.rs2Addr_out

//  forwarding mux
    when(id_ex_mod.io.c_operand_A_out === "b10".U){
        alu_mod.io.in_A := id_ex_mod.io.pc4_out
    }.otherwise{
        when(frwdunit_mod.io.frwdA === "b00".U){
            alu_mod.io.in_A := id_ex_mod.io.rs1_out
        }.elsewhen(frwdunit_mod.io.frwdA === "b01".U){
            alu_mod.io.in_A := ex_mem_mod.io.ALUout_out
        }.elsewhen(frwdunit_mod.io.frwdA === "b10".U){
            alu_mod.io.in_A := regFile_mod.io.writeData
        }.otherwise{
            alu_mod.io.in_A := id_ex_mod.io.rs1_out
    }
}

    when(id_ex_mod.io.c_operand_B_out === "b1".U){
        alu_mod.io.in_B := id_ex_mod.io.imm_out
        when(frwdunit_mod.io.frwdB === "b00".U){
            ex_mem_mod.io.in_rs2 := id_ex_mod.io.rs2_out
        }.elsewhen(frwdunit_mod.io.frwdB === "b01".U) {
            ex_mem_mod.io.in_rs2 := ex_mem_mod.io.ALUout_out
        }.elsewhen(frwdunit_mod.io.frwdB === "b10".U) {
            ex_mem_mod.io.in_rs2 := regFile_mod.io.writeData
        }.otherwise{
            ex_mem_mod.io.in_rs2 := id_ex_mod.io.rs2_out
        }
    }.otherwise{
        when(frwdunit_mod.io.frwdB === "b00".U){
        alu_mod.io.in_B := id_ex_mod.io.rs2_out
        ex_mem_mod.io.in_rs2 := id_ex_mod.io.rs2_out
    }.elsewhen(frwdunit_mod.io.frwdB === "b01".U){
        alu_mod.io.in_B := ex_mem_mod.io.ALUout_out
        ex_mem_mod.io.in_rs2 := ex_mem_mod.io.ALUout_out
    }.elsewhen(frwdunit_mod.io.frwdB === "b10".U){
        alu_mod.io.in_B := regFile_mod.io.writeData
        ex_mem_mod.io.in_rs2 := regFile_mod.io.writeData
    }.otherwise{
        alu_mod.io.in_B := id_ex_mod.io.rs2_out
        ex_mem_mod.io.in_rs2 := id_ex_mod.io.rs2_out
    }
}


// hazard detection
    hazardDetection_mod.io.id_ex_memRead := id_ex_mod.io.c_memRead_out
    hazardDetection_mod.io.id_ex_rdAddr := id_ex_mod.io.rdaddr_out
    hazardDetection_mod.io.if_id_in_inst := if_id_mod.io.inst_out
    hazardDetection_mod.io.in_pc := if_id_mod.io.pc_out
    hazardDetection_mod.io.in_pc4 := if_id_mod.io.pc4_out

    when(hazardDetection_mod.io.inst_frwd === "b1".U) {
        if_id_mod.io.in_inst := hazardDetection_mod.io.if_id_inst_out
        if_id_mod.io.in_pc := hazardDetection_mod.io.pc_out
    }.otherwise{
        if_id_mod.io.in_inst := instrMem_mod.io.instr
    }

    when(hazardDetection_mod.io.pc_frwd === "b1".U) {
        pC_mod.io.in := hazardDetection_mod.io.pc_out
    }.otherwise{
    when(control_mod.io.nextPc_Sel === "b01".U) {
        when(brControl_mod.io.branch_out === 1.U && control_mod.io.branch === 1.U) {
            pC_mod.io.in := immdGen_mod.io.sb_imm
            if_id_mod.io.in_pc := 0.S
            if_id_mod.io.in_pc := 0.S
            if_id_mod.io.in_inst := 0.U
        }.otherwise{
            pC_mod.io.in := pC_mod.io.pc4
        }
    }.elsewhen(control_mod.io.nextPc_Sel === "b10".U) {
      pC_mod.io.in := immdGen_mod.io.uj_imm
      if_id_mod.io.in_pc4 := 0.S
      if_id_mod.io.in_inst := 0.U
    }.otherwise{
      pC_mod.io.in := pC_mod.io.pc4
    }
}
    when(hazardDetection_mod.io.ctrl_frwd === "b1".U) {
        id_ex_mod.io.in_c_memWrite := 0.U
        id_ex_mod.io.in_c_memRead := 0.U
        id_ex_mod.io.in_c_branch := 0.U
        id_ex_mod.io.in_c_regWrite := 0.U
        id_ex_mod.io.in_c_memToReg := 0.U
        id_ex_mod.io.in_c_alu_Operation := 0.U
        id_ex_mod.io.in_c_operand_A := 0.U
        id_ex_mod.io.in_c_operand_B := 0.U
        id_ex_mod.io.in_c_nextPc := 0.U
    }.otherwise{
        id_ex_mod.io.in_c_memWrite := control_mod.io.memWrite
        id_ex_mod.io.in_c_memRead := control_mod.io.memRead
        id_ex_mod.io.in_c_branch := control_mod.io.branch
        id_ex_mod.io.in_c_regWrite := control_mod.io.regWrite
        id_ex_mod.io.in_c_memToReg := control_mod.io.memToReg
        id_ex_mod.io.in_c_alu_Operation := control_mod.io.alu_Operation
        id_ex_mod.io.in_c_operand_A := control_mod.io.operand_A
        id_ex_mod.io.in_c_operand_B := control_mod.io.operand_B
        id_ex_mod.io.in_c_nextPc := control_mod.io.nextPc_Sel
    }

//  branch forward
    branch_frwd_mod.io.id_ex_rdAddr := id_ex_mod.io.rdaddr_out
    branch_frwd_mod.io.id_ex_memRead := id_ex_mod.io.c_memRead_out
    branch_frwd_mod.io.ex_mem_rdAddr := ex_mem_mod.io.rdaddr_out
    branch_frwd_mod.io.mem_wr_rdAddr := mem_wr_mod.io.Rdaddr_out
    branch_frwd_mod.io.ex_mem_memRead := ex_mem_mod.io.memrd_out
    branch_frwd_mod.io.mem_wr_memRead := mem_wr_mod.io.c_memRead_out
    branch_frwd_mod.io.rs1Addr := if_id_mod.io.inst_out(19, 15)
    branch_frwd_mod.io.rs2Addr := if_id_mod.io.inst_out(24, 20)
    branch_frwd_mod.io.c_branch := control_mod.io.branch


    when(branch_frwd_mod.io.frwd_A === "b0000".U){
        brControl_mod.io.in_A := regFile_mod.io.rs1
        jalr_mod.io.rs1 := regFile_mod.io.rs1.asUInt()
    }.elsewhen(branch_frwd_mod.io.frwd_A === "b0001".U){
        brControl_mod.io.in_A := alu_mod.io.out
        jalr_mod.io.rs1 := regFile_mod.io.rs1.asUInt()
    }.elsewhen(branch_frwd_mod.io.frwd_A === "b0010".U){
        brControl_mod.io.in_A := ex_mem_mod.io.ALUout_out
        jalr_mod.io.rs1 := regFile_mod.io.rs1.asUInt()
    }.elsewhen(branch_frwd_mod.io.frwd_A === "b0011".U){
        brControl_mod.io.in_A := regFile_mod.io.writeData
        jalr_mod.io.rs1 := regFile_mod.io.rs1.asUInt()
    }.elsewhen(branch_frwd_mod.io.frwd_A === "b0100".U){
        brControl_mod.io.in_A := dataMem_mod.io.dataOut
        jalr_mod.io.rs1 := regFile_mod.io.rs1.asUInt()
    }.elsewhen(branch_frwd_mod.io.frwd_A === "b0101".U){
        brControl_mod.io.in_A := regFile_mod.io.writeData
        jalr_mod.io.rs1 := regFile_mod.io.rs1.asUInt()
    }.elsewhen(branch_frwd_mod.io.frwd_A === "b0110".U){
        jalr_mod.io.rs1 := alu_mod.io.out.asUInt()
        brControl_mod.io.in_A := regFile_mod.io.rs1
    }.elsewhen(branch_frwd_mod.io.frwd_A === "b0111".U){
        jalr_mod.io.rs1 := ex_mem_mod.io.ALUout_out.asUInt()
        brControl_mod.io.in_A := regFile_mod.io.rs1
    }.elsewhen(branch_frwd_mod.io.frwd_A === "b1000".U){
        jalr_mod.io.rs1 := regFile_mod.io.writeData.asUInt()
        brControl_mod.io.in_A := regFile_mod.io.rs1
    }.elsewhen(branch_frwd_mod.io.frwd_A === "b1001".U){
        jalr_mod.io.rs1 := dataMem_mod.io.dataOut.asUInt()
        brControl_mod.io.in_A := regFile_mod.io.rs1
    }.elsewhen(branch_frwd_mod.io.frwd_A === "b1010".U){
        jalr_mod.io.rs1 := regFile_mod.io.writeData.asUInt()
        brControl_mod.io.in_A := regFile_mod.io.rs1
    }.otherwise{
        brControl_mod.io.in_A := regFile_mod.io.rs1
        jalr_mod.io.rs1 := regFile_mod.io.rs1.asUInt()
    }

    val branch_frwdB_mux = MuxLookup(branch_frwd_mod.io.frwd_B, 0.S, Array(
        ("b0000".U) -> regFile_mod.io.rs2,
        ("b0001".U) -> alu_mod.io.out,
        ("b0010".U) -> ex_mem_mod.io.ALUout_out,
        ("b0011".U) -> dataMem_mux,
        ("b0100".U) -> dataMem_mod.io.dataOut,
        ("b0101".U) -> dataMem_mux
    ))
    brControl_mod.io.in_B := branch_frwdB_mux
    dontTouch(branch_frwdB_mux)
//  structural detector
  //  strc_detect_mod.io.rs1Addr := if_id_mod.io.inst_out(19, 15)
  //  strc_detect_mod.io.rs2Addr := if_id_mod.io.inst_out(24, 20)
  //  strc_detect_mod.io.mem_wb_rdAddr := mem_wr_mod.io.Rdaddr_out
  //  strc_detect_mod.io.mem_wb_regWr := mem_wr_mod.io.c_regWrite_out
////
  //  val strc_fA_mux = Mux(strc_detect_mod.io.frwd_A.asBool(), mem_wr_mod.io.aluOut_out, readData1Mux)
  //  id_ex_mod.io.in_rs1 := strc_fA_mux
//
  //  val strc_fB_mux = Mux(strc_detect_mod.io.frwd_B.asBool(), mem_wr_mod.io.aluOut_out, readData2Mux)
  //  id_ex_mod.io.in_rs2 := strc_fB_mux
    io.out := instrMem_mod.io.instr
}