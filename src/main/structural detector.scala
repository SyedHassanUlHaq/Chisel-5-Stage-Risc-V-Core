package pipelining

import chisel3._
import chisel3.util._

class structuralDetector extends Module{
  val io = IO(new Bundle{
    val rs1Addr = Input(UInt(5.W))
    val rs2Addr = Input(UInt(5.W))
    val mem_wb_regWr = Input(UInt(1.W))
    val mem_wb_rdAddr = Input(UInt(5.W))
    val frwd_A = Output(UInt(1.W))
    val frwd_B = Output(UInt(1.W))
    })
    io.frwd_A := 0.U
    io.frwd_B := 0.U
    when(io.mem_wb_regWr === 1.U &&  io.mem_wb_rdAddr === io.rs1Addr) {
        io.frwd_A := 1.U
    }.otherwise {
        io.frwd_A := 0.U
    }
    when(io.mem_wb_regWr === 1.U && io.mem_wb_rdAddr === io.rs2Addr) {
        io.frwd_B := 1.U
    }.otherwise {
        io.frwd_B := 0.U
    }
}
