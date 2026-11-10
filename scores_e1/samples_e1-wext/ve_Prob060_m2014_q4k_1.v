
module TopModule (
    input clk,
    input resetn,
    input in,
    output out
);

    
    reg [3:0] shiftRegister;

    
    always @(posedge clk or posedge resetn) begin
        if (!resetn) begin
            shiftRegister <= 4'b0000;
 
        end else begin
            shiftRegister <= {shiftRegister[2:0], in};
 
        end
    end

    
    assign out = shiftRegister[3];

endmodule
