
module TopModule (
    input  clk,
    input  reset,
    output reg [3:0] q
);

    reg [3:0] counter;
    reg [0:0] reset_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 4'b0000;
            reset_reg <= 1'b1;
        end else begin
            if (reset_reg == 1'b1) begin
                counter <= 4'b0000;
                reset_reg <= 1'b0;
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

    always @(posedge clk) begin
        if (counter == 4'b0101) begin
            q <= 4'b0110;
        end else if (counter == 4'b0110) begin
            q <= 4'b0111;
        end else if (counter == 4'b0111) begin
            q <= 4'b1000;
        end else if (counter == 4'b1000) begin
            q <= 4'b1001;
        end else if (counter == 4'b1001) begin
            q <= 4'b1010;
        end else if (counter == 4'b1010) begin
            q <= 4'b1011;
        end else if (counter == 4'b1011) begin
            q <= 4'b1100;
        end else if (counter == 4'b1100) begin
            q <= 4'b1101;
        end else if (counter == 4'b1101) begin
            q <= 4'b1110;
        end else if (counter == 4'b1110) begin
            q <= 4'b1111;
        end else if (counter == 4'b1111) begin
            q <= 4'b0000;
        end
    end

endmodule
