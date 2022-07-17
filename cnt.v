module cnt (
    input   clk,
    input   rst,
    input   input_buffer_empty,
    input   complete,
    output  tick
);
    localparam  [1:0]   IDLE      = 2'b00,
                        TICK1     = 2'b01,
                        TICK2     = 2'b10;

    reg [31:0]  cnt1_reg, cnt1_next;
    reg [31:0]  cnt2_reg, cnt2_next;
    reg         tick_reg, tick_next;
    reg [1:0]   state_reg, state_next;

    always @(posedge clk) begin
        if (!rst) begin
            tick_reg    <= 0;
            cnt1_reg    <= 0;
            cnt2_reg    <= 0;
            state_reg   <= IDLE;
        end
        else begin
            tick_reg    <= tick_next;
            cnt1_reg    <= cnt1_next;
            cnt2_reg    <= cnt2_next;
            state_reg   <= state_next;
        end
    end

    always @(*) begin
        tick_next = 1'b0;
        cnt1_next = cnt1_reg;
        cnt2_next = cnt2_reg;
        case (state_reg)
            IDLE:begin
                if(!input_buffer_empty)
                    state_next = TICK1;
                else
                    state_next = IDLE;
            end
            TICK1:begin
                if (cnt1_reg == 32'hfa0)begin
                    tick_next   = 1'b1;
                    state_next  = TICK2;
                    cnt1_next   = 0;
                end
                else begin
                    state_next  = TICK1;
                    cnt1_next   = cnt1_reg + 1'b1;
                end
            end
            TICK2:begin
                if (complete)
                    state_next  = IDLE;
                else begin
                    state_next  = TICK2;
                    if (cnt2_reg == 32'h3ec) begin
                        tick_next = 1'b1;
                        cnt2_next = 0;
                    end
                    else
                        cnt2_next = cnt2_reg + 1'b1;
                end
            end
        endcase
    end

    assign tick = tick_reg;

endmodule




