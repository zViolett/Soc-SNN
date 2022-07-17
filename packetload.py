from sqlite3 import complete_statement
from migen import *

from litex.soc.interconnect.csr import *
# need interrupt handle?
from litex.soc.interconnect.csr_eventmanager import *

from litex.soc.integration.doc import AutoDoc, ModuleDoc

class packetload (Module, AutoCSR, AutoDoc):
    def __init__(self, platform):
        self.intro = ModuleDoc("""packetload""")
        self.core_reset_loader      = CSRStorage(1, reset=0x0, name="core_reset", description="Core Reset" )
        self.start_csr              = CSRStorage(1, reset=0x0, name="start", description="Start load packet" )
        self.packet_in_csr          = CSRStatus(30, reset=0x0, name="packet_in", description="packet_in" )
        self.complete_csr           = CSRStatus(1, reset=0x0, name="complete", description="All process complete")
        self.state_csr              = CSRStatus(3, reset=0x0, name="state", description="state loader" )
        self.tick_csr               = CSRStatus(1, reset=0x0, name="tick", description="tick" )
        self.spike_out_csr          = CSRStatus(250, reset=0x0, name="spike_out", description="spike_out" )
        self.input_buffer_empty_csr = CSRStatus(1, reset=0x1, name="input_buffer_empty", description="input buffer empty" )
        self.ren2in_buf_csr         = CSRStatus(1, reset=0x0, name="ren2in_buf", description="ren to input buffer" )
        self.output_valid_csr       = CSRStatus(1, reset=0x0, name="output_valid", description="Output valid" )
        self.packet_out_csr         = CSRStatus(8, reset=0x0, name="packet_out", description="packet_out" )

        start                       = Signal()
        complete                    = Signal()
        state_loader                = Signal(3)
        self.ren2in_buf             = Signal()
        self.input_buffer_empty     = Signal()
        self.tick                   = Signal()
        self.output_valid           = Signal()
        self.packet_in              = Signal(30)
        self.packet_out             = Signal(8)
        self.spike_out              = Signal(250)

        # Read from CSR
        self.comb += [
            start.eq(self.start_csr.storage),
        ]
        # Write to CSR
        self.comb += [
            self.complete_csr.status.eq(complete),
            self.state_csr.status.eq(state_loader),
            self.packet_in_csr.status.eq(self.packet_in),
            self.tick_csr.status.eq(self.tick),
            self.spike_out_csr.status.eq(self.spike_out),
            self.input_buffer_empty_csr.status.eq(self.input_buffer_empty),
            self.ren2in_buf_csr.status.eq(self.ren2in_buf),
            self.output_valid_csr.status.eq(self.output_valid),
            self.packet_out_csr.status.eq(self.packet_out),
        ]

        WIDTH       = 30
        NUM_PACKET  = 333
        NUM_PIC     = 3
        self.specials += Instance("cnt",
            i_clk                   = ClockSignal(),
            i_rst                   = ResetSignal() | self.core_reset_loader.storage,
            i_input_buffer_empty    = self.input_buffer_empty,
            i_complete              = complete,
            o_tick                  = self.tick,
            )
        platform.add_source("./soc_snn/cnt.v")

        self.specials += Instance("load_packet",
            p_WIDTH                 = WIDTH,
            p_NUM_PACKET            = NUM_PACKET,
            p_NUM_PIC               = NUM_PIC,
            i_clk                   = ClockSignal(),
            i_reset_n               = ResetSignal() | self.core_reset_loader.storage,
            i_start                 = start,
            i_ren2in_buf            = self.ren2in_buf,
            i_tick                  = self.tick,
            i_packet_out_valid      = self.output_valid,
            i_packet_out            = self.packet_out,
            o_input_buffer_empty    = self.input_buffer_empty,
            o_complete              = complete,
            o_state                 = state_loader,
            o_spike_out             = self.spike_out,
            o_packet_in             = self.packet_in,
            )
        platform.add_source("./soc_snn/PacketLoader.v")
