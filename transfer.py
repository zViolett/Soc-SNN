from migen import *

from litex.soc.interconnect.csr import *
# need interrupt handle?
from litex.soc.interconnect.csr_eventmanager import *

from litex.soc.integration.doc import AutoDoc, ModuleDoc

class Transfer (Module, AutoCSR, AutoDoc):
    def __init__(self, platform):
        self.intro = ModuleDoc(""" transfer""")
        self.status = CSRStorage(fields=[
            CSRField("ren2in_buf", size=1, description="ren 2 input buffer"),
            CSRField("input_buffer_empty", size=1, description= "receive empty"),
            CSRField("tick", size=1, description="enable tick"),
            CSRField("output_valid", size=1, description="Output valid",)
        ])
        self.packet_in = CSRStorage(32, reset=0x0, name="packet_in", description="packet_in" )
        self.packet_out = CSRStorage(32, reset=0x0, name="packet_out", description="packet_out" )
        self.data = CSRStorage(32, reset=0x0, name="data", description="value store" )
        self.num_in = CSRStorage(32, reset=0x0, name="num_in", description="number of input" )

        ren2in_buf = Signal()
        input_buffer_empty = Signal()
        tick = Signal()
        output_valid = Signal()
        self.comb += [
            ren2in_buf.eq(self.status.fields.ren2in_buf),
            input_buffer_empty.eq(self.status.fields.input_buffer_empty),
            tick.eq(self.status.fields.tick),
            output_valid.eq(self.status.fields.output_valid),
        ]

        packet_in = Signal(32)
        packet_out = Signal(32)
        data = Signal(32)
        num_in = Signal(32)
        self.comb += [
            packet_in.eq(self.packet_in.storage),
            packet_out.eq(self.packet_out.storage),
            data.eq(self.data.storage),
            num_in.eq(self.num_in.storage),
        ]

        PACKET_WIDTH = 32    
        self.specials += Instance("cnt",
            p_PACKET_WIDTH = PACKET_WIDTH,
            i_clk = ClockSignal(),
            i_rst = ResetSignal(),
            i_input_buffer_empty = input_buffer_empty,
            o_tick = tick,
            )
        platform.add_source("./ranc/cnt.v")

        # self.specials += Instance("RANCNetworkGrid_3x2",
        #     i_clk = ClockSignal(),
        #     i_reset_n = ResetSignal(),
        #     i_tick = tick,
        #     i_input_buffer_empty = input_buffer_empty,
        #     i_packet_in = packet_in,
        #     o_packet_out = packet_out,
        #     o_packet_out_valid = output_valid,
        #     o_ren_to_input_buffer = ren2in_buf,
        #     )
        # platform.add_source("./ranc/RANCNetworkGrid_3x2.v")
        # platform.add_source("./ranc/buffer.v")
        # platform.add_source("./ranc/Core_3x2.v")
        # platform.add_source("./ranc/Counter.v")
        # platform.add_source("./ranc/ForwardEastWest.v")
        # platform.add_source("./ranc/ForwardNorthSouth.v")
        # platform.add_source("./ranc/FromLocal.v")
        # platform.add_source("./ranc/LocalIn.v")
        # platform.add_source("./ranc/Merge2.v")
        # platform.add_source("./ranc/Merge3.v")
        # platform.add_source("./ranc/neuron_block.v")
        # platform.add_source("./ranc/neuron_grid_3x2.v")
        # platform.add_source("./ranc/neuron_grid_controller.v")
        # platform.add_source("./ranc/neuron_grid_datapath_3x2.v")
        # platform.add_source("./ranc/neuron_grid.v")
        # platform.add_source("./ranc/OutputBus.v")
        # platform.add_source("./ranc/PathDecoder2Way.v")
        # platform.add_source("./ranc/PathDecoder3Way.v")
        # platform.add_source("./ranc/Router.v")
        # platform.add_source("./ranc/Scheduler.v")
        # platform.add_source("./ranc/SchedulerSRAM.v")
