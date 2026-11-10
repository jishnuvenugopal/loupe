
module TopModule (
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q
);

    
    reg [99:0] reg_state;

    
    reg [1:0] enable;

    
    reg load_reg;

    
    always @(posedge clk or posedge load_reg) begin
        if (load_reg) begin
            
            reg_state <= data;
            load_reg <= 0;
        end else begin
            
            case (ena)
                2'b01: reg_state <= {reg_state[99], reg_state[98:0]};
                2'b10: reg_state <= {reg_state[0:99], reg_state[99]};
                2'b00: reg_state <= reg_state;
                2'b11: reg_state <= reg_state;
            endcase
        end
    end

    
    assign q = reg_state;

endmodule
