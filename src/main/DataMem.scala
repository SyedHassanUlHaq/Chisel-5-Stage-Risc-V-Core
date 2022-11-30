package pipelining

import chisel3._
import chisel3.util._

class dataMemory extends Module {
    val io = IO(new Bundle {
            val writeData = Input(UInt(1.W))
            val readData = Input(UInt(1.W))
            val rdAddr = Input(UInt(10.W))
            val dataIn = Input(SInt(32.W))    
            val dataOut = Output(SInt(32.W))  
    })

   val mem=Mem(1024,SInt(32.W))
    when (io.writeData === 1.B){
        mem.write(io.rdAddr,io.dataIn)
    }
    when (io.readData===1.B){
        io.dataOut := mem.read(io.rdAddr)
    }.otherwise{
        io.dataOut := 0.S
    }
}