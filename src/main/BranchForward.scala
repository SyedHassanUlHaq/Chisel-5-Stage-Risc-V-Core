package pipelining

import chisel3._
import chisel3.util._

class decode_frwd extends Module{
    val io = IO(new Bundle {
    val id_ex_rdAddr = Input(UInt(5.W))
    val id_ex_memRead = Input(Bool())
    val ex_mem_rdAddr = Input(UInt(5.W))
    val ex_mem_memRead = Input(Bool())
    val mem_wr_rdAddr = Input(UInt(5.W))
    val mem_wr_memRead = Input(Bool())
    val rs1Addr = Input(UInt(5.W))
    val rs2Addr = Input(UInt(5.W))
    val c_branch = Input(Bool())
    val frwd_A = Output(UInt(4.W))
    val frwd_B = Output(UInt(4.W))
    })
    io.frwd_A := 0.U
    io.frwd_B := 0.U
    when(io.c_branch === 1.U){
//  ALU Hazard
        when(io.id_ex_rdAddr =/= "b00000".U && io.id_ex_memRead =/= 1.U && (io.id_ex_rdAddr === io.rs1Addr) && (io.id_ex_rdAddr === io.rs2Addr)) {
            io.frwd_A := "b0001".U
            io.frwd_B := "b0001".U
        }.elsewhen(io.id_ex_rdAddr =/= "b00000".U && io.id_ex_memRead =/= 1.U && (io.id_ex_rdAddr === io.rs1Addr)) {
            io.frwd_A := "b0001".U
        }.elsewhen(io.id_ex_rdAddr =/= "b00000".U && io.id_ex_memRead =/= 1.U && (io.id_ex_rdAddr === io.rs2Addr)) {
            io.frwd_B := "b0001".U
        }

//  EX/MEM Hazard
        when(io.ex_mem_rdAddr =/= "b00000".U && io.ex_mem_memRead =/= 1.U &&
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr) && (io.id_ex_rdAddr === io.rs2Addr)) &&
        (io.ex_mem_rdAddr === io.rs1Addr) && (io.ex_mem_rdAddr === io.rs2Addr)){
            io.frwd_A := "b0010".U
            io.frwd_B := "b0010".U
        }.elsewhen(io.ex_mem_rdAddr =/= "b00000".U && io.ex_mem_memRead =/= 1.U &&
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs2Addr)) &&
        (io.ex_mem_rdAddr === io.rs2Addr)){
            io.frwd_B := "b0010".U
        }.elsewhen(io.ex_mem_rdAddr =/= "b00000".U && io.ex_mem_memRead =/= 1.U &&
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr)) &&
        (io.ex_mem_rdAddr === io.rs1Addr)){
            io.frwd_A := "b0010".U
        }.elsewhen(io.ex_mem_rdAddr =/= "b00000".U && io.ex_mem_memRead === 1.U &&
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr) && (io.id_ex_rdAddr === io.rs2Addr)) &&
        (io.ex_mem_rdAddr === io.rs1Addr) && (io.ex_mem_rdAddr === io.rs2Addr)) {
//  FOR Load instructions
            io.frwd_A := "b0100".U
            io.frwd_B := "b0100".U

        }.elsewhen(io.ex_mem_rdAddr =/= "b00000".U && io.ex_mem_memRead === 1.U &&
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs2Addr)) &&
        (io.ex_mem_rdAddr === io.rs2Addr)){
            io.frwd_B := "b0100".U
        }.elsewhen(io.c_branch === 1.U && io.ex_mem_rdAddr =/= "b00000".U && io.ex_mem_memRead === 1.U &&
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr)) &&
        (io.ex_mem_rdAddr === io.rs1Addr)){
            io.frwd_A := "b0100".U
        }

//  MEM/WB Hazard
        when(io.mem_wr_rdAddr =/= "b00000".U && io.mem_wr_memRead =/= 1.U &&
//  IF NOT ALU HAZARD
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr) && (io.id_ex_rdAddr === io.rs2Addr)) &&
//  IF NOT EX/MEM HAZARD
        ~((io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.rs1Addr) && (io.ex_mem_rdAddr === io.rs2Addr)) &&
        (io.mem_wr_rdAddr === io.rs1Addr) && (io.mem_wr_rdAddr === io.rs2Addr)) {
            io.frwd_A := "b0011".U
            io.frwd_B := "b0011".U
        }.elsewhen(io.mem_wr_rdAddr =/= "b00000".U && io.mem_wr_memRead =/= 1.U &&
//  IF NOT ALU HAZARD
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs2Addr)) &&
//  IF NOT EX/MEM HAZARD
        ~((io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.rs2Addr)) &&
        (io.mem_wr_rdAddr === io.rs2Addr)) {
            io.frwd_B := "b0011".U
        }.elsewhen(io.mem_wr_rdAddr =/= "b00000".U && io.mem_wr_memRead =/= 1.U &&
//  IF NOT ALU HAZARD
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr)) &&
//  IF NOT EX/MEM HAZARD
        ~((io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.rs1Addr)) &&
        (io.mem_wr_rdAddr === io.rs1Addr)) {
            io.frwd_A := "b0011".U
        }.elsewhen(io.mem_wr_rdAddr =/= "b00000".U && io.mem_wr_memRead === 1.U &&
//  IF NOT ALU HAZARD
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr) && (io.id_ex_rdAddr === io.rs2Addr)) &&
//  IF NOT EX/MEM HAZARD
        ~((io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.rs1Addr) && (io.ex_mem_rdAddr === io.rs2Addr)) &&
        (io.mem_wr_rdAddr === io.rs1Addr) && (io.mem_wr_rdAddr === io.rs2Addr)){
//  FOR Load instructions
            io.frwd_A := "b0101".U
            io.frwd_B := "b0101".U
        }.elsewhen(io.mem_wr_rdAddr =/= "b00000".U && io.mem_wr_memRead === 1.U &&
//  IF NOT ALU HAZARD
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs2Addr)) &&
//  IF NOT EX/MEM HAZARD
        ~((io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.rs2Addr)) &&
        (io.mem_wr_rdAddr === io.rs2Addr)) {
            io.frwd_B := "b0101".U
        }.elsewhen(io.mem_wr_rdAddr =/= "b00000".U && io.mem_wr_memRead === 1.U &&
//  IF NOT ALU HAZARD
        ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr)) &&
//  IF NOT EX/MEM HAZARD
        ~((io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.rs1Addr))&&
        (io.mem_wr_rdAddr === io.rs1Addr)) {
            io.frwd_A := "b0101".U
        }
        }.elsewhen(io.c_branch === 0.U){
//  ALU Hazard
                when(io.id_ex_rdAddr =/= "b00000".U && io.id_ex_memRead =/= 1.U && (io.id_ex_rdAddr === io.rs1Addr)){
                        io.frwd_A := "b0110".U
                }
//  EX/MEM Hazard
                when(io.ex_mem_rdAddr =/= "b00000".U && io.ex_mem_memRead =/= 1.U &&
                ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr)) &&
                (io.ex_mem_rdAddr === io.rs1Addr)){
                        io.frwd_A := "b0111".U
                }.elsewhen(io.ex_mem_rdAddr =/= "b00000".U && io.ex_mem_memRead === 1.U &&
                ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr)) &&
                (io.ex_mem_rdAddr === io.rs1Addr)){
//  FOR Load instructions
                        io.frwd_A := "b1001".U
                }
//  MEM/WB Hazard
                when(io.mem_wr_rdAddr =/= "b00000".U && io.mem_wr_memRead =/= 1.U &&
//  IF NOT ALU HAZARD
                ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr)) &&
//  IF NOT EX/MEM HAZARD
                ~((io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.rs1Addr)) &&
                (io.mem_wr_rdAddr === io.rs1Addr)){
                        io.frwd_A := "b1000".U
                }.elsewhen(io.mem_wr_rdAddr =/= "b00000".U && io.mem_wr_memRead === 1.U &&
//  IF NOT ALU HAZARD
                ~((io.id_ex_rdAddr =/= "b00000".U) && (io.id_ex_rdAddr === io.rs1Addr)) &&
//  IF NOT EX/MEM HAZARD
                ~((io.ex_mem_rdAddr =/= "b00000".U) && (io.ex_mem_rdAddr === io.rs1Addr)) && (io.mem_wr_rdAddr === io.rs1Addr)) {
//  FOR Load instructions
            io.frwd_A := "b1010".U
                }
        }
}