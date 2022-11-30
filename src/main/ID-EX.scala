package pipelining

import chisel3._
import chisel3.util._

class id_ex extends Module{
    val io = IO(new Bundle{
        val in_c_memWrite = Input(UInt(1.W))
        val in_c_branch = Input(UInt(1.W))
        val in_c_memRead = Input(UInt(1.W))
        val in_c_regWrite = Input(UInt(1.W))
        val in_c_memToReg = Input(UInt(1.W))
        val in_c_alu_Operation = Input(UInt(3.W))
        val in_c_operand_A = Input(UInt(2.W))
        val in_c_operand_B = Input(UInt(1.W))
        val in_c_nextPc = Input(UInt(2.W))
        val in_pc = Input(SInt(32.W))
        val in_pc4 = Input(SInt(32.W))
        val in_imm = Input(SInt(32.W))
        val in_rs1 = Input(SInt(32.W))
        val in_rs2 = Input(SInt(32.W))
        val in_rs1Addr = Input(UInt(5.W))
        val in_rs2Addr = Input(UInt(5.W))
        val in_Rdaddr = Input(UInt(5.W))
        val in_aluCout = Input(UInt(11.W))
        val in_func3 = Input(UInt(3.W))
        val in_func7 = Input(UInt(7.W))

        val c_memWrite_out = Output(UInt(1.W))
        val c_branch_out = Output(UInt(1.W))
        val c_memRead_out = Output(UInt(1.W))
        val c_regWrite_out = Output(UInt(1.W))
        val c_memToReg_out = Output(UInt(1.W))
        val c_alu_Operation_out = Output(UInt(3.W))
        val c_operand_A_out = Output(UInt(2.W))
        val c_operand_B_out = Output(UInt(1.W))
        val c_nextPc_out = Output(UInt(2.W))
        val pc_out = Output(SInt(32.W))
        val pc4_out = Output(SInt(32.W))
        val imm_out = Output(SInt(32.W))
        val rs1_out = Output(SInt(32.W))
        val rs2_out = Output(SInt(32.W))
        val rs1Addr_out = Output(UInt(5.W))
        val rs2Addr_out = Output(UInt(5.W))
        val rdaddr_out = Output(UInt(5.W))
        val aluCout_out = Output(UInt(11.W))
        val func3_out = Output(UInt(3.W))
        val func7_out = Output(UInt(7.W))
    })
    val regc_memWrite = RegInit(0.U(1.W))
    val regc_branch = RegInit(0.U(1.W))
    val regc_memRead = RegInit(0.U(1.W))
    val regc_regWrite = RegInit(0.U(1.W))
    val regc_memToReg = RegInit(0.U(1.W))
    val regc_alu_Operation = RegInit(0.U(3.W))
    val regc_operand_A = RegInit(0.U(2.W))
    val regc_operand_B = RegInit(0.U(1.W))
    val regc_nextPc = RegInit(0.U(2.W))
    val regpc = RegInit(0.S(32.W))
    val regpc4 = RegInit(0.S(32.W))
    val regimm = RegInit(0.S(32.W))
    val regrs1 = RegInit(0.S(32.W))
    val regrs2 = RegInit(0.S(32.W))
    val regrs1_Addr = RegInit(0.U(5.W))
    val regrs2_Addr = RegInit(0.U(5.W))
    val regrd_addr = RegInit(0.U(5.W))
    val regAluCout = RegInit(0.U(11.W))
    val regFunc3 = RegInit(0.U(3.W))
    val regFunc7 = RegInit(0.U(7.W))

    regc_memWrite := io.in_c_memWrite
    regc_branch := io.in_c_branch
    regc_memRead := io.in_c_memRead
    regc_regWrite := io.in_c_regWrite
    regc_memToReg := io.in_c_memToReg
    regc_alu_Operation := io.in_c_alu_Operation
    regc_operand_A := io.in_c_operand_A
    regc_operand_B := io.in_c_operand_B
    regpc := io.in_pc
    regpc4 := io.in_pc4
    regimm := io.in_imm
    regrd_addr := io.in_Rdaddr
    regrs1 := io.in_rs1
    regrs2 := io.in_rs2
    regrs1_Addr := io.in_rs1Addr
    regrs2_Addr := io.in_rs2Addr
    regc_nextPc := io.in_c_nextPc
    regAluCout := io.in_aluCout
    regFunc3 := io.in_func3
    regFunc7 := io.in_func7

    io.c_memWrite_out := regc_memWrite
    io.c_branch_out := regc_branch
    io.c_memRead_out := regc_memRead
    io.c_regWrite_out := regc_regWrite
    io.c_memToReg_out := regc_memToReg
    io.c_alu_Operation_out := regc_alu_Operation
    io.c_operand_A_out := regc_operand_A
    io.c_operand_B_out := regc_operand_B
    io.pc_out := regpc
    io.pc4_out := regpc4
    io.imm_out := regimm
    io.rdaddr_out := regrd_addr
    io.rs1_out := regrs1
    io.rs2_out := regrs2
    io.rs1Addr_out := regrs1_Addr
    io.rs2Addr_out := regrs2_Addr
    io.c_nextPc_out := regc_nextPc
    io.aluCout_out := regAluCout
    io.func3_out := regFunc3
    io.func7_out := regFunc7
}