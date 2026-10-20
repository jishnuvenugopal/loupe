
module fsm (
    input        CLK,
    input        RST,
    input        IN,
    output reg   MATCH
);

    
    reg [4:0] seq_reg;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            seq_reg <= 5'b0;
            MATCH   <= 1'b0;
        end else begin
            
            seq_reg <= {seq_reg[3:0], IN};
            
            if (seq_reg == 5'b10011) begin
                MATCH <= 1'b1;
            end else begin
                MATCH <= 1'b0;
            end
        end
    end

endmodule
