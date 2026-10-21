
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output [15:0] q
);

    
    reg [15:0] flip_flops [0:15];

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            
            for (int i = 0;
 i < 16;
 i = i + 1) begin
                flip_flops[i] <= 16'b0;
            end
        end else begin
            
            for (int i = 0;
 i < 16;
 i = i + 1) begin
                if (byteena[1] && i < 8) begin
                    flip_flops[i] <= d[15:8];
                end else if (byteena[0] && i >= 8) begin
                    flip_flops[i] <= d[7:0];
                end else begin
                    flip_flops[i] <= flip_flops[i];
                end
            end
        end
    end

    
    assign q = flip_flops;

endmodule
