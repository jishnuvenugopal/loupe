
module TopModule (
    input clk,
    input load,
    input data (512 bits),
    output reg [511:0] q (512 bits)
);

    
    always @(*) begin
        if (load) begin
            q <= data;
        end else begin
            for (int i = 0;
 i < 512;
 i++) begin
                if (i == 0) begin
                    q[i] = q[511] ^ q[1];
                end else if (i == 511) begin
                    q[i] = q[0] ^ q[4];
                end else begin
                    q[i] = q[i-1] ^ q[i+1];
                end
            end
        end
    end

endmodule
