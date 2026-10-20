
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
        
        shift_register[3] <= shift_register[2];
        shift_register[2] <= shift_register[1];
        shift_register[1] <= shift_register[0];
        shift_register[0] <= in;
    end

    
    assign out = shift_register[3];

endmodule
