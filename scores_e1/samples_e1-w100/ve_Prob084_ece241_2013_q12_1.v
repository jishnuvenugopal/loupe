
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

    
    reg [2:0] muxSelect;

    
    always @(posedge clk or posedge enable) begin
        if (enable) begin
            
            shiftRegister = {S, shiftRegister[6:0]};
            
            muxSelect = {A, B, C};
            
            Z = shiftRegister[muxSelect];
        end
    end

endmodule
