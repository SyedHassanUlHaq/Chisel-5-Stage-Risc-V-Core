package pipelining

import chisel3._
import org.scalatest._
import chiseltest._

class pipelining_Topfile_Test extends FreeSpec with ChiselScalatestTester{
    "Top File Test" in {
        test(new pipelining_top){
            C =>
            C.clock.step(100)
        }
    }
}