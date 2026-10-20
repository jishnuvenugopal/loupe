
module TopModule (
    input  clk,
    input  load,
    input  ena,
    input  [1:0] amount,
    input  [63:0] data,
    output reg [63:0] q
);

    
    reg [63:0] shift_reg;

    
    always @(posedge clk) begin
        if (load) begin
            
            shift_reg <= data;
        end else if (ena) begin
            case (amount)
                2'b00: begin 
                    shift_reg <= {shift_reg[63:1], shift_reg[0]};
                end
                2'b01: begin 
                    shift_reg <= {shift_reg[55:0], shift_reg[63:56]};
                end
                2'b10: begin 
                    shift_reg <= {shift_reg[1], shift_reg[63:0]};
                end
                2'b11: begin 
                    shift_reg <= {shift_reg[63:8], shift_reg[7:0]};
                end
            endcase
        end
    end

    
    assign q = shift_reg;

endmodule
