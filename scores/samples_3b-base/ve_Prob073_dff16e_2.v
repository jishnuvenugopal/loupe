
module TopModule (
    input  clk,
    input  resetn,
    input  [1:0] byteena,
    input  [15:0] d,
    output [15:0] q
);

    
    reg [15:0] q_reg [0:15];

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            for (int i = 0;
 i < 16;
 i++) begin
                q_reg[i] <= 16'b0;
            end
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 16;
 i++) begin
            if (byteena[1] && (i >= 8)) begin
                q_reg[i] <= d[15:8];
            end else if (byteena[0] && (i < 8)) begin
                q_reg[i] <= d[7:0];
            end
        end
    end

    
    assign q = q_reg;

endmodule
