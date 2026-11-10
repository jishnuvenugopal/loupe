
module TopModule (
    input clk,
    input reset,
    input slowena,
    output reg [3:0] q
);

    reg [3:0] counter4;
    reg [0:0] counter1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter4 <= 4'b0000;
            counter1 <= 1'b0;
        end else begin
            if (counter4 == 4'b0009) begin
                counter4 <= 4'b0000;
            end else begin
                counter4 <= counter4 + 1'b1;
            end

            if (counter1 == 1'b0) begin
                counter1 <= 1'b1;
            end else begin
                counter1 <= counter1 + 1'b1;
            end

            if (slowena) begin
                if (counter4 == 4'b0009) begin
                    counter4 <= 4'b0000;
                end else begin
                    counter4 <= counter4 + 1'b1;
                end

                if (counter1 == 1'b0) begin
                    counter1 <= 1'b1;
                end else begin
                    counter1 <= counter1 + 1'b1;
                end
            end
        end
    end

    assign q = counter4 << 1 | counter1;

endmodule
