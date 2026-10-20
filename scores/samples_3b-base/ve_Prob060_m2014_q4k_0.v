
module TopModule (
    input  clk,
    input  resetn,
    input  in,
    output out
);

    
    reg [3:0] shift_register;

    
    always @(posedge resetn) begin
        shift_register <= 4'b0;
    end

    
    always @(posedge clk) begin
        
        shift_register <= {shift_register[2:0], in};

        
        out <= shift_register[3];
    end

endmodule
