
module TopModule (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);

    
    reg [15:0] flipflops[15:0];

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            
            foreach (flipflops[i]) begin
                flipflops[i] <= 16'b0;
            end
        end else begin
            
            foreach (flipflops[i]) begin
                if (byteena[1] == 1'b1) begin
                    flipflops[i] <= d[15:8];
                end
                if (byteena[0] == 1'b1) begin
                    flipflops[i] <= d[7:0];
                end
            end
        end
    end

    
    assign q = flipflops;

endmodule
