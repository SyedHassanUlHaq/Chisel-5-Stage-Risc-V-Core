package pipelining

import chisel3._
import chisel3.util._

class if_id extends Module{
    val io = IO(new Bundle{
     //   val in_inst = Input(UInt(32.W))
     //   val in_opCode = Input(UInt(7.W))
        val in_pc = Input(SInt(32.W))
        val in_pc4 = Input(SInt(32.W))
     //   val in_imm = Input(UInt(32.W))
   //     val in_rs1_addr = Input(UInt(5.W))
   //     val in_rs2_addr = Input(UInt(32.W))
   //     val in_rd_addr = Input(UInt(5.W))
   //     val in_func3 = Input(UInt(3.W))
   //     val in_func7 = Input(UInt(7.W))
        val in_inst = Input(UInt(32.W))

       // val inst_out = Output(UInt(32.W))
      //  val opCode_out = Output(UInt(7.W))
        val pc_out = Output(SInt(32.W))
        val pc4_out = Output(SInt(32.W))
      //  val imm_out = Output(UInt(32.W))
    //    val rs1_addr_out = Output(UInt(5.W))
    //    val rs2_addr_out = Output(UInt(5.W))
    //    val rd_addr_out = Output(UInt(5.W))
    //    val func3_out = Output(UInt(3.W))
    //    val func7_out = Output(UInt(7.W))
        val inst_out = Output(UInt(32.W))
    })
   // val reg_inst = RegInit(0.U(32.W))
    val reg_opCode = RegInit(0.U(32.W))
    val reg_pc = RegInit(0.S(32.W))
    val reg_pc4 = RegInit(0.S(32.W))
    val reg_imm = RegInit(0.U(32.W))
  //  val reg_rs1_addr = RegInit(0.U(5.W))
  //  val reg_rs2_addr = RegInit(0.U(5.W))
  //  val reg_rd_addr = RegInit(0.U(5.W))
  //  val reg_func3 = RegInit(0.U(3.W))
  //  val reg_func7 = RegInit(0.U(7.W))
    val reg_inst = RegInit(0.U(32.W))

    reg_inst := io.in_inst
   // reg_opCode := io.in_opCode
    reg_pc := io.in_pc
    reg_pc4 := io.in_pc4
   // reg_imm := io.in_imm
  //  reg_rs1_addr := io.in_rs1_addr
  //  reg_rs2_addr := io.in_rs2_addr
  //  reg_rd_addr := io.in_rd_addr
  //  reg_func3 := io.in_func3
  //  reg_func7 := io.in_func7

    io.inst_out := reg_inst
  //  io.opCode_out := reg_opCode
    io.pc_out := reg_pc
    io.pc4_out := reg_pc4
   // io.imm_out := reg_imm
   // io.rs1_addr_out := reg_rs1_addr
   // io.rs2_addr_out := reg_rs2_addr
   // io.rd_addr_out := reg_rd_addr
   // io.func3_out := reg_func3
   // io.func7_out := reg_func7
}