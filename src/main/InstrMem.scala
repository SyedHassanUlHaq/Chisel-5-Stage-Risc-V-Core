package pipelining

import chisel3._
import chisel3.util._
import chisel3.util.experimental.loadMemoryFromFile

class instrMem extends Module{
    val io = IO(new Bundle{
        val instr = Output(UInt(32.W))
        val addr = Input(UInt(32.W))
    })
    val mem = Mem(1024, UInt(32.W))
    loadMemoryFromFile(mem, "/home/hassan/Documents/Assemble")
    io.instr := mem.read(io.addr)
}