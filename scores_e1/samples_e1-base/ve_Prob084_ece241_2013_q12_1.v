
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
            
            case (muxSelect)
                3'b000: Z = shiftRegister[0];
                3'b001: Z = shiftRegister[1];
                3'b010: Z = shiftRegister[2];
                3'b011: Z = shiftRegister[3];
                3'b100: Z = shiftRegister[4];
                3'b101: Z = shiftRegister[5];
                3'b110: Z = shiftRegister[6];
                3'b111: Z = shiftRegister[7];
            endcase
        end
    end

    
    always @(posedge clk or posedge enable) begin
        if (enable) begin
            muxSelect = {A, B, C};
        end
    end

endmodule
