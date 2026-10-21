
module TopModule (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output reg [7:0] min
);

    always @(posedge clk or negedge rst) begin
        if (rst) begin
            min <= 8'b10000000;
 
        end else begin
            if (a < b) begin
                if (a < c) begin
                    if (a < d) begin
                        min <= a;
                    end else begin
                        min <= d;
                    end
                end else begin
                    if (c < d) begin
                        min <= c;
                    end else begin
                        min <= d;
                    end
                end
            end else begin
                if (b < c) begin
                    if (b < d) begin
                        min <= b;
                    end else begin
                        min <= d;
                    end
                end else begin
                    if (c < d) begin
                        min <= c;
                    end else begin
                        min <= d;
                    end
                end
            end
        end
    end

endmodule
