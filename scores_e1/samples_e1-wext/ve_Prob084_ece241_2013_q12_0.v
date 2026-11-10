
module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    
    reg [7:0] shiftRegister;

    
    always @(posedge clk or posedge enable) begin
        if (enable) begin
            shiftRegister <= {shiftRegister[6:0], S};
        end
    end

    
    assign Z = {A, B, C}[3:0];

endmodule
