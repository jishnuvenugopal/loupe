
module TopModule(input wire clk, input wire resetn, input wire [1:0] byteena, input wire [15:0] d, output reg [15:0] q);

reg [15:0] dff [0:15];

always @(posedge clk or negedge resetn) begin
    if (!resetn) begin
        foreach (dff[i]) dff[i] <= 16'b0;
        q <= 16'b0;
    end else begin
        if (byteena[1]) begin
            dff[15] <= d[15];
            dff[14] <= d[14];
            dff[13] <= d[13];
            dff[12] <= d[12];
        end
        if (byteena[0]) begin
            dff[11] <= d[11];
            dff[10] <= d[10];
            dff[9]  <= d[9];
            dff[8]  <= d[8];
        end
        q <= {dff[15], dff[14], dff[13], dff[12], dff[11], dff[10], dff[9], dff[8]};
    end
end

endmodule
