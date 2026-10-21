
module TopModule (
    input c,
    input d,
    output reg [3:0] mux_in
);

    
    reg [1:0] mux_select;
    reg [3:0] mux_out;
    assign mux_select = {c, d};
    assign mux_out = mux_select[0] ? {c, d} : {d, c};

    
    reg [1:0] mux_select_2;
    reg [3:0] mux_out_2;
    assign mux_select_2 = {mux_out[1], mux_out[0]};
    assign mux_out_2 = mux_select_2[0] ? {mux_out[1], mux_out[0]} : {mux_out[0], mux_out[1]};

    reg [1:0] mux_select_3;
    reg [3:0] mux_out_3;
    assign mux_select_3 = {mux_out_2[1], mux_out_2[0]};
    assign mux_out_3 = mux_select_3[0] ? {mux_out_2[1], mux_out_2[0]} : {mux_out_2[0], mux_out_2[1]};

    reg [1:0] mux_select_4;
    reg [3:0] mux_out_4;
    assign mux_select_4 = {mux_out_3[1], mux_out_3[0]};
    assign mux_out_4 = mux_select_4[0] ? {mux_out_3[1], mux_out_3[0]} : {mux_out_3[0], mux_out_3[1]};

    
    assign mux_in = mux_out_4;

endmodule
