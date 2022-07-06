module cnt #(
    // parameter NUM_OUTPUTS = 256,
    // parameter NUM_NEURONS = 256,
    // parameter NUM_AXONS = 256,
    // parameter NUM_TICKS = 16,
    // parameter DX_MSB = 29,
    // parameter DX_LSB = 21,
    // parameter DY_MSB = 20,
    // parameter DY_LSB = 12,
    // parameter PACKET_WIDTH = (DX_MSB - DX_LSB + 1)+(DY_MSB - DY_LSB + 1)+$clog2(NUM_AXONS)+$clog2(NUM_TICKS)
    parameter PACKET_WIDTH = 32
)(
    input clk,
    input rst,
    input input_buffer_empty,
    output tick
);

    reg [PACKET_WIDTH-1:0] cnt1, cnt1;
    reg [PACKET_WIDTH-1:0] cnt2, cnt2;
    reg tick1, tick2;
    reg tick_reg, tick_next;

    always @(posedge clk) begin
        if (rst) begin
            cnt1 <= 0;
            cnt2 <= 0;
            tick1 <= 0;
            tick2 <= 0; 
        end
        else begin
            tick_reg <= tick_next;
            if(tick1) cnt1 <= cnt1 + 1'b1;
            if(tick2) begin 
                cnt2 <= cnt2 + 1'b1;
            end
        end
    end

    always @(tick, input_buffer_empty) begin
        tick_next = 1'b0;
        if (input_buffer_empty && !tick2) tick1 = 1'b1;
        if (cnt1 == 32'hfa0) begin
            tick_next = 1'b1;
            tick2 = 1'b1;
            tick1 = 0;
            cnt1  = 0;
        end
        if (cnt2 == 32'h3ed) begin
            tick_next = 1'b1;
            cnt2 = 0;
        end

    end

    assign tick = tick_reg;

endmodule




