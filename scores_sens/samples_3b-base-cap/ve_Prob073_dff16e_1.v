
module TopModule (
    input  clk,
    input  resetn,
    input  byteena,  
    input  [15:0] d,   
    output [15:0] q    
);

    
    reg [15:0] dffs [0:15];

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            for (int i = 0;
 i < 16;
 i++) begin
                dffs[i] <= 16'b0;
            end
        end
    end

    
    always @(posedge clk) begin
        if (byteena[1]) begin
            dffs[15] <= d[15:8];
        end
        if (byteena[0]) begin
            dffs[0] <= d[7:0];
        end
    end

    
    assign q = dffs;

endmodule
