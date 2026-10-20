
module TopModule (
    input  wire clk,
    input  wire load,
    input  wire [9:0] data,
    output reg  tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else begin
            if (counter != 0) begin
                counter <= counter - 1;
            end
        end
    end

    always @(*) begin
        if (counter == 0) begin
            tc = 1;
        end else begin
            tc = 0;
        end
    end

endmodule
