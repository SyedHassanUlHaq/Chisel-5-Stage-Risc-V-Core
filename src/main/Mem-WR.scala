package pipelining

import chisel3._
import chisel3.util._

class mem_wr extends Module{
    val io = IO(new Bundle{
        val in_c_memtoreg = Input(UInt(1.W))
        val in_dataOut = Input(SInt(32.W))
        val in_aluOut = Input(SInt(32.W))
        val in_Rdaddr = Input(UInt(5.W))
        val in_c_regWrite = Input(UInt(1.W))
        val in_c_memRead = Input(UInt(1.W))

        val c_memtoreg_out = Output(UInt(1.W))
        val dataOut_out = Output(SInt(32.W))
        val aluOut_out = Output(SInt(32.W))
        val Rdaddr_out = Output(UInt(5.W))
        val c_regWrite_out = Output(UInt(1.W))
        val c_memRead_out = Output(UInt(1.W))
    })
    val Reg_nextPc = RegInit(0.U(1.W))
    val Reg_dataOut = RegInit(0.S(32.W))
    val Reg_aluOut = RegInit(0.S(32.W))
    val Reg_Rdaddr = RegInit(0.U(5.W))
    val Reg_regWrite = RegInit(0.U(1.W))
    val Reg_memRead = RegInit(0.U(1.W))

    Reg_nextPc := io.in_c_memtoreg
    Reg_dataOut := io.in_dataOut
    Reg_aluOut := io.in_aluOut
    Reg_Rdaddr := io.in_Rdaddr
    Reg_regWrite := io.in_c_regWrite
    Reg_memRead := io.in_c_memRead

    io.c_memtoreg_out := Reg_nextPc
    io.dataOut_out := Reg_dataOut
    io.aluOut_out := Reg_aluOut
    io.Rdaddr_out := Reg_Rdaddr
    io.c_regWrite_out := Reg_regWrite
    io.c_memRead_out := Reg_memRead
}