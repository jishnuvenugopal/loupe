
module TopModule (
    input  clk,
    input  enable,
    input  S,
    input  A,
    input  B,
    input  C,
    output Z
);

    
    reg [7:0] shift_register;

    
    always @(posedge clk) begin
        if (enable) begin
            shift_register <= {S, shift_register[7:1]};
        end
    end

    
    reg [7:0] mux_output;

    always @(*) begin
        case ({A, B, C})
            3'b000: mux_output = shift_register[0];
            3'b001: mux_output = shift_register[1];
            3'b010: mux_output = shift_register[2];
            3'b011: mux_output = shift_register[3];
            3'b100: mux_output = shift_register[4];
            3'b101: mux_output = shift_register[5];
            3'b110: mux_output = shift_register[6];
            3'b111: mux_output = shift_register[7];
            default: mux_output = 8'b0;
        endcase
    end

    
    assign Z = mux_output;

endmodule
