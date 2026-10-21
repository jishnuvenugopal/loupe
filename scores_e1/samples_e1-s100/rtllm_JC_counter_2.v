
module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);

    
    reg [63:0] Q_reg;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            
            Q_reg <= 64'b0;
        end else begin
            
            if (Q_reg[0] == 0) begin
                
                Q_reg <= Q_reg >> 1 | 1'b1;
            end else begin
                
                Q_reg <= Q_reg >> 1 | 1'b0;
            end
        end
    end

    
    assign Q = Q_reg;

endmodule
