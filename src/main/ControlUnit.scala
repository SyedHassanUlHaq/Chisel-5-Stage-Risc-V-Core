package pipelining

import chisel3._
import chisel3.util._

class control extends Module{
    val io = IO(new Bundle{
        val op_code = Input(UInt(7.W))
        val memWrite = Output(UInt(1.W))
        val branch = Output(UInt(1.W))
        val memRead = Output(UInt(1.W))
        val regWrite = Output(UInt(1.W))
        val memToReg = Output(UInt(1.W))
        val alu_Operation = Output(UInt(3.W))
        val operand_A = Output(UInt(2.W))
        val operand_B = Output(UInt(1.W))
        val extend_Sel = Output(UInt(2.W))
        val nextPc_Sel = Output(UInt(2.W))
    })
    when(io.op_code === "b0110011".U){//R-Type
        io.memWrite := "b0".U
        io.branch := "b0".U
        io.memRead := "b0".U
        io.regWrite := "b1".U
        io.memToReg := "b0".U
        io.alu_Operation := "b000".U
        io.operand_A := "b00".U
        io.operand_B := "b0".U
        io.extend_Sel := "b00".U
        io.nextPc_Sel := "b00".U
    }.elsewhen(io.op_code === "b0010011".U){//I-Type
        io.memWrite := "b0".U
        io.branch := "b0".U
        io.memRead := "b0".U
        io.regWrite := "b1".U
        io.memToReg := "b0".U
        io.alu_Operation := "b001".U
        io.operand_A := "b00".U
        io.operand_B := "b1".U
        io.extend_Sel := "b00".U
        io.nextPc_Sel := "b00".U
    }.elsewhen(io.op_code === "b0000011".U){//Load
        io.memWrite := "b0".U
        io.branch := "b0".U
        io.memRead := "b1".U
        io.regWrite := "b1".U
        io.memToReg := "b1".U
        io.alu_Operation := "b100".U
        io.operand_A := "b00".U
        io.operand_B := "b1".U
        io.extend_Sel := "b00".U
        io.nextPc_Sel := "b00".U
    }.elsewhen(io.op_code === "b0100011".U){//S-Type
        io.memWrite := "b1".U
        io.branch := "b0".U
        io.memRead := "b0".U
        io.regWrite := "b0".U
        io.memToReg := "b0".U
        io.alu_Operation := "b101".U
        io.operand_A := "b00".U
        io.operand_B := "b1".U
        io.extend_Sel := "b10".U
        io.nextPc_Sel := "b00".U
    }.elsewhen(io.op_code === "b1100011".U){//SB-Type
        io.memWrite := "b0".U
        io.branch := "b1".U
        io.memRead := "b0".U
        io.regWrite := "b0".U
        io.memToReg := "b0".U
        io.alu_Operation := "b010".U
        io.operand_A := "b00".U
        io.operand_B := "b0".U
        io.extend_Sel := "b00".U
        io.nextPc_Sel := "b01".U
    }.elsewhen(io.op_code === "b0110111".U){//LUI
        io.memWrite := "b0".U
        io.branch := "b0".U
        io.memRead := "b0".U
        io.regWrite := "b1".U
        io.memToReg := "b0".U
        io.alu_Operation := "b110".U
        io.operand_A := "b11".U
        io.operand_B := "b1".U
        io.extend_Sel := "b10".U
        io.nextPc_Sel := "b00".U
    }.elsewhen(io.op_code === "b1101111".U){//UJ-Type
        io.memWrite := "b0".U
        io.branch := "b0".U
        io.memRead := "b0".U
        io.regWrite := "b1".U
        io.memToReg := "b0".U
        io.alu_Operation := "b011".U
        io.operand_A := "b10".U 
        io.operand_B := "b0".U
        io.extend_Sel := "b00".U
        io.nextPc_Sel := "b10".U
    }.elsewhen(io.op_code === "b0010111".U){//AUIPC
        io.memWrite := "b0".U
        io.branch := "b0".U
        io.memRead := "b0".U
        io.regWrite := "b1".U
        io.memToReg := "b0".U
        io.alu_Operation := "b111".U
        io.operand_A := "b10".U
        io.operand_B := "b1".U
        io.extend_Sel := "b10".U
        io.nextPc_Sel := "b00".U
    }.elsewhen(io.op_code === "b1100111".U){//JALR
        io.memWrite := "b0".U
        io.branch := "b0".U
        io.memRead := "b0".U
        io.regWrite := "b1".U
        io.memToReg := "b0".U
        io.alu_Operation := "b011".U
        io.operand_A := "b10".U
        io.operand_B := "b1".U
        io.extend_Sel := "b00".U
        io.nextPc_Sel := "b11".U
    }.otherwise{
        io.memWrite := DontCare
        io.branch := DontCare
        io.memRead := DontCare
        io.regWrite := DontCare
        io.memToReg := DontCare
        io.alu_Operation := DontCare
        io.operand_A := DontCare
        io.operand_B := DontCare
        io.extend_Sel := DontCare
        io.nextPc_Sel := DontCare
    }
}