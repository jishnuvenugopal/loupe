
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

    
    wire [2:0] mux_input;
    wire [7:0] mux_output;

    
    assign mux_input[0] = shift_register[0];
    assign mux_input[1] = shift_register[1];
    assign mux_input[2] = shift_register[2];

    
    always @(posedge clk) begin
        if (enable) begin
            
            shift_register <= {shift_register[6:0], S};
        end
    end

    
    always @(*) begin
        case ({A, B, C})
            3'b000: mux_output = mux_input[0];
            3'b001: mux_output = mux_input[1];
            3'b010: mux_output = mux_input[2];
            default: mux_output = 8'b0;
        endcase
    end

    
    assign Z = mux_output;

endmodule
