
module TopModule (
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q
);

    
    wire [2:0] shamt;

    
    reg [63:0] shift_reg;

    
    always @(*) begin
        case (amount)
            2'b00: shamt = 3'b001;
 
            2'b01: shamt = 3'b100;
 
            2'b10: shamt = 3'b001;
 
            2'b11: shamt = 3'b100;
 
            default: shamt = 3'b000;
 
        endcase
    end

    
    always @(posedge clk) begin
        if (load) begin
            shift_reg <= data;
        end else if (ena) begin
            case (shamt)
                3'b001: shift_reg <= {shift_reg[62:0], 1'b0};
 
                3'b001: shift_reg <= {shift_reg[0], shift_reg[63:1]};
 
                3'b100: shift_reg <= {shift_reg[55:0], 8'b00000000};
 
                3'b100: shift_reg <= {8'b00000000, shift_reg[55:0]};
 
                default: ;
 
            endcase
        end
    end

    
    assign q = shift_reg;

endmodule
