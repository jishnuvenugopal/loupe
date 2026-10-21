
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

    
    reg [2:0] selector;
    reg [7:0] outputFromMultiplexer;

    
    reg [2:0] inputSelector;
    reg [7:0] inputFromMultiplexer;

    
    always @(posedge clk or posedge enable) begin
        if (enable) begin
            
            shiftRegister = {shiftRegister[6:0], S};

            
            case (ABC)
                3'b000: selector = 3'b000;
                3'b001: selector = 3'b001;
                3'b010: selector = 3'b010;
                3'b011: selector = 3'b011;
                3'b100: selector = 3'b100;
                3'b101: selector = 3'b101;
                3'b110: selector = 3'b110;
                3'b111: selector = 3'b111;
            endcase

            
            case (ABC)
                3'b000: inputSelector = 3'b000;
                3'b001: inputSelector = 3'b001;
                3'b010: inputSelector = 3'b010;
                3'b011: inputSelector = 3'b011;
                3'b100: inputSelector = 3'b100;
                3'b101: inputSelector = 3'b101;
                3'b110: inputSelector = 3'b110;
                3'b111: inputSelector = 3'b111;
            endcase

            
            outputFromMultiplexer = inputFromMultiplexer[selector];

            
            Z = outputFromMultiplexer;
        end
    end

endmodule
