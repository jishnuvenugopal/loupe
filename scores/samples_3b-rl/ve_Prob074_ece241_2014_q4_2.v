
module TopModule (
    input clk,
    input x,
    output z
);

    
    reg dff_xor, dff_and, dff_or;
    reg [2:0] state;
    reg xor_out, and_out, or_out;

    
    assign xor_out = x ^ dff_xor;

    
    assign and_out = x & ~dff_and;

    
    assign or_out = x | ~dff_or;

    
    always @(posedge clk) begin
        case (state)
            2'b00: dff_xor <= xor_out;
            2'b01: dff_and <= and_out;
            2'b10: dff_or <= or_out;
            default: dff_xor <= 1'b0;
        endcase
    end

    
    always @(posedge clk) begin
        case (state)
            2'b00: dff_xor <= xor_out;
            2'b01: dff_and <= and_out;
            2'b10: dff_or <= or_out;
            default: dff_and <= 1'b0;
        endcase
    end

    
    always @(posedge clk) begin
        case (state)
            2'b00: dff_xor <= xor_out;
            2'b01: dff_and <= and_out;
            2'b10: dff_or <= or_out;
            default: dff_or <= 1'b0;
        endcase
    end

    
    always @(*) begin
        z = ~(dff_xor ^ dff_and ^ dff_or);
    end

    
    initial begin
        dff_xor = 1'b0;
        dff_and = 1'b0;
        dff_or = 1'b0;
        state = 2'b00;
    end

endmodule
