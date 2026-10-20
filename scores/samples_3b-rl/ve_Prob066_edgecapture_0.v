
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire [31:0] in,
    output reg [31:0] out
);

    
    reg [31:0] prev_in;
    reg [31:0] curr_in;

    
    reg [31:0] out_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            out_reg <= 32'b0;
        end else begin
            
            out_reg <= 32'b0;
            for (integer i = 0;
 i < 32;
 i = i + 1) begin
                if (prev_in[i] && !curr_in[i])
                    out_reg[i] <= 1'b1;
            end
        end
    end

    
    always @(posedge clk) begin
        prev_in <= curr_in;
        curr_in <= in;
    end

    
    assign out = out_reg;

endmodule
