package pipelining

import chisel3._
import chisel3.util._

object BROP{
    val ALU_beq = "b000".U(3.W) 
    val ALU_bne = "b001".U(3.W)
    val ALU_blt = "b100".U(3.W)
    val ALU_bge = "b101".U(3.W)
}
import BROP._
class branchControl extends Module{
    val io = IO(new Bundle{
        val in_A = Input(SInt(32.W))
        val in_B = Input(SInt(32.W))
        val br_func3 = Input(UInt(3.W))
        val branch_out = Output(UInt(1.W))
    })
    io.branch_out := 0.B
    switch(io.br_func3){
        is(ALU_beq){
            when (io.in_A === io.in_B){
                io.branch_out := 1.U
            }.otherwise{
                io.branch_out := 0.U
            }
        }
        is(ALU_bne){
            when (io.in_A =/= io.in_B){
                io.branch_out := 1.U
            }.otherwise{
                io.branch_out := 0.U
            }
        }
        is(ALU_blt){
            when (io.in_A < io.in_B){
                io.branch_out := 1.U
            }.otherwise{
                io.branch_out := 0.U
            }
        }
        is(ALU_bge){
            when(io.in_A > io.in_B){
                io.branch_out := 1.U
            }.otherwise{
                io.branch_out := 0.U
            }
        }
    }
}