
module TopModule (
    input clk,
    input load,
    input data (512 bits),
    output q    (512 bits)
);

    reg [511:0] state;

    always @(posedge clk) begin
        if (load) begin
            state <= data;
        end else begin
            state <= state[510:0] ^ state[511] ^ state[0];
        end
    end

    assign q = state;

endmodule
