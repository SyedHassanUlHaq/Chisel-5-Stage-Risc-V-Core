package pipelining

import chisel3._
import chisel3.util._

class hazardDetection extends Module{
    val io = IO(new Bundle{
        val id_ex_memRead = Input(UInt(1.W))
        val id_ex_rdAddr = Input(UInt(5.W))
        val if_id_in_inst = Input(UInt(32.W))
        val in_pc = Input(SInt(32.W))
        val in_pc4 = Input(SInt(32.W))
        val inst_frwd = Output(UInt(1.W))
        val pc_frwd = Output(UInt(1.W))
        val ctrl_frwd = Output(UInt(1.W))
        val if_id_inst_out = Output(UInt(32.W))
        val pc4_out = Output(SInt(32.W))
        val pc_out = Output(SInt(32.W))

    })
    val rs1Addr = io.if_id_in_inst(19, 15)
    val rs2Addr = io.if_id_in_inst(24, 20)
    when(io.id_ex_memRead === "b1".U && ((io.id_ex_rdAddr === rs1Addr) | (io.id_ex_rdAddr === rs2Addr))){
        io.inst_frwd := 1.U
        io.pc_frwd := 1.U
        io.ctrl_frwd := 1.U
        io.if_id_inst_out := io.if_id_in_inst
        io.pc_out := io.in_pc
        io.pc4_out := io.in_pc4
    }.otherwise{
        io.inst_frwd := 0.U
        io.pc_frwd := 0.U
        io.ctrl_frwd := 0.U
        io.if_id_inst_out := io.if_id_in_inst  
        io.pc4_out := io.in_pc4
        io.pc_out := io.in_pc
    }
}