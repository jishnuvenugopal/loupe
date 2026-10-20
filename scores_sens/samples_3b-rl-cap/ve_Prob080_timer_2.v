
module TopModule (
    input clk,
    input load,
    input [9:0] data,
    output reg tc
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (load) begin
            counter <= data;
        end else begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                tc <= 1;
            end
        end
    end

    
    
    initial begin
        counter <= 10;
    end

endmodule
