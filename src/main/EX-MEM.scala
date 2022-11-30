package pipelining

import chisel3._
import chisel3.util._

class ex_mem extends Module{
    val io = IO(new Bundle{
        val in_c_memwr = Input(UInt(1.W))
        val in_c_memrd = Input(UInt(1.W))
        val in_c_memtoreg = Input(UInt(1.W))
        val in_rs2 = Input(SInt(32.W))
        val in_Rdaddr = Input(UInt(5.W))
        val in_Rs2addr = Input(UInt(5.W))
        val in_ALUout = Input(SInt(32.W))
        val in_c_regWrite = Input(UInt(1.W))

        val memwr_out = Output(UInt(1.W))
        val memrd_out = Output(UInt(1.W))
        val memtoreg_out = Output(UInt(1.W))
        val rs2_out = Output(SInt(32.W))
        val rdaddr_out = Output(UInt(5.W))
        val rs2addr_out = Output(UInt(5.W))
        val ALUout_out = Output(SInt(32.W))
        val reg_write_out = Output(UInt(1.W))
    })
    val reg_memwr = RegInit(0.U(1.W))
    val reg_memrd = RegInit(0.U(1.W))
    val reg_memtoreg = RegInit(0.U(1.W))
    val reg_rs2 = RegInit(0.S(32.W))
    val reg_Rdaddr = RegInit(0.U(5.W))
    val reg_Rs2addr = RegInit(0.U(5.W))
    val reg_Aluout = RegInit(0.S(32.W))
    val reg_regWrite = RegInit(0.U(1.W))

    reg_memwr := io.in_c_memwr
    reg_memrd := io.in_c_memrd
    reg_memtoreg := io.in_c_memtoreg
    reg_rs2 := io.in_rs2
    reg_Rdaddr := io.in_Rdaddr
    reg_Rs2addr := io.in_Rs2addr
    reg_Aluout := io.in_ALUout
    reg_regWrite := io.in_c_regWrite

    io.memwr_out := reg_memwr
    io.memrd_out := reg_memrd
    io.memtoreg_out := reg_memtoreg
    io.rs2_out := reg_rs2
    io.rdaddr_out := reg_Rdaddr
    io.rs2addr_out := reg_Rs2addr
    io.ALUout_out := reg_Aluout
    io.reg_write_out := reg_regWrite
}