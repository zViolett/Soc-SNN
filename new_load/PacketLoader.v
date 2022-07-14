module load_packet #(
    parameter WIDTH         = 30,
    parameter NUM_PACKET    = 333,
    parameter NUM_PIC       = 10
)
(
    input               clk,
    input               reset_n,
    input               start,
    input               ren2in_buf,
    input               tick,
    output reg          input_buffer_empty,
    output reg          complete,
    output [WIDTH-1:0]  packet_in
);
    localparam  [3:0]   IDLE        = 4'b0000;
    localparam  [3:0]   LOAD	    = 4'b0001;
    localparam  [3:0]   COMPUTE     = 4'b0010;
    localparam  [3:0]   SPIKE_OUT   = 4'b0100;
    localparam  [3:0]   WAIT_END    = 4'b1000;
    

    reg [WIDTH-1:0]         mem  [0:NUM_PACKET-1];
    reg [9:0]               num_pic [0:NUM_PIC-1];
    reg [NUM_PACKET-1:0]    ptr_packet_reg, ptr_packet_next;
    reg [NUM_PIC-1:0]       ptr_pic_reg, ptr_pic_next;
    reg [WIDTH-1:0]         packet_reg, packet_next;
    reg [9:0]               num_line_reg, num_line_next;
    reg [3:0]               state_reg, state_next;

    always @(posedge clk or negedge reset_n ) begin
        if (!reset_n) begin
            ptr_packet_reg  <= 0;
            ptr_pic_reg     <= 0;
            state_reg       <= IDLE;
            num_line_reg    <= 0;
            mem[0] <= 30'b000000000000000000110010110000
            ;mem[1] <= 30'b000000000000000000110011000000
            ;mem[2] <= 30'b000000000000000000110011010000
            ;mem[3] <= 30'b000000000000000000111001100000
            ;mem[4] <= 30'b000000000000000000111001110000
            ;mem[5] <= 30'b000000000000000000111010000000
            ;mem[6] <= 30'b000000000000000000111010010000
            ;mem[7] <= 30'b000000000000000000111010100000
            ;mem[8] <= 30'b000000000000000000111010110000
            ;mem[9] <= 30'b000000000000000000111011000000
            ;mem[10] <= 30'b000000000000000000111011010000
            ;mem[11] <= 30'b000000000000000000111011100000
            ;mem[12] <= 30'b000000000000000000111011110000
            ;mem[13] <= 30'b000000000000000000111100000000
            ;mem[14] <= 30'b000000000000000000111100010000
            ;mem[15] <= 30'b000000000000000000111100100000
            ;mem[16] <= 30'b000000000000000000111100110000
            ;mem[17] <= 30'b000000000000000000111101000000
            ;mem[18] <= 30'b000000001000000000000110110000
            ;mem[19] <= 30'b000000001000000000000111000000
            ;mem[20] <= 30'b000000001000000000000111010000
            ;mem[21] <= 30'b000000001000000000001101100000
            ;mem[22] <= 30'b000000001000000000001101110000
            ;mem[23] <= 30'b000000001000000000001110000000
            ;mem[24] <= 30'b000000001000000000001110010000
            ;mem[25] <= 30'b000000001000000000001110100000
            ;mem[26] <= 30'b000000001000000000001110110000
            ;mem[27] <= 30'b000000001000000000001111000000
            ;mem[28] <= 30'b000000001000000000001111010000
            ;mem[29] <= 30'b000000001000000000001111100000
            ;mem[30] <= 30'b000000001000000000001111110000
            ;mem[31] <= 30'b000000001000000000010000000000
            ;mem[32] <= 30'b000000001000000000010000010000
            ;mem[33] <= 30'b000000001000000000010000100000
            ;mem[34] <= 30'b000000001000000000010000110000
            ;mem[35] <= 30'b000000001000000000010001000000
            ;mem[36] <= 30'b000000001000000000010101100000
            ;mem[37] <= 30'b000000001000000000010101110000
            ;mem[38] <= 30'b000000001000000000010110000000
            ;mem[39] <= 30'b000000001000000000010110010000
            ;mem[40] <= 30'b000000001000000000010110100000
            ;mem[41] <= 30'b000000001000000000010110110000
            ;mem[42] <= 30'b000000001000000000010111000000
            ;mem[43] <= 30'b000000001000000000010111010000
            ;mem[44] <= 30'b000000001000000000010111100000
            ;mem[45] <= 30'b000000001000000000010111110000
            ;mem[46] <= 30'b000000001000000000011000000000
            ;mem[47] <= 30'b000000001000000000011000010000
            ;mem[48] <= 30'b000000001000000000011110110000
            ;mem[49] <= 30'b000000001000000000011111000000
            ;mem[50] <= 30'b000000001000000000100101110000
            ;mem[51] <= 30'b000000001000000000100110000000
            ;mem[52] <= 30'b000000001000000000101100100000
            ;mem[53] <= 30'b000000001000000000101100110000
            ;mem[54] <= 30'b000000001000000000110011010000
            ;mem[55] <= 30'b000000001000000000110011100000
            ;mem[56] <= 30'b000000001000000000110011110000
            ;mem[57] <= 30'b000000001000000000111010010000
            ;mem[58] <= 30'b000000001000000000111010100000
            ;mem[59] <= 30'b000000010000000000000000100000
            ;mem[60] <= 30'b000000010000000000000000110000
            ;mem[61] <= 30'b000000010000000000000111010000
            ;mem[62] <= 30'b000000010000000000000111100000
            ;mem[63] <= 30'b000000010000000000000111110000
            ;mem[64] <= 30'b000000010000000000001110010000
            ;mem[65] <= 30'b000000010000000000001110100000
            ;mem[66] <= 30'b000000010000000000010101000000
            ;mem[67] <= 30'b000000010000000000010101010000
            ;mem[68] <= 30'b000000010000000000010101100000
            ;mem[69] <= 30'b000000010000000000011100000000
            ;mem[70] <= 30'b000000010000000000011100010000
            ;mem[71] <= 30'b000000010000000000100011000000
            ;mem[72] <= 30'b000000010000000000100011010000
            ;mem[73] <= 30'b000000010000000000101001110000
            ;mem[74] <= 30'b000000010000000000101010000000
            ;mem[75] <= 30'b000000010000000000110000100000
            ;mem[76] <= 30'b000000010000000000110000110000
            ;mem[77] <= 30'b000000010000000000110001000000
            ;mem[78] <= 30'b000000010000000000110111010000
            ;mem[79] <= 30'b000000010000000000110111100000
            ;mem[80] <= 30'b000000010000000000110111110000
            ;mem[81] <= 30'b000000010000000000111110010000
            ;mem[82] <= 30'b000000010000000000111110100000
            ;mem[83] <= 30'b000000000000000001000100100000
            ;mem[84] <= 30'b000000000000000001000100110000
            ;mem[85] <= 30'b000000000000000001000101000000
            ;mem[86] <= 30'b000000000000000001001011010000
            ;mem[87] <= 30'b000000000000000001001011100000
            ;mem[88] <= 30'b000000000000000001001011110000
            ;mem[89] <= 30'b000000000000000001010010010000
            ;mem[90] <= 30'b000000000000000001010010100000
            ;mem[91] <= 30'b000000000000000001011001000000
            ;mem[92] <= 30'b000000000000000001011001010000
            ;mem[93] <= 30'b000000000000000001011111110000
            ;mem[94] <= 30'b000000000000000001100000000000
            ;mem[95] <= 30'b000000000000000001100000010000
            ;mem[96] <= 30'b000000000000000001100110110000
            ;mem[97] <= 30'b000000000000000001100111000000
            ;mem[98] <= 30'b000000000000000001100111010000
            ;mem[99] <= 30'b000000000000000001101101110000
            ;mem[100] <= 30'b000000000000000001101110000000
            ;mem[101] <= 30'b000000000000000001101110010000
            ;mem[102] <= 30'b000000000000000001110100110000
            ;mem[103] <= 30'b000000000000000001110101000000
            ;mem[104] <= 30'b000000000000000000011000000000
            ;mem[105] <= 30'b000000000000000000011000010000
            ;mem[106] <= 30'b000000000000000000011000100000
            ;mem[107] <= 30'b000000000000000000011000110000
            ;mem[108] <= 30'b000000000000000000011110010000
            ;mem[109] <= 30'b000000000000000000011110100000
            ;mem[110] <= 30'b000000000000000000011110110000
            ;mem[111] <= 30'b000000000000000000011111000000
            ;mem[112] <= 30'b000000000000000000011111010000
            ;mem[113] <= 30'b000000000000000000011111100000
            ;mem[114] <= 30'b000000000000000000011111110000
            ;mem[115] <= 30'b000000000000000000100000000000
            ;mem[116] <= 30'b000000000000000000100101000000
            ;mem[117] <= 30'b000000000000000000100101010000
            ;mem[118] <= 30'b000000000000000000100101100000
            ;mem[119] <= 30'b000000000000000000100101110000
            ;mem[120] <= 30'b000000000000000000100110000000
            ;mem[121] <= 30'b000000000000000000100110010000
            ;mem[122] <= 30'b000000000000000000100110100000
            ;mem[123] <= 30'b000000000000000000100110110000
            ;mem[124] <= 30'b000000000000000000100111000000
            ;mem[125] <= 30'b000000000000000000101100000000
            ;mem[126] <= 30'b000000000000000000101100010000
            ;mem[127] <= 30'b000000000000000000101100100000
            ;mem[128] <= 30'b000000000000000000101101110000
            ;mem[129] <= 30'b000000000000000000101110000000
            ;mem[130] <= 30'b000000000000000000101110010000
            ;mem[131] <= 30'b000000000000000000110011000000
            ;mem[132] <= 30'b000000000000000000110011010000
            ;mem[133] <= 30'b000000000000000000110100110000
            ;mem[134] <= 30'b000000000000000000110101000000
            ;mem[135] <= 30'b000000000000000000111011100000
            ;mem[136] <= 30'b000000000000000000111011110000
            ;mem[137] <= 30'b000000000000000000111100000000
            ;mem[138] <= 30'b000000001000000000000000000000
            ;mem[139] <= 30'b000000001000000000000000010000
            ;mem[140] <= 30'b000000001000000000000000100000
            ;mem[141] <= 30'b000000001000000000000001110000
            ;mem[142] <= 30'b000000001000000000000010000000
            ;mem[143] <= 30'b000000001000000000000010010000
            ;mem[144] <= 30'b000000001000000000000111000000
            ;mem[145] <= 30'b000000001000000000000111010000
            ;mem[146] <= 30'b000000001000000000001000110000
            ;mem[147] <= 30'b000000001000000000001001000000
            ;mem[148] <= 30'b000000001000000000001111100000
            ;mem[149] <= 30'b000000001000000000001111110000
            ;mem[150] <= 30'b000000001000000000010000000000
            ;mem[151] <= 30'b000000001000000000010110100000
            ;mem[152] <= 30'b000000001000000000010110110000
            ;mem[153] <= 30'b000000001000000000010111000000
            ;mem[154] <= 30'b000000001000000000011101010000
            ;mem[155] <= 30'b000000001000000000011101100000
            ;mem[156] <= 30'b000000001000000000011101110000
            ;mem[157] <= 30'b000000001000000000100100000000
            ;mem[158] <= 30'b000000001000000000100100010000
            ;mem[159] <= 30'b000000001000000000100100100000
            ;mem[160] <= 30'b000000001000000000100100110000
            ;mem[161] <= 30'b000000001000000000101010110000
            ;mem[162] <= 30'b000000001000000000101011000000
            ;mem[163] <= 30'b000000001000000000101011010000
            ;mem[164] <= 30'b000000001000000000101011100000
            ;mem[165] <= 30'b000000001000000000110001110000
            ;mem[166] <= 30'b000000001000000000110010000000
            ;mem[167] <= 30'b000000001000000000110010010000
            ;mem[168] <= 30'b000000001000000000111000100000
            ;mem[169] <= 30'b000000001000000000111000110000
            ;mem[170] <= 30'b000000001000000000111001000000
            ;mem[171] <= 30'b000000001000000000111001010000
            ;mem[172] <= 30'b000000001000000000111111100000
            ;mem[173] <= 30'b000000001000000000111111110000
            ;mem[174] <= 30'b000000010000000000000101110000
            ;mem[175] <= 30'b000000010000000000000110000000
            ;mem[176] <= 30'b000000010000000000000110010000
            ;mem[177] <= 30'b000000010000000000001100100000
            ;mem[178] <= 30'b000000010000000000001100110000
            ;mem[179] <= 30'b000000010000000000001101000000
            ;mem[180] <= 30'b000000010000000000001101010000
            ;mem[181] <= 30'b000000010000000000010011100000
            ;mem[182] <= 30'b000000010000000000010011110000
            ;mem[183] <= 30'b000000010000000000010100000000
            ;mem[184] <= 30'b000000010000000000011010010000
            ;mem[185] <= 30'b000000010000000000011010100000
            ;mem[186] <= 30'b000000010000000000011010110000
            ;mem[187] <= 30'b000000010000000000011011000000
            ;mem[188] <= 30'b000000010000000000100001000000
            ;mem[189] <= 30'b000000010000000000100001010000
            ;mem[190] <= 30'b000000010000000000100001100000
            ;mem[191] <= 30'b000000010000000000100001110000
            ;mem[192] <= 30'b000000010000000000101000000000
            ;mem[193] <= 30'b000000010000000000101000010000
            ;mem[194] <= 30'b000000010000000000101000100000
            ;mem[195] <= 30'b000000010000000000101111000000
            ;mem[196] <= 30'b000000010000000000101111010000
            ;mem[197] <= 30'b000000010000000000101111100000
            ;mem[198] <= 30'b000000010000000000110010100000
            ;mem[199] <= 30'b000000010000000000110010110000
            ;mem[200] <= 30'b000000010000000000110011000000
            ;mem[201] <= 30'b000000010000000000110011010000
            ;mem[202] <= 30'b000000010000000000110110000000
            ;mem[203] <= 30'b000000010000000000110110010000
            ;mem[204] <= 30'b000000010000000000110110100000
            ;mem[205] <= 30'b000000010000000000110110110000
            ;mem[206] <= 30'b000000010000000000110111000000
            ;mem[207] <= 30'b000000010000000000110111010000
            ;mem[208] <= 30'b000000010000000000110111100000
            ;mem[209] <= 30'b000000010000000000110111110000
            ;mem[210] <= 30'b000000010000000000111000000000
            ;mem[211] <= 30'b000000010000000000111000010000
            ;mem[212] <= 30'b000000010000000000111000100000
            ;mem[213] <= 30'b000000010000000000111000110000
            ;mem[214] <= 30'b000000010000000000111001000000
            ;mem[215] <= 30'b000000010000000000111001010000
            ;mem[216] <= 30'b000000010000000000111001100000
            ;mem[217] <= 30'b000000010000000000111001110000
            ;mem[218] <= 30'b000000010000000000111010000000
            ;mem[219] <= 30'b000000010000000000111010010000
            ;mem[220] <= 30'b000000010000000000111101000000
            ;mem[221] <= 30'b000000010000000000111101010000
            ;mem[222] <= 30'b000000010000000000111101100000
            ;mem[223] <= 30'b000000010000000000111101110000
            ;mem[224] <= 30'b000000010000000000111110000000
            ;mem[225] <= 30'b000000010000000000111110010000
            ;mem[226] <= 30'b000000010000000000111110100000
            ;mem[227] <= 30'b000000010000000000111110110000
            ;mem[228] <= 30'b000000010000000000111111000000
            ;mem[229] <= 30'b000000010000000000111111010000
            ;mem[230] <= 30'b000000010000000000111111100000
            ;mem[231] <= 30'b000000010000000000111111110000
            ;mem[232] <= 30'b000000000000000001000011000000
            ;mem[233] <= 30'b000000000000000001000011010000
            ;mem[234] <= 30'b000000000000000001000011100000
            ;mem[235] <= 30'b000000000000000001000110100000
            ;mem[236] <= 30'b000000000000000001000110110000
            ;mem[237] <= 30'b000000000000000001000111000000
            ;mem[238] <= 30'b000000000000000001000111010000
            ;mem[239] <= 30'b000000000000000001001010000000
            ;mem[240] <= 30'b000000000000000001001010010000
            ;mem[241] <= 30'b000000000000000001001010100000
            ;mem[242] <= 30'b000000000000000001001010110000
            ;mem[243] <= 30'b000000000000000001001011000000
            ;mem[244] <= 30'b000000000000000001001011010000
            ;mem[245] <= 30'b000000000000000001001011100000
            ;mem[246] <= 30'b000000000000000001001011110000
            ;mem[247] <= 30'b000000000000000001001100000000
            ;mem[248] <= 30'b000000000000000001001100010000
            ;mem[249] <= 30'b000000000000000001001100100000
            ;mem[250] <= 30'b000000000000000001001100110000
            ;mem[251] <= 30'b000000000000000001001101000000
            ;mem[252] <= 30'b000000000000000001001101010000
            ;mem[253] <= 30'b000000000000000001001101100000
            ;mem[254] <= 30'b000000000000000001001101110000
            ;mem[255] <= 30'b000000000000000001001110000000
            ;mem[256] <= 30'b000000000000000001001110010000
            ;mem[257] <= 30'b000000000000000001010001000000
            ;mem[258] <= 30'b000000000000000001010001010000
            ;mem[259] <= 30'b000000000000000001010001100000
            ;mem[260] <= 30'b000000000000000001010001110000
            ;mem[261] <= 30'b000000000000000001010010000000
            ;mem[262] <= 30'b000000000000000001010010010000
            ;mem[263] <= 30'b000000000000000001010010100000
            ;mem[264] <= 30'b000000000000000001010010110000
            ;mem[265] <= 30'b000000000000000001010011000000
            ;mem[266] <= 30'b000000000000000001010011010000
            ;mem[267] <= 30'b000000000000000001010011100000
            ;mem[268] <= 30'b000000000000000001010011110000
            ;mem[269] <= 30'b000000000000000001010100000000
            ;mem[270] <= 30'b000000000000000001010100010000
            ;mem[271] <= 30'b000000000000000001010100100000
            ;mem[272] <= 30'b000000000000000001010100110000
            ;mem[273] <= 30'b000000000000000001011001010000
            ;mem[274] <= 30'b000000000000000001011001100000
            ;mem[275] <= 30'b000000000000000001011001110000
            ;mem[276] <= 30'b000000000000000001011010000000
            ;mem[277] <= 30'b000000000000000001011010010000
            ;mem[278] <= 30'b000000000000000000100000010000
            ;mem[279] <= 30'b000000000000000000100111010000
            ;mem[280] <= 30'b000000000000000000101110000000
            ;mem[281] <= 30'b000000000000000000101110010000
            ;mem[282] <= 30'b000000000000000000110101000000
            ;mem[283] <= 30'b000000000000000000110101010000
            ;mem[284] <= 30'b000000000000000000111100000000
            ;mem[285] <= 30'b000000001000000000000010000000
            ;mem[286] <= 30'b000000001000000000000010010000
            ;mem[287] <= 30'b000000001000000000001001000000
            ;mem[288] <= 30'b000000001000000000001001010000
            ;mem[289] <= 30'b000000001000000000010000000000
            ;mem[290] <= 30'b000000001000000000010110110000
            ;mem[291] <= 30'b000000001000000000010111000000
            ;mem[292] <= 30'b000000001000000000011101110000
            ;mem[293] <= 30'b000000001000000000011110000000
            ;mem[294] <= 30'b000000001000000000100100110000
            ;mem[295] <= 30'b000000001000000000100101000000
            ;mem[296] <= 30'b000000001000000000101011100000
            ;mem[297] <= 30'b000000001000000000101011110000
            ;mem[298] <= 30'b000000001000000000110010100000
            ;mem[299] <= 30'b000000001000000000110010110000
            ;mem[300] <= 30'b000000001000000000111001100000
            ;mem[301] <= 30'b000000001000000000111001110000
            ;mem[302] <= 30'b000000010000000000000110100000
            ;mem[303] <= 30'b000000010000000000000110110000
            ;mem[304] <= 30'b000000010000000000001101100000
            ;mem[305] <= 30'b000000010000000000001101110000
            ;mem[306] <= 30'b000000010000000000010100010000
            ;mem[307] <= 30'b000000010000000000010100100000
            ;mem[308] <= 30'b000000010000000000011011010000
            ;mem[309] <= 30'b000000010000000000011011100000
            ;mem[310] <= 30'b000000010000000000100010010000
            ;mem[311] <= 30'b000000010000000000100010100000
            ;mem[312] <= 30'b000000010000000000101001000000
            ;mem[313] <= 30'b000000010000000000101001010000
            ;mem[314] <= 30'b000000010000000000101001100000
            ;mem[315] <= 30'b000000010000000000110000000000
            ;mem[316] <= 30'b000000010000000000110000010000
            ;mem[317] <= 30'b000000010000000000110111000000
            ;mem[318] <= 30'b000000010000000000110111010000
            ;mem[319] <= 30'b000000010000000000111101110000
            ;mem[320] <= 30'b000000010000000000111110000000
            ;mem[321] <= 30'b000000010000000000111110010000
            ;mem[322] <= 30'b000000000000000001000100000000
            ;mem[323] <= 30'b000000000000000001000100010000
            ;mem[324] <= 30'b000000000000000001001011000000
            ;mem[325] <= 30'b000000000000000001001011010000
            ;mem[326] <= 30'b000000000000000001010001110000
            ;mem[327] <= 30'b000000000000000001010010000000
            ;mem[328] <= 30'b000000000000000001010010010000
            ;mem[329] <= 30'b000000000000000001011000110000
            ;mem[330] <= 30'b000000000000000001011001000000
            ;mem[331] <= 30'b000000000000000001011111110000
            ;mem[332] <= 30'b000000000000000001100000000000;
            num_pic[0] <= 10'h68;
            num_pic[1] <= 10'hae;
            num_pic[2] <= 10'h37;
        end
        else begin
            state_reg   <= state_next;
            ptr_pic_reg <= ptr_pic_next;
            num_line_reg    <= num_line_next;
            if (ren2in_buf) begin
                ptr_packet_reg  <= ptr_packet_next;
                packet_reg      <= packet_next;
            end
            else if (complete)
                packet_reg      <= 30'bx;
        end
    end

    always @(*) begin
        ptr_pic_next    = ptr_pic_reg;
        ptr_packet_next = ptr_packet_reg;
        num_line_next   = num_line_reg;
        packet_next     = packet_reg;
        case (state_reg)
            // IDLE:begin
            //     input_buffer_empty = 1'b1;
            //     ptr_packet_next = 0;
            //     ptr_pic_next    = 0;
            //     if (start)
            //         state_next = LOAD;
            //     else
            //         state_next = IDLE;
            // end
            // LOAD:begin
            //     input_buffer_empty = 1'b0;
            //     packet_next = mem[ptr_packet_reg];
            //     if (ren2in_buf)begin
            //         ptr_packet_next = ptr_packet_reg + 1'b1;
            //         num_line_next   = num_line_reg + 1'b1;
            //     end
            //     if (num_line_reg == num_pic[ptr_pic_reg])begin
            //         state_next      = COMPUTE;
            //         ptr_pic_next    = ptr_pic_reg + 1'b1;
            //         num_line_next   = 0; 
            //     end
            //     else
            //         state_next = LOAD;
            // end
            // COMPUTE:begin
            //     input_buffer_empty = 1'b1;
            //     if (tick)
            //         state_next = SPIKE_OUT;
            //     else
            //         state_next  = COMPUTE;
            // end
            // SPIKE_OUT:begin
            //     input_buffer_empty = 1'b1;
            //     if (tick)
            //         state_next = LOAD;
            //     else if (ptr_pic_reg == NUM_PIC)begin
            //         //complete    = 1'b1;
            //         state_next  = WAIT_END;
            //     end
            //     else
            //         state_next = SPIKE_OUT;
            // end
            WAIT_END:begin
                input_buffer_empty = 1'b1;
                if (tick) begin
                    complete    = 1'b1;
                    state_next  = IDLE;
                end
                else
                    state_next  = WAIT_END;
            end

            IDLE:begin
                input_buffer_empty = 1'b1;
                ptr_packet_next = 0;
                ptr_pic_next    = 0;
                if (start)
                    state_next = LOAD;
                else
                    state_next = IDLE;
            end
            LOAD:begin
                input_buffer_empty = 1'b0;
                packet_next = mem[ptr_packet_reg];
                if (ren2in_buf)begin
                    ptr_packet_next = ptr_packet_reg + 1'b1;
                    num_line_next   = num_line_reg + 1'b1;
                end
                if (num_line_reg == num_pic[ptr_pic_reg])begin
                    state_next      = COMPUTE;
                    ptr_pic_next    = ptr_pic_reg + 1'b1;
                    num_line_next   = 0; 
                end
                else
                    state_next = LOAD;
            end
            COMPUTE:begin
                input_buffer_empty = 1'b1;
                if (tick)
                    state_next = LOAD;
                else if (ptr_pic_reg == NUM_PIC)begin
                    //complete    = 1'b1;
                    state_next  = WAIT_END;
                end
                else
                    state_next  = COMPUTE;
            end
        endcase
    end
    
    assign packet_in = packet_reg;
    
endmodule