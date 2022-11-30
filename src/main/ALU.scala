package pipelining

import chisel3._
import chisel3.util._

object ALUOP {
    val ALU_ADD = "b00000000000".U(11.W)
    val ALU_SUB = "b00000001000".U(11.W)
    val ALU_AND = "b00000000111".U(11.W)
    val ALU_OR = "b00000000110".U(11.W)
    val ALU_XOR = "b00000000100".U(11.W)
    val ALU_SLT = "b00000000010".U(11.W)
    val ALU_SLL = "b00000000001".U(11.W)
    val ALU_SLTU = "b00000000011".U(11.W)
    val ALU_SRL = "b00000000101".U(11.W)
    val ALU_SRA = "b00000011101".U(11.W)
    val ALU_JALR = "b00000011111".U(11.W)
}

trait Config {
    val WLEN = 32
    val ALUOP_SIG_LEN = 11
}

import ALUOP._
class ALU extends Module with Config {
    val io = IO(new Bundle{
        val in_A = Input(SInt(WLEN.W))
        val in_B = Input(SInt(WLEN.W))
        val alu_Op = Input(UInt(ALUOP_SIG_LEN.W))
        var out = Output(SInt(WLEN.W))
    })
    io.out := 0.S

    switch(io.alu_Op){
        is(ALU_ADD){
            io.out := io.in_A + io.in_B
        }
        is(ALU_SUB){
            io.out := io.in_A - io.in_B
        }
        is(ALU_SLT){
            when(io.in_A < io.in_B) {
                io.out := 1.S
            }.otherwise{
                io.out := 0.S
            } 
        }
        is(ALU_SLTU){
            when(io.in_A.asUInt < io.in_B.asUInt) {
                io.out := 1.S
            }.otherwise {
                io.out := 0.S
            }
        }
        is(ALU_SRA){
            io.out := io.in_A >> io.in_B(4, 0)
        }
        is(ALU_SRL){
            io.out := io.in_A >> io.in_B(4, 0)
        }
        is(ALU_SLL){
            val sr = io.in_B(4, 0)
            io.out := io.in_A << sr
        }
        is(ALU_AND){
            io.out := io.in_A & io.in_B
        }
        is(ALU_OR){
            io.out:=io.in_A | io.in_B
        }
        is(ALU_XOR){
        io.out := (io.in_A ^ io.in_B)
        }
        is(ALU_JALR){
            io.out := (io.in_A)
        }
        
    }
}