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
        val Rdaddr_out = Output(UInt(5.W))
        val Rs2addr_out = Output(UInt(5.W))
        val ALUout_out = Output(SInt(32.W))
        val reg_write_out = Output(UInt(1.W))
    })
    val Reg_memwr = RegInit(0.U(1.W))
    val Reg_memrd = RegInit(0.U(1.W))
    val Reg_memtoreg = RegInit(0.U(1.W))
    val Reg_rs2 = RegInit(0.S(32.W))
    val Reg_Rdaddr = RegInit(0.U(5.W))
    val Reg_Rs2addr = RegInit(0.U(5.W))
    val Reg_Aluout = RegInit(0.S(32.W))
    val Reg_regWrite = RegInit(0.U(1.W))

    Reg_memwr := io.in_c_memwr
    Reg_memrd := io.in_c_memrd
    Reg_memtoreg := io.in_c_memtoreg
    Reg_rs2 := io.in_rs2
    Reg_Rdaddr := io.in_Rdaddr
    Reg_Rs2addr := io.in_Rs2addr
    Reg_Aluout := io.in_ALUout
    Reg_regWrite := io.in_c_regWrite

    io.memwr_out := Reg_memwr
    io.memrd_out := Reg_memrd
    io.memtoreg_out := Reg_memtoreg
    io.rs2_out := Reg_rs2
    io.Rdaddr_out := Reg_Rdaddr
    io.Rs2addr_out := Reg_Rs2addr
    io.ALUout_out := Reg_Aluout
    io.reg_write_out := Reg_regWrite
}