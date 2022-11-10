package pipelining

import chisel3._
import chisel3.util._

class frwdUnit extends Module{
    val io = IO(new Bundle{
        val exMem_reg_write = Input(UInt(1.W))
        val memWb_reg_write = Input(UInt(1.W))
        val mem_wb_rdAddr = Input(UInt(5.W))
        val ex_mem_rdAddr = Input(UInt(5.W))
        val id_ex_rs1Addr = Input(UInt(5.W))
        val id_ex_rs2Addr = Input(UInt(5.W))
        val frwdA = Output(UInt(2.W))
        val frwdB = Output(UInt(2.W))
    })
    io.frwdA := "b00".U
    io.frwdB := "b00".U

//  Execution Hazard     
    when(io.exMem_reg_write === "b1".U && io.ex_mem_rdAddr =/= "b00000".U && (io.ex_mem_rdAddr === io.id_ex_rs1Addr) && (io.ex_mem_rdAddr === io.id_ex_rs2Addr)){
        io.frwdA := "b01".U
		io.frwdB := "b01".U
    }.elsewhen(io.exMem_reg_write === "b1".U && io.ex_mem_rdAddr =/= "b00000".U && (io.ex_mem_rdAddr === io.id_ex_rs2Addr)){
		io.frwdB := "b01".U
    }.elsewhen(io.exMem_reg_write === "b1".U && io.ex_mem_rdAddr =/= "b00000".U && (io.ex_mem_rdAddr === io.id_ex_rs1Addr)){        
		io.frwdA := "b01".U
    }

//  Mem Hazard
    when(io.memWb_reg_write === "b1".U && io.mem_wb_rdAddr =/= "b00000".U && ~((io.exMem_reg_write === "b1".U) && (io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.id_ex_rs1Addr) && (io.ex_mem_rdAddr === io.id_ex_rs2Addr)) && (io.mem_wb_rdAddr === io.id_ex_rs1Addr) && (io.mem_wb_rdAddr === io.id_ex_rs2Addr)){
    	io.frwdA := "b10".U
    	io.frwdB := "b10".U
    }.elsewhen(io.memWb_reg_write === "b1".U && io.mem_wb_rdAddr =/= "b00000".U && ~((io.exMem_reg_write === "b1".U) && (io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.id_ex_rs2Addr)) && (io.mem_wb_rdAddr === io.id_ex_rs2Addr)){
	    io.frwdB := "b10".U
    }.elsewhen(io.memWb_reg_write === "b1".U && io.mem_wb_rdAddr =/= "b00000".U && ~((io.exMem_reg_write === "b1".U) && (io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.id_ex_rs2Addr))  && (io.mem_wb_rdAddr === io.id_ex_rs1Addr)){
        io.frwdA := "b10".U
    }
}