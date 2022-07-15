from sqlite3 import complete_statement
from migen import *

from litex.soc.interconnect.csr import *
# need interrupt handle?
from litex.soc.interconnect.csr_eventmanager import *

from litex.soc.integration.doc import AutoDoc, ModuleDoc

class Transfer (Module, AutoCSR, AutoDoc):
    def __init__(self, platform):
        self.intro = ModuleDoc(""" transfer""")
        self.core_reset         = CSRStorage(1, reset=0x0, name="core_reset", description="Core Reset" )
        self.start              = CSRStorage(1, reset=0x0, name="start", description="Start load packet" )
        self.input_buffer_empty = CSRStatus(1, reset=0x1, name="input_buffer_empty", description="Buffer empty" )
        self.tick               = CSRStatus(1, reset=0x0, name="tick", description="tick" )
        self.output_valid       = CSRStatus(1, reset=0x0, name="output_valid", description="Output valid" )
        self.complete           = CSRStatus(1, reset=0x0, name="complete", description="All process complete" )
        self.ren2in_buf         = CSRStatus(1, reset=0x0, name="ren2in_buf", description="ren to input buffer" )
        self.packet_in          = CSRStatus(30, reset=0x0, name="packet_in", description="packet_in" )
        self.packet_out         = CSRStatus(8, reset=0x0, name="packet_out", description="packet_out" )

        start               = Signal()
        ren2in_buf          = Signal()
        input_buffer_empty  = Signal()
        tick                = Signal()
        output_valid        = Signal()
        complete            = Signal()
        packet_in = Signal(30)
        packet_out = Signal(8)
        self.comb += [
            start.eq(self.start.storage),
            ren2in_buf.eq(self.ren2in_buf.status),
            output_valid.eq(self.output_valid.status),
            packet_out.eq(self.packet_out.status),
        ]        
        self.comb += [
            self.input_buffer_empty.status.eq(input_buffer_empty),
            self.tick.status.eq(tick),
            self.complete.status.eq(complete),
            self.packet_in.status.eq(packet_in),
        ]

        WIDTH       = 30
        NUM_PACKET  = 333
        NUM_PIC     = 3
        self.specials += Instance("cnt",
            i_clk                   = ClockSignal(),
            i_rst                   = ResetSignal() | self.core_reset.storage,
            i_input_buffer_empty    = input_buffer_empty,
            i_complete              = complete,
            o_tick                  = tick,
            )
        platform.add_source("./soc_snn/cnt.v")

        self.specials += Instance("load_packet",
            p_WIDTH                 = WIDTH,
            p_NUM_PACKET            = NUM_PACKET,
            p_NUM_PIC               = NUM_PIC,
            i_clk                   = ClockSignal(),
            i_reset_n               = ResetSignal() | self.core_reset.storage,
            i_start                 = start,
            i_ren2in_buf            = ren2in_buf,
            i_tick                  = tick,
            o_input_buffer_empty    = input_buffer_empty,
            o_complete              = complete,
            o_packet_in             = packet_in,
            )
        platform.add_source("./soc_snn/PacketLoader.v")

        self.specials += Instance("RANCNetworkGrid_3x2",
            i_clk = ClockSignal(),
            i_reset_n = ResetSignal() | self.core_reset.storage,
            i_tick = tick,
            i_input_buffer_empty = input_buffer_empty,
            i_packet_in = packet_in,
            o_packet_out = packet_out,
            o_packet_out_valid = output_valid,
            o_ren_to_input_buffer = ren2in_buf,
            )
        platform.add_source("./ranc/RANCNetworkGrid_3x2.v")
        platform.add_source("./ranc/buffer.v")
        platform.add_source("./ranc/Core_3x2.v")
        platform.add_source("./ranc/Counter.v")
        platform.add_source("./ranc/ForwardEastWest.v")
        platform.add_source("./ranc/ForwardNorthSouth.v")
        platform.add_source("./ranc/FromLocal.v")
        platform.add_source("./ranc/LocalIn.v")
        platform.add_source("./ranc/Merge2.v")
        platform.add_source("./ranc/Merge3.v")
        platform.add_source("./ranc/neuron_block.v")
        platform.add_source("./ranc/neuron_grid_3x2.v")
        platform.add_source("./ranc/neuron_grid_controller.v")
        platform.add_source("./ranc/neuron_grid_datapath_3x2.v")
        platform.add_source("./ranc/neuron_grid.v")
        platform.add_source("./ranc/OutputBus.v")
        platform.add_source("./ranc/PathDecoder2Way.v")
        platform.add_source("./ranc/PathDecoder3Way.v")
        platform.add_source("./ranc/Router.v")
        platform.add_source("./ranc/Scheduler.v")
        platform.add_source("./ranc/SchedulerSRAM.v")