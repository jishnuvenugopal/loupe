
module TopModule (
    input wire clk,
    input wire reset,
    output reg [3:0] q,
    output reg [3:0] ena
);


reg [3:0] ones_counter;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        ones_counter <= 4'b0000;
    end else begin
        ones_counter <= ones_counter + 1'b1;
    end
end


reg [3:0] tens_counter;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        tens_counter <= 4'b0000;
    end else begin
        tens_counter <= tens_counter + 1'b1;
    end
end


reg [3:0] hundreds_counter;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        hundreds_counter <= 4'b0000;
    end else begin
        hundreds_counter <= hundreds_counter + 1'b1;
    end
end


reg [3:0] thousands_counter;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        thousands_counter <= 4'b0000;
    end else begin
        thousands_counter <= thousands_counter + 1'b1;
    end
end


reg [3:0] enable;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        enable <= 4'b0000;
    end else begin
        enable <= enable + 1'b1;
    end
end


assign q[3:0] = ones_counter;
assign q[7:4] = tens_counter;
assign q[11:8] = hundreds_counter;
assign q[15:12] = thousands_counter;


assign ena = enable;

endmodule
